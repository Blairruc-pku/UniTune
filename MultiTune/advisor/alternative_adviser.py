import pdb
import os
import sys
import copy
import numpy as np
import time
import  pickle
import scipy.stats as ss
import matplotlib.pyplot as plt
from colorama import Fore, Back, Style
sys.path.append('..')
from ..utils.parser import  get_increasing_sequence
from ..utils.draw import plot_beta
from .bo import BOAdvisor, BO
from .learnedrewrite import LearnedRewrite
from .autoview import AutoView
from .cdbtune import CDBTune
from .ottertune import OtterTune
from .dbabandit import DbaBandit
from ..database.base import DB
from abc import ABC, abstractmethod
from collections import defaultdict
from openbox.utils.config_space import Configuration
from openbox.utils.history_container import Observation
from openbox.utils.constants import SUCCESS


def ema(Data, alpha, window, what=0, whereSMA=1, whereEMA=2):
    # alpha is the smoothing factor
    # window is the lookback period
    # what is the column that needs to have its average calculated
    # where is where to put the exponential moving average
    Data = np.array(Data)
    if Data.shape[0] <= window:
        Data = np.hstack((Data,0))
    Data_tmp = np.zeros((Data.shape[0], 3))
    Data_tmp[:,0] = Data
    Data = Data_tmp

    alpha = alpha / (window + 1.0)
    beta = 1 - alpha

    # First value is a simple SMA
    Data[window - 1, whereSMA] = np.mean(Data[:window - 1, what])

    # Calculating first EMA
    Data[window, whereEMA] = (Data[window, what] * alpha) + (Data[window - 1, whereSMA] * beta)
    # Calculating the rest of EMA
    for i in range(window + 1, len(Data)):
        try:
            Data[i, whereEMA] = (Data[i, what] * alpha) + (Data[i - 1, whereEMA] * beta)

        except IndexError:
            pass
    return Data[:,2]

