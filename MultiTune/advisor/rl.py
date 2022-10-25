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
from .base import Advisor
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

class RL(Advisor):
    def __init__(self,  **kwargs):

        super().__init__(**kwargs)

        self.config_space = self.setup_config_space(self.arm_type, self.db)




    @staticmethod
    def setup_config_space(arm_type, db=None):
        config_space = ConfigurationSpace()

        if arm_type == 'index':
            all_index = sorted(db.all_index_candidates)
            for c in all_index:
                name = 'index.{}'.format(c)
                hp = CategoricalHyperparameter(name, ['off', 'on'])
                config_space.add_hyperparameter(hp)

        if arm_type == 'knob' :
            all_knob = sorted(db.knob_details.keys())
            for k in all_knob:
                v = db.knob_details[k]
                name = 'knob.{}'.format(k)
                knob_type = v['type']
                if knob_type == 'enum':
                    hp = CategoricalHyperparameter(name, [i for i in v["enum_values"]])
                elif knob_type == 'integer':
                    min_val, max_val = v['min'], v['max']
                    if max_val > sys.maxsize:
                        # scale
                        hp = UniformIntegerHyperparameter(name, int(min_val / 1000), int(max_val / 1000),
                                                          default_value=int(v['default'] / 1000))
                    else:
                        hp = UniformIntegerHyperparameter(name, min_val, max_val, default_value=v['default'])
                elif knob_type == 'float':
                    min_val, max_val = v['min'], v['max']
                    hp = UniformFloatHyperparameter(name, min_val, max_val, default_value=v['default'])
                else:
                    raise ValueError('Invalid knob type!')
                config_space.add_hyperparameter(hp)

        return config_space




    def reset_context(self,context, metric):
        self.current_context = context
        self.current_state = context
        self.metric = metric


    def run(self):
        time_b = time.time()
        done = False
        best_config = None
        for episode in range(2):
            self.logger.info('env initializing')
            self.current_state = self.current_context
            self.default_external_metrics = self.metric
            self.last_external_metrics = self.metric
            best_lat = self.metric
            self.logger.info('[Env initialized][Metrics execution time:{} ]'.format(self.metric ))
            self.model.reset(self.sigma)
            t = 0

            while t<5:#True:
                time_begin_iter = time.time()
                if time.time() - time_b > self.sub_budget:
                    return best_config, best_lat

                self.logger.info('entering episode{}s step{}'.format(episode, t))

                current_knob = self.Suggest()
                (metrics, time_cost), space_cost,  next_state = self.db.evaluate(add_prefix(current_knob))
                #metrics,time_cost,space_cost = np.random.uniform(0,600),np.random.uniform(0,600),0
                #state_ = np.random.uniform(size=65)

                with open(self.output_file, 'a') as f:
                    f.write('{}\n'.format({
                        'configuration': current_knob,
                        'time_cost': [metrics, time_cost],
                        'space_cost': space_cost,
                        'time_spent': time.time() - time_begin_iter,
                        'context':  self.current_context.tolist(),
                        'arm': 'knob_' + str(self.pull_num)
                    }))

                self.UpdatePolicy(metrics, next_state, done)
                if metrics < best_lat:
                    best_lat = metrics
                    best_config = add_prefix(current_knob)
                self.current_state = next_state



                t += 1
                self.logger.info('The end of global step {}.'.format(self.step_counter))
                self.step_counter += 1




                if done or self.score < -50:
                    break

        return best_config, best_lat



if __name__ == "__main__":

    args_db, args_tune = parse_args('/data2/ruike/MultiTune/config.ini')
    args = parse_cmd_args()
    db = MysqlDB(args_tune['task_id'], **args_db)
    adviser = RL(db=db, tune_index='False', tune_knob='True', **args_tune)
    adviser.reset_contex(np.random.uniform(size=65), 570)
    adviser.run()


