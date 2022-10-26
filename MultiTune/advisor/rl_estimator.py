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
import sqlparse
import time
import shutil
from colorama import Fore, Back, Style

import jpype as jp
from jpype.types import *
from collections import defaultdict
import jpype.imports
sys.path.append('..')
from .base import Advisor
#from .query_rewrite.mcts import
from .query_rewrite.rewriter import rewrite
from .query_rewrite.cost_estimator import  CostEstimator, CostEstimator_WithoutContext
from .query_rewrite.configs import parse_cmd_args
from MultiTune.utils.limit import time_limit,  TimeoutException
sys.path.append('//MultiTune')
from MultiTune.utils.parser import parse_args
from MultiTune.database.base import DB
from MultiTune.database.mysqldb import MysqlDB


class RLEstimator(Advisor): 
    def __init__(self, current_context=None, **kwargs):
        super().__init__(**kwargs)
        if not current_context is None:
            self.estimator = CostEstimator(db=self.db,  task_id=kwargs['task_id'])
            self.reset_context(current_context)
        else:
            self.estimator = CostEstimator_WithoutContext(db=self.db, task_id=kwargs['task_id'])

        self.rewrite_resultL = defaultdict(list)
        self.evaluatedL = defaultdict(list)
        self.test = eval(kwargs['test'])
        self.step = 0


    def run(self, base=0):

        incL = list()
        self.estimator.reinit()
        if self.cost_aware:
            time_enter = time.time()
        self.estimator.cost_init = True
        time_cost_best = 1e9
        config_best = None
        #self.rewrite_resultL = list()
        i = 0
        finish_rewrite = False
        time_begin = time.time()

        evaluate_flag = False
        while True:
            suggest_result = self.Suggest(i)
            #print("Iteration {}".format(i))
            #suggest_result = self.rewrite_sql(i)
            #self.add_rewrite_result(suggest_result, self.evaluatedL[self.estimator.current_context])

            if self.cost_aware:
                if time.time() - time_enter >= self.sub_budget and evaluate_flag:
                    self.pull_num = self.pull_num + 1
                    return config_best, time_cost_best
                budget_left = self.sub_budget - (time.time() - time_enter)

            eval_dir = self.estimator.gen_eval_dir()
            gen_evaluated_result = True
            # if we have eval_dir not empty, we conduct supply

            if len(eval_dir.keys()) and not i == self.block_runs - 1 and (not self.cost_aware or budget_left > self.db.workload_timeout):
                gen_evaluated_result = self.check_all_query(eval_dir.keys())
                time_all, space_cost, config = self.estimator.conduct_supply(eval_dir)
                self.UpdatePolicy(eval_dir)

                time_cost = time_all[0]
            else : # else we evaluate performance
                if len(self.rewrite_resultL[self.estimator.current_context]) > 0:
                    evaluate_query = self.rewrite_resultL[self.estimator.current_context].pop()
                else:
                    evaluate_query = suggest_result
                    finish_rewrite = True
                self.evaluatedL[self.estimator.current_context].append(evaluate_query)
                time_all, space_cost, config = self.estimator.evaluate(evaluate_query)
                time_cost = time_all[0]
            if gen_evaluated_result: #if the queries we run can be used to evaluate the performance
                if time_cost < time_cost_best:
                    time_cost_best = time_cost
                    config_best = config
                
                with open(self.output_file, 'a') as f:
                    f.write('{}\n'.format({
                        'configuration': config,
                        'time_cost': time_all,
                        'space_cost': space_cost,
                        'context': self.estimator.current_context,
                        'time_spent': time.time() - time_begin,
                         'arm': 'query_' + str(self.pull_num)
                    }))
                evaluate_flag = True
                time_begin = time.time()

            incL.append(time_cost_best)
            if self.converage_judge and len(incL) > 5 and (incL[-5] - incL[-1]) / incL[-5] < 0.005:
                break

            if evaluate_flag and (
                    (self.cost_aware and time.time() - time_enter > self.sub_budget)
                    or (not self.cost_aware and i >= self.block_runs)
                    or finish_rewrite
            ):
                self.pull_num = self.pull_num + 1
                base_dir = os.path.abspath(os.curdir)
                self.estimator.parser = None
                self.estimator.model = None
                with open(os.path.join(base_dir, '{}.pkl'.format(self.task_id)), 'wb') as f:
                    pickle.dump(self.estimator, f)
                return config_best, time_cost_best

            i = i + 1



def record(time, label):
    with open("time.res", 'a') as f:
        f.write(label + '_' + str(time) +'\n')



if __name__ == "__main__":

    args_db, args_tune = parse_args()
    args = parse_cmd_args()
    db = MysqlDB(args_tune['task_id'], **args_db)
    adviser = RLEstimator(db=db, **args_tune)
    adviser.run()


