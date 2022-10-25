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
from .rl_estimator import RLEstimator
#from .query_rewrite.mcts import
from .query_rewrite.rewriter import rewrite
from .query_rewrite.cost_estimator import  CostEstimator, CostEstimator_WithoutContext
from .query_rewrite.configs import parse_cmd_args
from MultiTune.utils.limit import time_limit,  TimeoutException
sys.path.append('/data2/ruike/MultiTune')
from MultiTune.utils.parser import parse_args
from MultiTune.database.base import DB
from MultiTune.database.mysqldb import MysqlDB


class LearnedRewrite(RLEstimator):
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

    def add_rewrite_result(self, rewrite_result, evaluatedL):
        # if evaluated, not add
        for item in evaluatedL:
            flag_exist = True
            for key in item.keys():
                if not key in rewrite_result.keys() or not item[key] == rewrite_result[key]:
                    flag_exist = False
                    continue
            if flag_exist:
                return

        # not evaluated
        for item in self.rewrite_resultL[self.estimator.current_context]:
            flag_exist = True
            for key in item.keys():
                if not key in rewrite_result.keys() or not item[key] == rewrite_result[key]:
                    flag_exist = False
                    continue
            if flag_exist:
                self.rewrite_resultL[self.estimator.current_context].remove(item)
                break

        self.rewrite_resultL[self.estimator.current_context].append(rewrite_result)

    def check_all_query(self, querys):
        typeL = set()
        print("queries:{}\n".format(querys))
        for q in querys:
            if '_' in q:
                q = q.split('_')[0]
            elif '.' in q:
                q = q.split('.')[0]
            typeL.add(q)

        if len(typeL) == self.estimator.budget:
            return True
        else:
            print("It is not ok for performance evaluated!\n")
            return False


    
    def Suggest(self, i):
       suggest_result = self.rewrite_sql(i)
       self.add_rewrite_result(suggest_result, self.evaluatedL[self.estimator.current_context])

    def UpdatePolicy(self, eval_dir):
        self.estimator.update_record(eval_dir)
        self.estimator.update_model()


    def rewrite_sql(self, iteration):
        sql_file = open(self.db.workload_qlist_file, 'r')
        sql_types = sql_file.readlines()
        rewrite_result = {}
        args = parse_cmd_args()
        for cnt, type in enumerate(sql_types):
            type = type.strip()
            self.estimator.current_query_type = type
            f = open(os.path.join(self.db.workload_qdir, type))
            if self.db.workload_name == 'job':
                sql = f.readlines()[0].strip().strip().lower()
            else:
                sql = f.readlines()[0].strip().strip().upper()
            f.close()
            origin_runtime = self.estimator.previous_cost_estimation_rf(sql, sql, [], record_rules=[])
            #print(str(type) + " origin runtime: " + str(origin_runtime))
            #rewritten_sql, rewrite_sequence = rewrite(args, self.db, self.estimator, origin_runtime, type, sql)
            #print("--------------------------------")

            time_limit_per_trial = 180
            try:
                with time_limit(time_limit_per_trial):
                    rewritten_sql, rewrite_sequence = rewrite(args, self.db, self.estimator, origin_runtime, type, sql)
            except  Exception as e:
                if isinstance(e, TimeoutException):
                    self.logger.info("Timed out!")
                else:
                    self.logger.info('{}: Exception when calling objective function: {}'.format(type,e))
                rewrite_result[type] = (sql, None, [])
                continue

            rewritten_runtime = self.estimator.previous_cost_estimation_rf(sql, rewritten_sql, rewrite_sequence, record_rules=rewrite_sequence)
            self.logger.info(type + " origin runtime: " + str(origin_runtime) + ", after-rewrite runtime: " + str(  rewritten_runtime) + ", rules:" + str(rewrite_sequence))
            f_out = "rewrite_result/sql_rf_{}.json".format(iteration)
            if os.path.exists(f_out):
                f = open(f_out, 'r')
                result_dir = json.load(f)
            else:
                result_dir = {}

            result_dir[type] = {}
            result_dir[type]['origin_runtime'] = origin_runtime  # origin_runtime
            result_dir[type]['rewrite_runtime'] = rewritten_runtime
            #result_dir[type]['origin_cost'] = self.estimator.previous_cost_estimation(sql, sql, [])  # origin_runtime
            #result_dir[type]['rewrite_cost'] = self.estimator.previous_cost_estimation(sql, rewritten_sql, rewrite_sequence)  # rewritten_runtime
            result_dir[type]['sql'] = sql
            result_dir[type]['rewritten_sql'] = rewritten_sql
            result_dir[type]['rewrite_sequence'] = rewrite_sequence

            with open(f_out, 'w') as fp:
                json.dump(result_dir, fp, indent=4)

            rewrite_result[type] = (rewritten_sql, None, rewrite_sequence)

            #print("--------------------------------")

        return rewrite_result

    def reset_context(self, context):
        self.estimator.current_context = tuple(context)

def record(time, label):
    with open("time.res", 'a') as f:
        f.write(label + '_' + str(time) +'\n')



if __name__ == "__main__":

    args_db, args_tune = parse_args()
    args = parse_cmd_args()
    db = MysqlDB(args_tune['task_id'], **args_db)
    adviser = RLEstimator(db=db, **args_tune)
    adviser.run()


