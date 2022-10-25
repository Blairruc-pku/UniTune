import json
import os
import pdb
import pandas as pd
import numpy as np
import time
import shutil
import sys
from sklearn.decomposition import PCA
from sklearn.preprocessing import MinMaxScaler
from collections import defaultdict


from openbox.surrogate.base.rf_with_instances import RandomForestWithInstances
from  openbox.surrogate.base.rf_with_contexts import RandomForestWithContexts





def encode_rules(rules):
    rules_vec = np.zeros(56)
    for rule in rules:
        rules_vec[rule] =  rules_vec[rule] + 1
    return rules_vec

class CostEstimator():
    def __init__(self, db, task_id):
        self.db = db
        self.context_dir = {}
        #self.pca = PCA(n_components=10, svd_solver='full')
        self.pca = PCA(n_components=20)
        self.current_context = None #tuple(np.load('/data2/ruike/MultiTune/best_im.npy', encoding='bytes', allow_pickle=True))
        self.scaler = MinMaxScaler()
        self.parser = self.init_parser()
        self.current_query_type = None
        self.demand = {}
        self.supply = defaultdict(dict)
        self.budget = len(open(self.db.workload_qlist_file).readlines())
        print("budget:{}".format(self.budget))
        self.query_timestamp = 0
        self.cost_init = True
        self.task_id =  task_id
        self.cache_sql2vec = {}
        self.logger = self.db.logger



    def sql2vec(self, parser, sql):
        if sql in self.cache_sql2vec.keys():
            return self.cache_sql2vec[sql]

        vec = parser.query_encoding(sql.replace('`', ''))[4:]
        self.cache_sql2vec[sql] = vec

        return vec


    def init_parser(self):
        sys.path.append('../query_rewrite')
        from .featurization import SqlParser
        argus = {}
        argus["host"] = self.db.host
        argus["user"] = self.db.user
        argus["password"] = self.db.passwd
        argus["port"] = self.db.port
        argus["database"] = self.db.dbname
        parser = SqlParser(argus)
        self.parser = parser
        return parser

    def reinit(self):
        self.init_parser()
        if hasattr(self, "X"):
            self.update_model()

    def update_model(self):
        X_pro = self.scaler.fit_transform(self.X)
        X_pro = np.nan_to_num(X_pro)  # if features with max == min
        # PCA
        n_components = 20 if self.X.shape[0] > 20 else self.X.shape[0]
        self.pca = PCA(n_components=n_components)

        X_pro = self.pca.fit_transform(X_pro)
        types = np.zeros(X_pro.shape[1], dtype=np.uint)
        bounds = [(np.nan, np.nan)] * types.shape[0]
        for i in range(types.shape[0]):
            bounds[i] = (X_pro[:, i].min(), X_pro[:, i].max())


        self.model = RandomForestWithInstances(types=types, bounds=bounds, seed=42)
        self.model.train(X_pro, self.y.copy())


    def update_record(self, eval_dir):
        if not len(eval_dir.keys()):
            print("[Cost estimator] No record to update!")
            return

        _X, _y= [], []
        for key in eval_dir:
            sql = eval_dir[key]
            result = self.supply[self.current_context][sql[0]]
            _y.append(result)
            _X.append(sql[1])

        _y = np.array(_y)
        _X = np.vstack(_X)
        '''if os.path.exists("/data2/ruike/query_rewrite/LearnedRewrite/X.npy"):
            X_load = np.load("/data2/ruike/query_rewrite/LearnedRewrite/X.npy",  encoding='bytes', allow_pickle=True)
            y_load = np.load("/data2/ruike/query_rewrite/LearnedRewrite/y.npy", encoding='bytes', allow_pickle=True)
            X_dump = np.vstack((X_load, _X))
            y_dump = np.hstack((y_load, _y))
        else:
            X_dump = _X
            y_dump = _y
        '''


        if self.cost_init:
            self.X = _X
            self.y = _y
            self.cost_init = False
        else:

            self.X = np.vstack((self.X, _X))
            self.y = np.hstack((self.y, _y))
            base_dir = os.path.abspath(os.curdir)
            self.X.dump( os.path.join(base_dir, "X_{}.npy".format(self.task_id)))
            self.y.dump( os.path.join(base_dir, "y_{}.npy".format(self.task_id)))


    def previous_cost_estimation_rf(self,origin_sql, rewrite_sql, rewrite_sequence, context=None, record_rules=None):
        rewrite_sql = rewrite_sql.replace('\n', ' ')
        if context is None:
            context = np.asarray(self.current_context)

        if self.current_context in self.supply.keys() and \
                rewrite_sql in self.supply[self.current_context].keys():

            return self.supply[self.current_context][rewrite_sql]

        origin_sql = self.sql2vec(self.parser, origin_sql)
        rewrite_sql_ = self.sql2vec(self.parser, rewrite_sql)
        rule = encode_rules(rewrite_sequence)
        vec = np.hstack((origin_sql, rewrite_sql_, rule, context)).reshape(1, -1)


        if self.cost_init:
            score =  self.previous_cost_estimation(origin_sql, rewrite_sql, rewrite_sequence)
        else:
            vec_pro = self.scaler.transform(vec)
            vec_pro = self.pca.transform(vec_pro)
            mean, var = self.model.predict(vec_pro)
            if not var.item() == 0:
                std = np.std(var.item())
            else:
                std = 0
            score = mean.item() - std

        if not self.current_context in self.demand.keys():
            self.demand[self.current_context] = defaultdict(list)

        if not self.if_evaluate_add(( rewrite_sql, vec),self.demand[self.current_context][self.current_query_type]):
            self.demand[self.current_context][self.current_query_type].append(( rewrite_sql, vec, record_rules))


        return score

    def if_evaluate_add(self, item, list):
        for i in list:
            if item[0] == i[0] and (item[1] - i[1]).all() == 0:
                return True
        return False


    def is_demand_empty(self, demand):
        for k in demand.keys():
            if len(demand[k]) > 0:
                return False

        return True

    def gen_eval_dir(self):
        eval_dir = {}
        demand = self.demand[self.current_context]
        query_type_set = list(self.demand[self.current_context].keys())
        query_type_ind = 0
        while len(list(eval_dir.keys())) < self.budget and not self.is_demand_empty(demand):
            trail_num = 0
            query_type_ind = (query_type_ind + 1) % len(query_type_set)
            query_type = query_type_set[query_type_ind]

            while not len(demand[query_type])  and not self.is_demand_empty(demand):
                query_type_ind = (query_type_ind + 1) % len(query_type_set)
                query_type = query_type_set[query_type_ind]
                trail_num = trail_num + 1


            if not query_type in eval_dir:
                eval_dir[query_type] = demand[query_type].pop(0)
            else:
                timestamp = time.time()
                eval_dir[query_type.split('.')[0] + '_' + str(timestamp) + '.sql'] = demand[query_type].pop(0)

        print(eval_dir.keys())

        return eval_dir


    def evaluate(self, eval_dir, timestamp=None):
        if timestamp == None:
            self.query_timestamp = int(time.time())
            self.record_rewrite_sql(eval_dir)

        query_config = {}
        query_config['query.file_id'] = self.query_timestamp
        time_cost, space_cost, _ = self.db.evaluate(query_config)
        for type in eval_dir.keys():
            sql = eval_dir[type]
            if type.split('.')[0] in self.db.time_cost_dir.keys():
                time_per_sql = self.db.time_cost_dir[type.split('.')[0]]
                #result = self.db.time_cost_dir[type.split('.')[0]]
            else:
                time_per_sql= self.db.workload_timeout
            if len(sql[2]):
                self.logger.info("{}->{}:{}, {}".format(type, sql[2], time_per_sql, sql[0]))


        #time_cost = time_cost[0]
        return time_cost, space_cost, query_config

    def conduct_supply(self, eval_dir):
        try:
            time_all, space_cost, config = self.evaluate(eval_dir)
        except:
            time_all, space_cost = [self.db.workload_timeout, self.db.workload_timeout], self.budget - 1
        time_cost = time_all[0]
        print(self.db.time_cost_dir)
        with open("time.res", 'a') as f:
            f.write(str(self.db.time_cost_dir) + '\n')
        for type in eval_dir.keys():
            sql = eval_dir[type]
            if type.split('.')[0] in self.db.time_cost_dir.keys():
                result = self.db.time_cost_dir[type.split('.')[0]]
            else:
                result = self.db.workload_timeout + time_cost

            self.supply[self.current_context][sql[0]] = result

        return time_all, space_cost, config



    def record_rewrite_sql(self, eval_dir):
        v = self.query_timestamp
        workload_qdir = self.db.workload_qdir.replace(self.db.workload_qdir.split('_')[-1], str(v)) + '/'
        workload_qlist_file = self.db.workload_qlist_file.replace(self.db.workload_qlist_file.split('_')[-1], str(v)) + '.txt'

        if os.path.exists(workload_qdir):
            shutil.rmtree(workload_qdir)

        os.mkdir(workload_qdir)
        for k in eval_dir.keys():
            with open(os.path.join(workload_qdir, k), 'w') as f:
                f.write(eval_dir[k][0].replace('\n', ' '))

        qlist = list(eval_dir.keys())
        with open(workload_qlist_file, 'w') as f:
            for q in qlist:
                f.write(q + '\n')

    def previous_cost_estimation(self, origin_sql, rewrite_sql, rewrite_sequence, context=None):
        # input: sql
        # output: total execution cost
        #print("estimate new query!")
        #print(rewrite_sql)
        cost = self.db.estimate_query_cost(rewrite_sql)
        return cost

