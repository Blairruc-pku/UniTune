import copy
import sys
import pdb
import numpy as np
import time
import copy
from tqdm import tqdm
sys.path.append('..')
from openbox.optimizer.generic_smbo import SMBO
from .bo import BO


class OtterTune(BO):
    def __init__(self,  **kwargs):
        super().__init__(**kwargs)
        self.model = SMBO(
            self.evaluate,
            self.config_space,
            num_objs=1,
            num_constraints=1,
            surrogate_type='context_prf',
            constraint_surrogate_type='linear',
            acq_optimizer_type='local_random',
            initial_runs=self.init_runs,
            init_strategy='random_explore_first',
            task_id=self.task_id,
            time_limit_per_trial=1000,
            current_context=self.current_context,
            context_pca_components = int(kwargs['context_pca_components']),
            random_state=self.random_state,
            advisor_kwargs={'constraint_budget': self.budget}
        )

        if not self.cost_aware:
            self.model.max_iterations =  0
        else:
            self.model.runtime_limit =  0
            self.model.budget_left = 0

    def Suggest(self):
        config = self.model.config_advisor.get_suggestion()
        return config
    
    def UpdatePolicy(self, observation):
        self.model.config_advisor.update_observation(observation)