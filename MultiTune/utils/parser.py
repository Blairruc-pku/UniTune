import pdb
import sys
import os
import numpy as np
import configparser
from sqlparse.sql import Where, Comparison, Identifier, Parenthesis

from shutil import copyfile


class DictParser(configparser.ConfigParser):
    def get_dict(self):
        d = dict(self._sections)
        for k in d:
            d[k] = dict(d[k])
        return d


class ConfigParser(object):
    def __init__(self, cnf):
        f = open(cnf)
        self._cnf = cnf
        self._knobs = {}
        for line in f:
            if line.strip().startswith('skip-external-locking') \
                    or line.strip().startswith('[') \
                    or line.strip().startswith('#') \
                    or line.strip() == '':
                continue
            try:
                k, _, v = line.strip().split()
                self._knobs[k] = v
            except:
                continue
        f.close()

    def replace(self, tmp='/tmp/tmp.cnf'):
        record_list = []
        f1 = open(self._cnf)
        f2 = open(tmp, 'w')
        for line in f1:
            tpl = line.strip().split()
            if len(tpl) < 1:
                f2.write(line)
            elif tpl[0] in self._knobs:
                record_list.append(tpl[0])
                tpl[2] = self._knobs[tpl[0]]
                f2.write('%s\t\t%s %s\n' % (tpl[0], tpl[1], tpl[2]))
            else:
                f2.write(line)
        for key in self._knobs.keys():
            if not key in record_list:
                f2.write('%s\t\t%s %s\n' % (key, '=', self._knobs[key]))
        f1.close()
        f2.close()
        copyfile(tmp, self._cnf)

    def set(self, k, v):
        self._knobs[k] = v


def parse_args(config_file='config.ini'):
    cf = DictParser()
    cf.read(config_file, encoding='utf8')
    config_dict = cf.get_dict()
    config_dict['tune']['components'] = eval(config_dict['tune']['components'])
    config_dict['tune']['arms'] = str(list(config_dict['tune']['components'].keys()))
    config_dict['tune']['output_file'] = os.path.join('optimize_history', config_dict['tune']['task_id'] + '.res')
    return config_dict['database'], config_dict['tune']


def parse_benchmark_result(file_path, select_file, timeout=10):
    with open(file_path) as f:
        lines = f.readlines()

    with open(select_file) as f:
        lines_select = f.readlines()
    num_sql = len(lines_select)

    latL = []
    lat_dir = {}
    for line in lines[1:]:
        if line.strip() == '':
            continue
        tmp = line.split('\t')[-1].strip()
        latL.append(float(tmp) / 1000)
        type = line.split('\t')[0].strip()
        lat_dir[type] = float(tmp) / 1000

    for i in range(0, num_sql - len(lines[1:])):
        latL.append(timeout)

    #lat95 = np.percentile(latL, 95)
    lat = np.max(latL)
    lat_mean = np.mean(latL)

    return lat, lat_mean, lat_dir


def parse_records(bo_history, budget):
    time_costs, space_costs = [], []
    inc_config = None
    inc_tc = np.Inf
    inc = None
    for i in range(len(bo_history.data)):
        config = bo_history.get_all_configs()[i].get_dictionary()
        tc = bo_history.get_all_perfs()[i]
        sc = bo_history.constraint_perfs[i][0] + budget

        time_costs.append(tc)
        space_costs.append(sc)
        if tc < inc_tc and sc < budget:
            inc_config = config
            inc_tc = tc
            inc = i


    return time_costs, space_costs, inc_config, inc


def parse_run_history(filename, budget):
    with open(filename, 'r') as f:
        lines = f.readlines()

    lines = [line for line in lines if (not 'best|' in line) and (not 'observe-context|' in line)]
    time_costs, space_costs, arms, time_spent = [], [], [], []
    inc_config = None
    inc_tc = np.Inf
    inc = None

    #pre_context = lines[0]['context']
    for i, line in enumerate(lines):
        try:
            results = eval(line.strip('\n'))
        except:
            pdb.set_trace()
        config = results['configuration']
        if 'context' in results.keys():
            context = results['context']
            arms.append(list(config.keys())[0].split('.')[0] + '_' +str(context))
        else:
            arms.append(list(config.keys())[0].split('.')[0] )
        try:
            tc = float(results['time_cost'][0])
        except:
            tc = float(results['time_cost'])
        sc = float(results['space_cost'])
        try:
            time_spent.append(float(results['time_spent']))
        except:
            time_spent.append(0)
        time_costs.append(tc)
        space_costs.append(sc)
        if tc < inc_tc and sc < budget:
            inc_config = config
            inc_tc = tc
            inc = i

    return time_costs, space_costs, arms, time_spent, inc_config, inc