class CostEstimator_WithoutContext(CostEstimator):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)


    def previous_cost_estimation_rf(self,origin_sql, rewrite_sql, rewrite_sequence, context=None, record_rules=None):
        rewrite_sql = rewrite_sql.replace('\n', ' ')
        if context is None:
            context = np. asarray(self.current_context)

        if self.current_context in self.supply.keys() and \
                rewrite_sql in self.supply[self.current_context].keys():

            return self.supply[self.current_context][rewrite_sql]

        origin_sql = self.sql2vec(self.parser, origin_sql)
        rewrite_sql_ = self.sql2vec(self.parser, rewrite_sql)
        rule = encode_rules(rewrite_sequence)
        vec = np.hstack((origin_sql, rewrite_sql_, rule)).reshape(1, -1)

        if self.cost_init:
            score =  self.previous_cost_estimation(origin_sql, rewrite_sql, record_rules)
        else:
            vec_pro = self.scaler.transform(vec)
            vec_pro = self.pca.transform(vec_pro)
            mean, var = self.model.predict(vec_pro)
            if not var.item() == 0:
                std = np.std(var.item())
            else:
                std = 0
            score = mean.item() - std

        if not self.current_context in self.demand.keys():
            self.demand[self.current_context] = defaultdict(list)

        if not self.if_evaluate_add(( rewrite_sql, vec),self.demand[self.current_context][self.current_query_type]):
            self.demand[self.current_context][self.current_query_type].append(( rewrite_sql, vec, rewrite_sequence))


        return score