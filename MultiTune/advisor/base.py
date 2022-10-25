import os
import logging
import numpy as np
from abc import ABC, abstractmethod


class Advisor(ABC):
    def __init__(self, db, task_id, arm_type , output_file,
                 block_runs, init_runs, cost_aware, sub_budget,
                 index_budget=1500, log_path='./log', random_state=1, converage_judge='False', **kwargs):
        self.db = db
        self.task_id = task_id
        self.arm_type = arm_type
        self.output_file = output_file
        #self.max_runs = eval(str(max_runs))
        self.block_runs = eval(str(block_runs))
        self.cost_aware = eval(str(cost_aware))
        #self.max_runtime = eval(str(max_runtime))
        self.sub_budget = eval(str(sub_budget))
        self.init_runs = eval(str(init_runs))
        self.budget = float(index_budget)
        self.log_path = log_path
        self.random_state = int(random_state)
        self.rng = np.random.RandomState(int(random_state))
        self.pull_num = 0
        self.logger = self.db.logger
        self.converage_judge = eval(converage_judge)

    @abstractmethod
    def run(self):
        pass

    def setup_logger(self):
        if not os.path.exists(self.log_path):
            os.mkdir(self.log_path)

        logger = logging.getLogger(self.__class__.__name__)
        logger.setLevel(logging.DEBUG)
        formatter = logging.Formatter('[{}][%(asctime)s]: %(levelname)s, %(message)s'.format(logger.name))

        p_stream = logging.StreamHandler()
        p_stream.setFormatter(formatter)
        p_stream.setLevel(logging.INFO)

        f_stream = logging.FileHandler(
            os.path.join(self.log_path, '{}.log'.format(self.task_id)), mode='a', encoding='utf8')
        f_stream.setFormatter(formatter)
        f_stream.setLevel(logging.DEBUG)

        logger.addHandler(p_stream)
        logger.addHandler(f_stream)

        logger.setLevel('INFO')
        return logger


class NoIndexAdvisor(Advisor):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.default_config = self.get_default_config()

    def get_default_config(self):
        return {c: 'off' for c in self.db.all_index_candidates}

    def run(self):
        time_cost, space_cost = self.db.evaluate(self.default_config)
        return self.default_config, time_cost, space_cost


class AllIndexAdvisor(Advisor):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.default_config = self.get_default_config()

    def get_default_config(self):
        return {c: 'on' for c in self.db.all_index_candidates}

    def run(self):
        time_cost, space_cost = self.db.evaluate(self.default_config)

        with open(self.output_file, 'a') as f:
            f.write('{}|lat_{}|size_{}\n'.format(self.default_config, time_cost, space_cost))

        return self.default_config, time_cost, space_cost
