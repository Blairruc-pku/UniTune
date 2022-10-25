#!/usr/bin/env python
import pickle
import random
import math
import hashlib
import logging
import argparse
import json
import pdb
import sys
import os
import time
import numpy as np
sys.path.append('..')
from .rl import RL
from openbox.utils.config_space import ConfigurationSpace, CategoricalHyperparameter, \
    UniformIntegerHyperparameter, UniformFloatHyperparameter
from .query_rewrite.configs import parse_cmd_args
from MultiTune.utils.limit import time_limit,  TimeoutException
from MultiTune.utils.ddpg.ddpg import DDPG
sys.path.append('/data2/ruike/MultiTune')
from MultiTune.utils.parser import parse_args, initialize_knobs, gen_continuous
from MultiTune.database.base import DB
from MultiTune.database.mysqldb import MysqlDB


def create_output_folders():
    output_folders = ['ddpg', 'ddpg/save_memory', 'ddpg/model_params']
    for folder in output_folders:
        if not os.path.exists(folder):
            os.mkdir(folder)

def add_prefix(knob):
    knob_prefix = {}
    for k in knob.keys():
        knob_prefix['knob.' + k] = knob[k]

    return knob_prefix

class CDBTune(RL):
    def __init__(self,  knobs_num=50,
                 metrics_num=65,
                 initial_trials=5,
                 mean_var_file='',
                 batch_size=8,
                 params='', **kwargs):

        super().__init__(**kwargs)

        self.knobs_num = knobs_num
        self.metrics_num = metrics_num
        self.batch_size = eval(batch_size)
        self.params = params
        self.init_num = initial_trials
        self.sigma = 0.2
        self.noisy = False
        ts = int(time.time())
        self.expr_name = 'train_{}'.format(ts)
        self.mean_var_file = mean_var_file
        self.internal_metrics = []
        #Hard code
        with open('/data2/ruike/IndexTool/optimize_history/tpch_0725_rb.res', 'r') as f:
            lines = f.readlines()
            lines = [line for line in lines if (not 'best|' in line) and (not 'observe-context|' in line)]
            for line in lines:
                if 'context' in line:
                    tmp = eval(line)
                    im = tmp['context']
                    self.internal_metrics.append(im)


        self.state_mean = None
        self.state_var = None
        self.model = None
        self.init_step = 0
        self.episode = 0
        self.step_counter= 0
        self.train_step = 0
        self.t = 0
        self.score = 0
        self.episode_init = True
        create_output_folders()
        initialize_knobs(self.db.knob_config_file, 50)

        if self.mean_var_file != '' and os.path.exists(self.mean_var_file):
            with open(self.mean_var_file, 'rb') as f:
                self.state_mean = pickle.load(f)
                self.state_var = pickle.load(f)
        else:

            if len(self.internal_metrics) >= self.init_num:
                self.gen_mean_var()

        if not self.create_model():
            self.logger.info('Calculate state mean and var.')



    def create_model(self):
        if (self.state_mean is None) or (self.state_var is None):
            return False

        ddpg_opt = {
            'tau': 0.002,
            'alr': 0.001,
            'clr': 0.001,
            'gamma': 0.9,
            'memory_size': 100000,
            'batch_size': self.batch_size,
            'model': self.params,
        }

        self.model = DDPG(n_states=self.metrics_num,
                          n_actions=self.knobs_num,
                          opt=ddpg_opt,
                          ouprocess=True,
                          mean=self.state_mean,
                          var=self.state_var)

        return True

    def gen_mean_var(self):
        r = np.array(self.internal_metrics)
        self.state_mean = r.mean(axis=0)
        self.state_var = r.var(axis=0)

        if self.mean_var_file == '':
            self.mean_var_file = '{}_mean_var.pkl'.format(self.task_id)

        with open(self.mean_var_file, 'wb') as f:
            pickle.dump(self.state_mean, f)
            pickle.dump(self.state_var, f)



    def get_reward(self, external_metrics):

        def calculate_reward(delta0, deltat):
            if delta0 > 0:
                _reward = ((1 + delta0) ** 2 - 1) * math.fabs(1 + deltat)
            else:
                _reward = - ((1 - delta0) ** 2 - 1) * math.fabs(1 - deltat)

            if _reward > 0 and deltat < 0:
                _reward = 0
            return _reward

        if external_metrics == 0 or self.default_external_metrics == 0:
            # bad case, not enough time to restart mysql or bad knobs
            return 0
        # lat
        delta_0 = float((-external_metrics + self.default_external_metrics)) / self.default_external_metrics
        delta_t = float((- external_metrics + self.last_external_metrics)) / self.last_external_metrics
        reward = calculate_reward(delta_0, delta_t)
        self.score += reward

        return reward



    def Suggest(self):
        state = self.current_state
        if self.noisy:
            self.model.sample_noise()

        if np.random.random() < 0.7:  # avoid too nus reward in the fisrt 100 step
            self.action = self.model.choose_action(state, 1 / (self.step_counter + 1))
            # logger.info('[ddpg] Action: {}'.format(action))
        else:
            self.action = self.model.choose_action(state, 1)
            # logger.info('[ddpg] Action: {}'.format(action))

        self.logger.info('[ddpg] Action: {}'.format(self.action))
        current_knob = gen_continuous(self.action)
        return current_knob

    def UpdatePolicy(self, metrics, next_state, done):
        reward = self.get_reward(metrics)
        self.last_external_metrics = metrics
        self.logger.info('[RL][Metric  lat:{}][Reward: {} Score: {}]'.format(metrics, reward, self.score
        ))

        self.model.add_sample(self.current_state, self.action, reward, next_state, done)
        if len(self.model.replay_memory) > self.batch_size:
            losses = []

            for _ in range(4):
                losses.append(self.model.update())
                self.train_step += 1
                # save replay memory
        if self.step_counter % 10 == 0:
            self.model.replay_memory.save('ddpg/save_memory/{}.pkl'.format(self.expr_name))

        if self.step_counter % 5 == 0:
            self.model.save_model('ddpg/model_params', title='{}_{}'.format(self.expr_name, self.step_counter))



