import copy
import sys
import pdb
import numpy as np
import time
import copy
from tqdm import tqdm
sys.path.append('..')

import math
from openbox.utils.config_space import ConfigurationSpace, CategoricalHyperparameter, \
    UniformIntegerHyperparameter, UniformFloatHyperparameter
from openbox.optimizer.generic_smbo import SMBO
from openbox.utils.constants import MAXINT, SUCCESS, FAILED, TIMEOUT
from openbox.utils.limit import time_limit, TimeoutException
from openbox.core.base import Observation
from .base import Advisor
from openbox.utils.util_funcs import get_result
from ..utils.parser import parse_run_history, parse_records


class BOAdvisor(Advisor):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.data = []
        self.config_space = self.setup_config_space(self.arm_type, self.db)
        self.config_space.seed(self.rng.randint(MAXINT))
        self.bo = SMBO(
            self.evaluate,
            self.config_space,
            num_objs=1,
            num_constraints=1,
            surrogate_type='prf',
            constraint_surrogate_type='linear',
            acq_optimizer_type='local_random',
            initial_runs=self.init_runs,
            init_strategy='random_explore_first',
            task_id=self.task_id,
            time_limit_per_trial=1000,
            random_state=self.random_state,
            advisor_kwargs={'constraint_budget': self.budget}
        )
        if not self.cost_aware:
            self.bo.max_iterations =  0
        else:
            self.bo.runtime_limit = 0
            self.bo.budget_left = 0

        self.time_begin = 0

    @staticmethod
    def setup_config_space(arm_type, db=None):
        config_space = ConfigurationSpace()

        if arm_type == 'index':
            all_index = sorted(db.all_index_candidates)
            for c in all_index:
                name = 'index.{}'.format(c)
                hp = CategoricalHyperparameter(name, ['off', 'on'])
                config_space.add_hyperparameter(hp)

        if arm_type == 'knob':
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

    def update_data(self, time_cost, space_cost, config):
        record = {}
        record['configuration'] = config
        record['time_cost'] = time_cost
        record['space_cost'] = space_cost
        self.data.append(record)

    def evaluate(self, config):
        try:
            time_cost, space_cost, _ = self.db.evaluate(config)
        except:
            time_cost, space_cost = [self.db.workload_timeout, self.db.workload_timeout], self.budget - 1

        with open(self.output_file, 'a') as f:
            f.write('{}\n'.format({
                'configuration': config.get_dictionary(),
                'time_cost': time_cost,
                'space_cost': space_cost,
                'time_spent': time.time() - self.time_begin,
                'arm' : list(config.get_dictionary().keys())[0].split('.')[0] + '_' + str(self.pull_num)
            }))

        self.time_begin = time.time()
        return {'objs': [time_cost[0], ], 'constraints': [float(space_cost) - float(self.budget), ]}
   
    def run(self):
        if not self.cost_aware:
            self.bo.max_iterations += self.block_runs
        else:
            self.bo.budget_left = self.sub_budget
            self.bo.runtime_limit = self.sub_budget
        self.time_begin = time.time()
        # self.bo.run()
        incumbent = self._run()
        self.pull_num = self.pull_num + 1
        #return parse_run_history(self.output_file, budget=self.budget)
        return incumbent

    def _run(self):
        incumbent = (None, np.Inf)
        incL = list()
        for _ in tqdm(range(self.bo.iteration_id, self.bo.max_iterations)):
            if self.bo.budget_left < 0:
                self.logger.info('Time %f elapsed!' % self.bo.runtime_limit)
                break
            start_time = time.time()
            config, trial_state, constraints, objs = self.bo.iterate(budget_left=self.bo.budget_left)
            runtime = time.time() - start_time
            self.bo.budget_left -= runtime

            if trial_state == SUCCESS and constraints[0] < 0 and \
                    (objs[0] < incumbent[1] or incumbent[0] is None):
                incumbent = (copy.deepcopy(config), objs[0])

            incL.append(incumbent[1])
            if self.converage_judge and  len(incL) > 5 and (incL[-5] - incL[-1]) / incL[-5] < 0.005:
                break

        return incumbent