class TopAdvisor(ABC):
    def __init__(self, db: DB, args_tune):
        self.db = db
        self.args_tune = args_tune

        # logger
        self.logger = self.db.logger

        self.arms = eval(args_tune['arms'])
        self.pull_cnt = 0
        self.max_runs = int(args_tune['max_runs'])
        self.tuning_budget = float(args_tune['tuning_budget'])
        self.cost_aware = eval(args_tune['cost_aware'])
        self.block_runs = int(args_tune['block_runs'])
        self.use_context = eval(args_tune['context'])
        self.ts_use_window = eval(args_tune['ts_use_window'])
        self.knob_ddpg = eval(args_tune['knob_ddpg'])
        if not self.cost_aware:
            self.pull_arm_run = int(self.max_runs / self.block_runs)
        self.sliding_window_size = eval(args_tune['window_size'])
        self.output_file = args_tune['output_file']
        self.budget = float(args_tune['index_budget'])
        # initialize
        self.default = defaultdict(dict)
        self.best_result = {}
        self.context_type = args_tune['context_type']
        self.init_record()

        self.action_sequence = list()
        self.rewards = defaultdict(list)

        self.imp_thresh = 1.01

        # Initialize Block
        self.args_block = {}
        for arm in self.arms:
            self.args_block[arm] = copy.deepcopy(args_tune)
            self.args_block[arm]['max_runs'] = int(args_tune['block_runs'])
            self.args_block[arm]['init_runs'] = int(args_tune['init_runs'])
            self.args_block[arm]['arm_type'] = arm

        if self.use_context and self.context_type in ['im', 'config']:
            self.block_advisor = {}
            for arm in self.arms:
                self.logger.info('Initialize block advisor [{}]'.format(arm))
                self.args_block[arm]['task_id'] = self.args_block[arm]['task_id']
                self.args_block[arm]['block_runs'] = int(args_tune['block_runs'])
                self.args_block[arm]['init_runs'] = int(args_tune['init_runs'])
                if arm == 'knob':
                    if self.args_tune['components']['knob'] == 'cdbtune':
                        self.block_advisor[arm] = CDBTune(current_context=self.best_result[arm]['context'], db=self.db,  **self.args_block[arm])
                    else:
                        self.block_advisor[arm] = OtterTune(current_context=self.best_result[arm]['context'],
                                                             db=self.db, **self.args_block[arm])
                if arm == 'index':
                        self.block_advisor[arm] = DbaBandit(current_context=self.best_result[arm]['context'], db=self.db, **self.args_block[arm])

                elif arm == 'query':
                    self.block_advisor[arm] = LearnedRewrite(current_context=self.best_result[arm]['context'], db=self.db, **self.args_block[arm])
                elif arm == 'view':
                    self.block_advisor[arm] = auto_view(current_context=self.best_result[arm]['context'], db=self.db,
                                                          **self.args_block[arm])
        else:
            self.block_advisor = {}
            for arm in self.arms:
                self.logger.info('Initialize block advisor [{}]'.format(arm))
                self.args_block[arm]['task_id'] = self.args_block[arm]['task_id']
                self.args_block[arm]['block_runs'] = int(args_tune['block_runs'])
                self.args_block[arm]['init_runs'] = int(args_tune['init_runs'])
                if arm in ['knob', 'index']:
                    self.block_advisor[arm] = BOAdvisor(db=self.db, **self.args_block[arm])
                else:
                    self.block_advisor[arm] = LearnedRewrite(db=self.db, **self.args_block[arm])

    def init_record(self):
        if 'knob' in self.arms:
            for k, v in self.db.knob_details.items():
                if v['type'] in ['integer', 'float'] and v['max'] > sys.maxsize:
                    self.default['knob']['knob.%s' % k] = int(self.db.knob_details[k]['default'] / 1000)
                    self.default['knob']['knob.%s' % k] = int(self.db.knob_details[k]['default'] / 1000)
                else:
                    self.default['knob']['knob.%s' % k] = self.db.knob_details[k]['default']
                    self.default['all']['knob.%s' % k] = self.db.knob_details[k]['default']

        if 'index' in self.arms:
            for c in self.db.all_index_candidates:
                self.default['index']['index.%s' % c] = 'off'
                self.default['all']['index.%s' % c] = 'off'

        if 'query' in self.arms:
            self.default['query'] = {'query.file_id':'0'}
            self.default['all']['query.file_id'] = 0

        if 'view' in self.arms:
            self.default['view'] = {'view.edge': [0]*43, 'view.file_id':0 }
            self.default['all']['view.edge'] = [0] * 43
            self.default['all']['view.file_id'] = 0

        for arm in self.arms:
            self.best_result[arm] = {'config': self.default[arm]}

        self.best_result['all_config'] = dict()
        for arm in self.arms:
            self.best_result['all_config'].update(self.default[arm])

        # print('Evaluate default config.')
        # default_cost, _, internal_metrics = self.db.evaluate(self.default, collect_im=True)
        try:
            with open(self.output_file) as f:
                tmp = eval(f.readlines()[0])
                default_cost = float(tmp['time_cost'][0])
                if self.use_context:
                    if self.context_type == 'im':
                        for _arm in self.arms:
                            self.best_result[_arm]['context'] = np.array(tmp['context'], dtype=np.float32)
                    if self.context_type == 'config':
                        for _arm in self.arms:
                            self.observe_context(_arm)

                self.logger.info(Fore.RED + 'Load init record' + Style.RESET_ALL)
        except:
            self.logger.info(Fore.RED + 'Init record' + Style.RESET_ALL)
            internal_metrics, time_cost = self.get_current_context('default')
            default_cost = time_cost[0]
            data = {
                'configuration': self.default['all'],
                'time_cost': time_cost,
                'space_cost': 0,
            }
            if self.use_context:
                if self.context_type  == 'im':
                    data['context'] = internal_metrics.tolist()
                    for _arm in self.arms:
                        self.best_result[_arm]['context'] = internal_metrics
                else:
                    for _arm in self.arms:
                        data['context'] = None
                        self.observe_context(_arm)

            with open(self.output_file, 'a') as f:
                f.write('{}\n'.format(data))

        self.best_result['all'] = default_cost
        for _arm in self.arms:
            self.best_result[_arm]['time_cost'] = default_cost

        self.logger.info('[Initialize] default cost: {}'.format(default_cost))

    def load_history(self, load_num=-1,  policy='alter'):
        with open(self.output_file) as f:
            lines = f.readlines()[1:]

        lines_no_best = [line for line in lines if (not 'best|' in line) and (not 'observe-context|' in line)]
        if load_num != -1:
            lines = lines[:load_num]
        else:
            load_num = len(lines_no_best)

        arms = [eval(line.strip())['arm'].split('_')[0] for line in lines_no_best]
        arm_ids = [eval(line.strip())['arm'] for line in lines_no_best]

        inc_config, inc_value = None, 1e9
        for i, line in enumerate(lines_no_best):
            if i == 0 or arm_ids[i] != arm_ids[i-1]:
                self.logger.info(Fore.RED + 'Load pull {}: {}'.format(self.pull_cnt, arms[i]) + Style.RESET_ALL)
                self.action_sequence.append(arms[i])
                self.pull_cnt += 1

            tmp = eval(line.strip())
            config = tmp['configuration']
            time_cost = tmp['time_cost']
            space_cost = tmp['space_cost']

            if isinstance(time_cost,float) :
                if time_cost < inc_value and space_cost < self.budget:
                    inc_value = time_cost
                    inc_config = config
            elif time_cost[0] < inc_value and space_cost < self.budget:
                inc_value =  time_cost[0]
                inc_config = config

            arm = arms[i]
            if arm in ['knob', 'index']:
                if arm == 'knob' and self.knob_ddpg:
                    pass
                elif self.use_context and self.context_type in ['im', 'config']:
                    self.block_advisor[arm].model.iteration_id += 1
                    self.block_advisor[arm].model.max_iterations += 1
                    config = Configuration(self.block_advisor[arm].model.config_space, values=config)
                    if self.context_type == 'im':
                        context = tmp['context']
                    else:
                        self.observe_context(arm)
                        context = self.best_result[arm]['context']
                    self.block_advisor[arm].model.config_advisor.history_container.update_observation(Observation(
                        config=config,
                        objs=[time_cost[0], ],
                        constraints=[space_cost - self.block_advisor[arm].budget, ],
                        trial_state=SUCCESS,
                        elapsed_time=time_cost,
                        context=context,
                    ))
                else:
                    self.block_advisor[arm].bo.iteration_id += 1
                    self.block_advisor[arm].bo.max_iterations += 1
                    config = Configuration(self.block_advisor[arm].bo.config_space, values=config)
                    self.block_advisor[arm].bo.config_advisor.history_container.update_observation(Observation(
                        config=config,
                        objs=[time_cost[0], ],
                        constraints=[space_cost - self.block_advisor[arm].budget, ],
                        trial_state=SUCCESS,
                        elapsed_time=time_cost,
                    ))
            else:
                base_dir = os.path.abspath(os.curdir)
                if os.path.exists(os.path.join(base_dir, "{}.pkl".format(self.args_block[arm]['task_id']))):
                    self.block_advisor[arm].estimator = pickle.load(open(os.path.join(base_dir, "{}.pkl".format(self.args_block[arm]['task_id'])), 'rb'))
                    self.block_advisor[arm].estimator.reinit()
                if os.path.exists(os.path.join(base_dir, "X_{}.npy".format(self.args_block[arm]['task_id']))):
                    self.block_advisor[arm].estimator.X = np.load( os.path.join(base_dir, "X_{}.npy".format(self.args_block[arm]['task_id'])),
                                                         encoding='bytes', allow_pickle=True)
                    self.block_advisor[arm].estimator.y = np.load( os.path.join(base_dir, "y_{}.npy".format(self.args_block[arm]['task_id'])),
                                                         encoding='bytes', allow_pickle=True)

            if self.use_context:
                if self.context_type == 'im':
                    self.best_result[arm]['context'] =  np.array(tmp['context'])
                elif self.context_type == 'config':
                    self.observe_context(arm)

            if i == len(lines_no_best) - 1 or arm_ids[i] != arm_ids[i+1] :
                ind = lines.index(line)
                if ind + 1 < len(lines) and 'best|' in lines[ind + 1]:
                    inc_value_reobserved =  eval(lines[ind + 1].strip()[5:])['time_cost'][0]
                    self.logger.info("load best {}, re-observe best {}\n".format(inc_value, inc_value_reobserved))
                    inc_value = max(inc_value, inc_value_reobserved)

                incumbent = inc_config, inc_value

                if inc_config is not None and inc_value * self.imp_thresh < self.best_result['all']:
                    reward = self.best_result['all'] - incumbent[1]
                    self.logger.info(Fore.RED + 'Find better configuration when tuning {}, obj {}, reward {}.'.format(
                        arm, incumbent[1], reward) + Style.RESET_ALL)
                    self.update_best(arm, incumbent)
                    if self.use_context:
                        if self.context_type == 'reinit':
                            for arm_tmp in self.arms:
                                if not arm == arm_tmp:
                                    self.observe_context(arm_tmp)

                        elif self.context_type == 'im':
                            if ind + 2 < len(lines) and 'observe-context|' in lines[ind + 2]:
                                _arm = eval(lines[ind + 2].strip()[16:])['arm']
                                self.best_result[_arm]['context'] = np.array(eval(lines[ind + 2].strip()[16:])['context'])
                            
                            if ind + 3 < len(lines) and 'observe-context|' in lines[ind + 3]:
                                _arm = eval(lines[ind + 3].strip()[16:])['arm']
                                self.best_result[_arm]['context'] = np.array(eval(lines[ind + 3].strip()[16:])['context'])
                            elif i == len(lines_no_best) - 1 :
                                for _arm in self.arms:
                                    if not _arm == arm:
                                        self.logger.info("Observe Context for {}".format(_arm))
                                        self.observe_context(_arm)

                        elif self.context_type == 'config':
                            for _arm in self.arms:
                                if not _arm == arm:
                                    self.observe_context(_arm)
                else:
                    reward = 0
                self.rewards[arm].append(reward)

                if policy == 'ts':
                    self.ts_update(self.arms.index(arm))

        if load_num > 0:
            self.update_apply_observe_best(force=True)
        self.logger.info('Load {} observations'.format(load_num))

    def run(self, policy='alter'):
        if policy == 'udo':
            self.optimize_udo()
            return

        N = len(self.arms)
        if policy=='ts' and not hasattr(self, 'S'):
            self.S = np.zeros(N, dtype=np.int)
            self.F = np.zeros(N, dtype=np.int)
            self.delta_S = np.zeros(N, dtype=np.int)
            self.delta_F = np.zeros(N, dtype=np.int)
            if self.ts_use_window:
                self.S_window, self.F_window = dict(), dict()
                for arm in self.arms:
                    self.S_window[arm] = list()
                    self.F_window[arm] = list()

        if os.path.exists(self.output_file):
            self.load_history( policy=policy)

        time_enter = time.time()

        if not self.cost_aware:
            for i in range(self.pull_cnt, self.pull_arm_run):
                if policy == 'alter':
                    self.optimize_alter()
                elif policy == 'rb':
                    self.optimize_rb()
                elif policy == 'ts':
                    self.optimize_ts()

        else:
            while time.time() - time_enter < self.tuning_budget:
                if policy == 'alter':
                    self.optimize_alter()
                elif policy == 'rb':
                    self.optimize_rb()
                elif policy == 'ts':
                    self.optimize_ts()


    def optimize_acq(self):
        if self.pull_cnt < len(self.arms) * self.sliding_window_size:
            arm_picked = self.arms[self.pull_cnt % len(self.arms)]
        else:
            best_acq = -np.Inf
            arm_picked = None
            for arm in self.arms:
                next_config = self.block_advisor[arm].cbo.config_advisor.get_suggestion()
                next_acq = self.block_advisor[arm].cbo.config_advisor.acquisition_function([next_config,])[0]
                if next_acq > best_acq:
                    arm_picked = arm
                    best_acq = next_acq

        self.block_do_next(arm_picked)
        self.pull_cnt = self.pull_cnt + 1
        self.action_sequence.append(arm_picked)

    def optimize_alter(self):
        _arm = self.arms[self.pull_cnt % len(self.arms)]
        self.logger.info(Fore.RED + '# Pull {}: arm [{}]'.format(self.pull_cnt, _arm) + Style.RESET_ALL)
        self.block_do_next(_arm)
        self.pull_cnt = self.pull_cnt + 1
        self.action_sequence.append(_arm)

    def optimize_rb(self):
        # First pull each arm #sliding_window_size times.
        if self.pull_cnt < len(self.arms) * self.sliding_window_size:
            arm_picked = self.arms[self.pull_cnt % len(self.arms)]
        else:
            imp_values = list()

            for _arm in self.arms:
                #imp_values.append(np.mean(self.rewards[_arm][-self.sliding_window_size:]))
                self.logger.info("reward for {}:{}\n".format(_arm, self.rewards[_arm]))
                imp_values.append(ema(self.rewards[_arm], 2, self.sliding_window_size)[-1])

            self.logger.info(Fore.RED + "imp_values {} for {} \n".format(imp_values, self.arms) + Style.RESET_ALL)
            if np.unique(np.array(imp_values)).shape[0] == 1:
                # Break ties randomly.
                # arm_picked = np.random.choice(self.arms, 1)[0]
                arm_picked = 'index' if self.action_sequence[-1] in ('knob', 'query') else np.random.choice(self.arms)
            else:
                arm_picked = self.arms[np.argmax(imp_values)]

        self.logger.info(Fore.RED + '# Pull {}: arm [{}]'.format(self.pull_cnt, arm_picked) + Style.RESET_ALL)
        self.block_do_next(arm_picked)

        self.pull_cnt = self.pull_cnt + 1
        self.action_sequence.append(arm_picked)


    def ts_update(self, arm_id, q=3, bernoulli=False, context_aware=False, beta=0.9):
        N = len(self.arms)
        imp = self.rewards[self.arms[arm_id]][-1]

        if not bernoulli:
            if imp > 0:
                self.S[arm_id] += round(imp / q) + 1
                self.delta_S[arm_id] += round(imp / q) + 1
                if self.ts_use_window:
                    self.S_window[self.arms[arm_id]].append( round(imp / q) + 1)
                    self.F_window[self.arms[arm_id]].append(0)

            else:
                self.F[arm_id] += 1
                self.delta_F[arm_id] += 1
                if self.ts_use_window:
                    self.S_window[self.arms[arm_id]].append(0)
                    self.F_window[self.arms[arm_id]].append(1)

            if self.ts_use_window:
                self.F[arm_id] = sum(self.F_window[self.arms[arm_id]][ -self.sliding_window_size:])
                self.S[arm_id] = sum(self.S_window[self.arms[arm_id]][-self.sliding_window_size:])
        else:
            p = min(1, imp / q)
            r = ss.bernoulli.rvs(p)
            if r > 0:
                self.S[arm_id] += 1
                self.delta_S[arm_id] += 1
            else:
                self.F[arm_id] += 1
                self.delta_F[arm_id] += 1

        self.logger.info("S:{}".format(self.S))
        self.logger.info("F:{}".format(self.F))
        if context_aware and imp > 0:
            for k in range(N):
                if not k == arm_id:
                    if not self.ts_use_window:
                        self.S[k] = max(0, self.S[k] + round((beta-1) *  self.delta_S[k])  )
                        self.F[k] = max(0, self.F[k] + round((beta - 1) * self.delta_F[k]) )
                        self.delta_S[k] = 0
                        self.delta_F[k] = 0
                    else:
                        self.F[k] = max(0, self.F[k] * beta )
                        self.S[k] = max(0, self.S[k] * beta)

            self.logger.info("context changes, update S and F")
            self.logger.info("S:{}".format(self.S))
            self.logger.info("F:{}".format(self.F))

    def optimize_ts(self, draw=False):
        N = len(self.arms)

        if self.pull_cnt < len(self.arms) * 3:#self.sliding_window_size:
            arm_picked = self.arms[self.pull_cnt % len(self.arms)]
            arm_id = self.arms.index(arm_picked)
        else:
            probs = np.zeros(N)
            for i in range(N):
                probs[i] = ss.beta.rvs(self.S[i] + 1, self.F[i] + 1)
                if draw:
                    x = np.linspace(0, 1, 5000)
                    plot_beta(x, self.S[i] + 1, self.F[i] + 1, plt, label='{}:a={},b={}'.format(self.arms[i], self.S[i] + 1, self.F[i] + 1))

            if draw:
                plt.legend()
                plt.title("Iteration {}".format(self.pull_cnt))
                if not os.path.exists('plot'):
                    os.mkdir('plot')
                plt.savefig("plot/{}.png".format(self.pull_cnt))
                plt.close()

            arm_id = np.argmax(probs)
            arm_picked = self.arms[arm_id]

            self.logger.info("Draw probs from beta distributions:{}".format(probs))

        self.logger.info(Fore.RED + '# Pull {}: arm [{}]'.format(self.pull_cnt, arm_picked) + Style.RESET_ALL)
        self.block_do_next(arm_picked)
        self.pull_cnt = self.pull_cnt + 1
        self.action_sequence.append(arm_picked)
        self.ts_update(arm_id)

    def optimize_udo(self):
        from openbox.optimizer.generic_smbo import SMBO
        index_config_space = self.block_advisor['index'].config_space

        def evaluate_index(config):
            self.db.apply_index_config(config)
            agent_query = RLEstimator(db=self.db, **self.args_block['query'])
            incumbent = agent_query.run()
            self.db.apply_query_config(incumbent[0])
            agent_knob = BOAdvisor(db=self.db, **self.args_block['knob'])
            incumbent =  agent_knob.run()
            with open(self.output_file, 'a') as f:
                f.write('{}\n'.format({
                    'configuration': config.get_dictionary(),
                    'time_cost': [incumbent[1],0],
                    'space_cost': 0,
                    'arm': 'index'
                }))
            return {'objs': [incumbent[1], ], 'constraints': [-1, ]}

        index_bo = SMBO(
            evaluate_index,
            index_config_space,
            num_objs=1,
            num_constraints=1,
            surrogate_type='prf',
            constraint_surrogate_type='linear',
            acq_optimizer_type='local_random',
            initial_runs=5,
            init_strategy='random_explore_first',
            task_id= self.block_advisor['index'].task_id,
            time_limit_per_trial=1000,
            random_state= self.block_advisor['index'].random_state,
            advisor_kwargs={'constraint_budget': self.budget},
        )
        #index_bo.max_iterations = int(100 / self.block_runs)  + 1
        from tqdm import tqdm
        begin_time = time.time()
        while True:
            with open(self.output_file) as f:
                budget_spent = len(f.readlines())

            if not self.cost_aware and budget_spent > self.max_runs:
                break
            if self.cost_aware and time.time() - begin_time > self.tuning_budget:
                break
            index_bo.iterate()



    def block_do_next(self, arm):
        if not self.use_context:
            self.apply_best()
            if arm == 'query':
                incumbent = self.block_advisor[arm].run(self.best_result['all'])
            else:
                incumbent = self.block_advisor[arm].run()
        else:
            if self.context_type in ('im', 'config'):
                current_context = self.get_current_context(arm)
                if arm == 'knob' and self.knob_ddpg:
                    self.block_advisor[arm].reset_context(current_context, self.best_result['all'])
                else:
                    self.block_advisor[arm].reset_context(current_context)
            if arm == 'query':
                incumbent = self.block_advisor[arm].run(self.best_result['all'])
            else:
                incumbent = self.block_advisor[arm].run()

        self.update_apply_observe_best(arm, incumbent)


    def observe_context(self, arm):
        if self.context_type == 'im':
            self.logger.info("Observe Context for {}".format(arm))
            config = self.default[arm]
            for arm_ in self.arms:
                if not arm_ == arm:
                    config.update(self.best_result[arm_]['config'])
                time_cost, _, internal_metrics = self.db.evaluate(config, collect_im=True)

            self.best_result[arm]['context'] = internal_metrics
            with open(self.output_file, 'a') as f:
                f.write('observe-context|{}\n'.format({
                    'arm': arm,
                    'config': config,
                    'time_cost': time_cost,
                    'context': internal_metrics.tolist(),
                }))
        elif self.context_type == 'config':
            if arm == 'index':
                config = self.best_result['knob']['config']
                self.best_result[arm]['context'] =  Configuration(BOAdvisor.setup_config_space('knob', db=self.db), config).get_array()
            elif arm == 'knob':
                config = self.best_result['index']['config']
                self.best_result[arm]['context'] = Configuration(BOAdvisor.setup_config_space('index', db=self.db), config).get_array()
            elif arm == 'query':
                config = self.best_result['knob']['config']
                knob_config = Configuration(BOAdvisor.setup_config_space('knob', db=self.db), config).get_array()
                config = self.best_result['index']['config']
                index_config =  Configuration(BOAdvisor.setup_config_space('index', db=self.db), config).get_array()
                self.best_result[arm]['context'] = np.hstack((knob_config, index_config))

        elif self.context_type == 'reinit':
            self.logger.info("Re-init agent for {}".format(arm))
            if arm in ['index', 'knob']:
                self.block_advisor[arm] = BOAdvisor(db=self.db, **self.args_block[arm])
            elif arm in ['query']:
                self.block_advisor[arm] = RLEstimator(db=self.db, **self.args_block[arm])


    def update_apply_observe_best(self, block_type=None, incumbent=None, force=False):
        if incumbent is not None:
            reward = 0
            inc_config, inc_value = incumbent
            if inc_value * self.imp_thresh < self.best_result['all']: # re-observe
                time_cost, _, internal_metrics = self.db.evaluate(inc_config, collect_im=True)
                inc_value_reobserved = time_cost[0]
                self.logger.info(Fore.RED + '[Re-observe the best] obj {}'.format(inc_value_reobserved) + Style.RESET_ALL)
                with open(self.output_file, 'a') as f:
                    f.write('best|{}\n'.format({
                    'configuration': inc_config.get_dictionary() if isinstance(inc_config, Configuration) else inc_config,
                    'time_cost': time_cost,
                    'space_cost': 0,
                    }))
                inc_value = max(inc_value, inc_value_reobserved)
                incumbent = inc_config, inc_value

            # if re-observed inc_value is also best, update the best
            if inc_value * self.imp_thresh < self.best_result['all']:
                reward = self.best_result['all'] - incumbent[1]
                self.logger.info(Fore.RED + 'Find better configuration when tuning {}, obj {}, reward {}.'.format(
                    block_type, inc_value, reward) + Style.RESET_ALL)
                self.update_best(block_type, incumbent)
                # update context for other arms
                if self.use_context:
                    for _arm in self.arms:
                        if not _arm == block_type:
                            self.observe_context(_arm)
            else:
                reward = 0
                self.logger.info(Fore.RED + 'No improvement when tuning {}..'.format(block_type) + Style.RESET_ALL)

            self.rewards[block_type].append(reward)
        else:
            if block_type is not None:
                self.logger.info(Fore.RED + 'Incumbent is None! No successful trials.' + Style.RESET_ALL)

            if force:
                internal_metrics, time_cost = self.get_current_context('best')
                if block_type is not None:
                    self.best_result[block_type]['time_cost'] = time_cost[0]
                self.best_result['all'] = time_cost[0]

                with open(self.output_file, 'a') as f:
                    f.write('best|{}\n'.format({
                    'configuration': self.best_result['all_config'],
                    'time_cost': time_cost,
                    'space_cost': 0,
                    }))
                self.logger.info(Fore.RED + '[Re-observe the best] obj {}'.format(time_cost[0]) + Style.RESET_ALL)

        self.apply_best()
        #print(Fore.RED + 'Apply best Index & Query & Knob so far.' + Style.RESET_ALL)

    def update_best(self, block_type, incumbent):
        if incumbent is not None:
            inc_config, inc_value = incumbent
            if inc_value < self.best_result['all']:
                self.best_result[block_type]['config'] = inc_config
                self.best_result[block_type]['time_cost'] = inc_value
                self.best_result['all'] = inc_value
                self.best_result['all_config'] = dict()
                for arm in self.arms:
                    self.best_result['all_config'].update(self.best_result[arm]['config'])
                self.logger.info(Fore.RED + 'Update best to {}!'.format(inc_value) + Style.RESET_ALL)
        else:
            self.logger.info(Fore.RED + 'Incumbent is None! No successful trials.' + Style.RESET_ALL)
        self.apply_best()


    def apply_best(self):
        self.logger.info(Fore.RED + 'Apply best Index & Query & Knob so far.' + Style.RESET_ALL)
        self.db._close_db()
        if 'knob' in self.arms:
            self.db.apply_knob_config(self.best_result['knob']['config'])
        self.db._start_db()
        for arm in self.arms:
            if not arm == 'knob':
                self.db.apply_config(arm, self.best_result[arm]['config'])


    def get_current_context(self, current_arm):
        if current_arm == 'default':
            self.logger.info(Fore.RED + 'Get default' + Style.RESET_ALL)
            config = dict(self.default['query'], **self.default['index'], **self.default['knob'])
            time_cost, _, internal_metrics = self.db.evaluate(config, collect_im=True)
            return internal_metrics, time_cost
        elif current_arm == 'best':
            self.logger.info(Fore.RED + 'Get best' + Style.RESET_ALL)
            time_cost, _, internal_metrics = self.db.evaluate(self.best_result['all_config'], collect_im=True)
            return internal_metrics, time_cost

        self.logger.info(Fore.RED + 'Get current context' + Style.RESET_ALL)

        if self.context_type in ('im', 'config'):
            '''if current_arm == 'index':
                config = dict(self.index_default, **self.best_result['knob']['config'], **self.best_result['query']['config'])
                _, _, internal_metrics = self.db.evaluate(config, collect_im=True)
            elif current_arm == 'knob':
                config = dict(self.knob_default, **self.best_result['index']['config'], **self.best_result['query']['config'])
                _, _, internal_metrics = self.db.evaluate(config, collect_im=True)
            elif current_arm == 'query':
                config = dict(self.query_default, **self.best_result['knob']['config'], **self.best_result['index']['config'])
                _, _, internal_metrics = self.db.evaluate(config, collect_im=True)'''
            if current_arm in self.arms:
                context = self.best_result[current_arm]['context']

            #self.logger.info('current context" {}'.format(internal_metrics))
            self.apply_best() # apply best after db.evaluate
            return context

        #if self.context_type == 'reinit':
        #    config = dict(self.default['query'], **self.default['index'], **self.default['knob'])
        #    time_cost, _, internal_metrics = self.db.evaluate(config, collect_im=True)
        #    return internal_metrics, time_cost

    # TEST
    def evaluate(self, knob, collect_im=True):
        return np.random.randint(300, 600), 1000, np.zeros(65)


class TestAdvisor:
    def __init__(self, *args, **kwargs):
        pass

    def reset_context(self, context):
        pass

    def run(self):
        return ({}, np.random.randint(300, 600))