def strip_config(config):
    config_stripped = {}
    for k in config.keys():
        if '.' in k and k.split('.')[0] in ['knob', 'index', 'query', 'view']:
            i = k.index('.')
            k_new = k[i+1:]
            config_stripped[k_new] = config[k]
        else:
            config_stripped[k] = config[k]
    return config_stripped


def get_increasing_sequence(data):
    """
            Return the increasing sequence.
        :param data:
        :return:
        """
    increasing_sequence = [data[0]]
    for item in data[1:]:
        _inc = increasing_sequence[-1] if item <= increasing_sequence[-1] else item
        increasing_sequence.append(_inc)
    return increasing_sequence


def is_where(token):
    if isinstance(token, Where):
        return True
    return False


def flatten_comparison(tokens):
    comparisons = list()
    for token in tokens:
        if isinstance(token, Parenthesis):
            comparisons.extend(flatten_comparison(token._groupable_tokens))
        elif isinstance(token, Comparison):
            comparisons.append(token)
    return comparisons

import json
import bisect

def initialize_knobs(knobs_config, num):
    global KNOBS
    global KNOB_DETAILS
    if num == -1:
        f = open(knobs_config)
        KNOB_DETAILS = json.load(f)
        KNOBS = list(KNOB_DETAILS.keys())
        f.close()
    else:
        f = open(knobs_config)
        knob_tmp = json.load(f)
        i = 0
        KNOB_DETAILS = {}
        while i < num:
            key = list(knob_tmp.keys())[i]
            KNOB_DETAILS[key] = knob_tmp[key]
            i = i + 1
        KNOBS = list(KNOB_DETAILS.keys())
        f.close()
    return KNOB_DETAILS

def gen_continuous(action):
    knobs = {}

    for idx in range(len(KNOBS)):
        name = KNOBS[idx]
        value = KNOB_DETAILS[name]

        knob_type = value['type']

        if knob_type == 'integer':
            min_val, max_val = value['min'], value['max']
            delta = int((max_val - min_val) * action[idx])
            eval_value = min_val + delta
            eval_value = max(eval_value, min_val)
            if value.get('stride'):
                all_vals = np.arange(min_val, max_val, value['stride'])
                indx = bisect.bisect_left(all_vals, eval_value)
                if indx == len(all_vals): indx -= 1
                eval_value = all_vals[indx]
            # TODO(Hong): add restriction among knobs, truncate, etc
            if max_val > sys.maxsize:
                eval_value = int(eval_value / 1000)
            knobs[name] = eval_value
        if knob_type == 'float':
            min_val, max_val = value['min'], value['max']
            delta = (max_val - min_val) * action[idx]
            eval_value = min_val + delta
            eval_value = max(eval_value, min_val)
            #all_vals = np.arange(min_val, max_val, value['stride'])
            #indx = bisect.bisect_left(all_vals, eval_value)
            #if indx == len(all_vals): indx -= 1
            #eval_value = all_vals[indx]
            knobs[name] = eval_value
        elif knob_type == 'enum':
            enum_size = len(value['enum_values'])
            enum_index = int(enum_size * action[idx])
            enum_index = min(enum_size - 1, enum_index)
            eval_value = value['enum_values'][enum_index]
            # TODO(Hong): add restriction among knobs, truncate, etc
            knobs[name] = eval_value
        elif knob_type == 'combination':
            enum_size = len(value['combination_values'])
            enum_index = int(enum_size * action[idx])
            enum_index = min(enum_size - 1, enum_index)
            eval_value = value['combination_values'][enum_index]
            knobs_names = name.strip().split('|')
            knobs_value = eval_value.strip().split('|')
            for k, knob_name_tmp in enumerate(knobs_names):
                knobs[knob_name_tmp] = knobs_value[k]


    return knobs