class BO(BOAdvisor):
    def __init__(self, current_context, **kwargs):
        super().__init__(**kwargs)
        self.current_context = current_context

    def evaluate(self, config):
        try:
            time_cost, space_cost, _ =  self.db.evaluate(config) #time_cost, space_cost, _ =  self.db.evaluate(config) #
        except:
            time_cost, space_cost = [self.db.workload_timeout, self.db.workload_timeout], self.budget - 1

        with open(self.output_file, 'a') as f:
            f.write('{}\n'.format({
                'configuration': config.get_dictionary(),
                'time_cost': time_cost,
                'space_cost': space_cost,
                'context': self.current_context.tolist(),
                'time_spent': time.time() - self.time_begin,
                'arm': list(config.get_dictionary().keys())[0].split('.')[0] + '_' + str(self.pull_num)
            }))
        self.time_begin = time.time()
        return {'objs': [time_cost[0], ], 'constraints': [float(space_cost) - float(self.budget), ]}

    def run(self):
        if not self.cost_aware:
            self.model.max_iterations = self.model.max_iterations + self.block_runs
        else:
            self.model.budget_left =  self.sub_budget
            self.model.runtime_limit = self.sub_budget
        self.time_begin = time.time()
        # self.model.run()
        incumbent = self._run()
        self.pull_num = self.pull_num + 1
        # return parse_run_history(self.output_file, budget=self.budget)
        return incumbent

    def reset_context(self, context):
        self.logger.info('context: {}'.format(context))
        self.current_context = context
        self.model.reset_context(context)

    def _run(self):
        incumbent = (None, np.Inf)

        for _ in tqdm(range(self.model.iteration_id, self.model.max_iterations)):
            if self.model.budget_left < 0:
                self.logger.info('Time %f elapsed!' % self.model.runtime_limit)
                break
            start_time = time.time()
            config, trial_state, constraints, objs = self.iterate(budget_left=self.model.budget_left)
            runtime = time.time() - start_time
            self.model.budget_left -= runtime

            if trial_state == SUCCESS and constraints[0] < 0 and \
                    (objs[0] < incumbent[1] or incumbent[0] is None):
                incumbent = (copy.deepcopy(config), objs[0])

        return incumbent


    def iterate(self, budget_left=None):
        # get configuration suggestion from advisor
        config = self.Suggest()

        trial_state = SUCCESS
        _budget_left = int(1e10) if budget_left is None else budget_left
        _time_limit_per_trial = math.ceil(min(self.model.time_limit_per_trial, _budget_left))

        # only evaluate non duplicate configuration
        if config not in self.model.config_advisor.history_container.configurations:
            start_time = time.time()
            try:
                # evaluate configuration on objective_function within time_limit_per_trial
                #args, kwargs = (config,), dict()
                #timeout_status, _result = time_limit(self.objective_function,
                #                                     _time_limit_per_trial,
                #                                     args=args, kwargs=kwargs)
                _result = self.model.objective_function(config)
                timeout_status = False
                if timeout_status:
                    raise TimeoutException(
                        'Timeout: time limit for this evaluation is %.1fs' % _time_limit_per_trial)
                else:
                    # parse result
                    objs, constraints = get_result(_result)
            except Exception as e:
                # parse result of failed trial
                if isinstance(e, TimeoutException):
                    self.logger.warning(str(e))
                    trial_state = TIMEOUT
                else:
                    self.logger.warning('Exception when calling objective function: %s' % str(e))
                    trial_state = FAILED
                objs = self.model.FAILED_PERF
                constraints = None

            elapsed_time = time.time() - start_time
            # update observation to advisor
            observation = Observation(
                config=config, objs=objs, constraints=constraints,
                trial_state=trial_state, elapsed_time=elapsed_time, context=self.current_context,
            )
            if _time_limit_per_trial != self.model.time_limit_per_trial and trial_state == TIMEOUT:
                # Timeout in the last iteration.
                pass
            else:
                self.UpdatePolicy(observation)
        else:
            self.logger.info('This configuration has been evaluated! Skip it: %s' % config)
            history = self.model.get_history()
            config_idx = history.configurations.index(config)
            trial_state = history.trial_states[config_idx]
            objs = history.perfs[config_idx]
            constraints = history.constraint_perfs[config_idx] if self.model.num_constraints > 0 else None
            if self.model.num_objs == 1:
                objs = (objs,)

        self.model.iteration_id += 1
        # Logging.
        if self.model.num_constraints > 0:
            self.logger.info('Iteration %d, objective value: %s. constraints: %s.'
                             % (self.model.iteration_id, objs, constraints))
        else:
            self.logger.info('Iteration %d, objective value: %s.' % (self.model.iteration_id, objs))

        # Visualization.
        # for idx, obj in enumerate(objs):
        #     if obj < self.FAILED_PERF[idx]:
        #         self.writer.add_scalar('data/objective-%d' % (idx + 1), obj, self.iteration_id)
        return config, trial_state, constraints, objs