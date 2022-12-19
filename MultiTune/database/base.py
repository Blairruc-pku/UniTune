import os
import pdb
import sys
import time
import json
import logging
import threading
import numpy as np
import sqlparse
import sql_metadata
import subprocess
import csv
import multiprocessing as mp
from abc import ABC, abstractmethod
from ConfigSpace import Configuration
from multiprocessing import Manager
from sqlparse.sql import Identifier
from shutil import copyfile
from ..utils.parser import strip_config

sys.path.append('..')
from ..utils.parser import parse_benchmark_result, is_where, flatten_comparison


class DB(ABC):
    def __init__(self, task_id, dbtype, host, port, user, passwd, dbname, sock, cnf, knob_config_file, knob_num,
                 workload_name, workload_timeout, workload_qlist_file, workload_qdir, q_mv_file, mv_trainset_dir, scripts_dir,
                 log_path='./logs', result_path='./results', restart_wait_time=5, **kwargs
                 ):
        # database
        self.task_id = task_id
        self.dbtype = dbtype
        self.host = host
        self.port = port
        self.user = user
        self.passwd = passwd
        self.dbname = dbname
        self.sock = sock
        self.cnf = cnf
        self.all_pk_fk = None
        self.all_columns = None
     
        # logger
        self.log_path = log_path
        self.logger = self.setup_logger()
        self.result_path = result_path
        if not os.path.exists(self.result_path):
            os.mkdir(self.result_path)

        # initialize
        self.iteration = 0

        # workload
        self.workload_name = workload_name.lower()
        self.workload_timeout = float(workload_timeout)
        self.minimum_timeout = float(workload_timeout)
        self.workload_qlist_file = workload_qlist_file
        self.workload_qdir = workload_qdir
        self.q_mv_file = q_mv_file
        self.mv_trainset_dir = mv_trainset_dir
        self.scripts_dir = scripts_dir
        self.workload = self.generate_workload()
        self.queries = self.get_queries()

        # knob
        self.knob_num = int(knob_num)
        self.knob_config_file = knob_config_file
        self.knob_details = self.get_knobs()
        self.restart_wait_time = restart_wait_time

        try:
            self._connect_db()
        except Exception as e:
            self._start_db()

        # index
        self.all_pk_fk = self.get_pk_fk()
        self.all_columns = self.get_all_columns()
        self.all_index_candidates = self.generate_candidates()
        self.get_all_index_sizes()
        self.pre_combine_log_file_size = float(self.get_varialble_value("innodb_log_file_size")) * float(self.get_varialble_value("innodb_log_files_in_group"))

        # self.reset_index()
        # self.reset_knob()
        #self.reset_all()

        # internal metrics collect signal
        self.im_alive_init()

    @abstractmethod
    def _connect_db(self):
        pass

    @abstractmethod
    def _execute(self, sql):
        pass

    @abstractmethod
    def _fetch_results(self, sql, json=False):
        pass

    @abstractmethod
    def _close_db(self):
        pass

    @abstractmethod
    def _start_db(self, isolation=False):
        pass

    @abstractmethod
    def _modify_cnf(self, config):
        pass

    @abstractmethod
    def _create_index(self, table, col, name=None, advisor_prefix='advisor'):
        pass

    @abstractmethod
    def _drop_index(self, table, name):
        pass

    @abstractmethod
    def _analyze_table(self):
        pass

    @abstractmethod
    def _show_processlist(self):
        pass

    @abstractmethod
    def _clear_processlist(self):
        pass

    @abstractmethod
    def reset_index(self, advisor_only=True, advisor_prefix='adviosr'):
        pass

    @abstractmethod
    def reset_knob(self):
        pass

    @abstractmethod
    def reset_all(self, advisor_only=True, advisor_prefix='advisor'):
        pass

    @abstractmethod
    def get_pk_fk(self):
        pass

    @abstractmethod
    def get_all_columns(self):
        pass

    @abstractmethod
    def get_all_indexes(self, advisor_only=True, advisor_prefix='adviosr'):
        pass

    @abstractmethod
    def get_data_size(self):
        pass

    @abstractmethod
    def get_index_size(self):
        pass

    @abstractmethod
    def get_each_index_size(self):
        pass

    @abstractmethod
    def estimate_query_cost(self, query):
        pass

    def apply_knob_config(self, knob_config):
        if len(knob_config.items()) == 0:
            self.logger.debug('No knob changes.')
            return

        try:
            knob_config = strip_config(knob_config)
        except:
            pass

        _knob_config = {}

        # check scale
        for k, v in knob_config.items():
            if self.knob_details[k.split('.')[1] if '.' in k else k]['type'] == 'integer' and self.knob_details[k.split('.')[1] if '.' in k else k]['max'] > sys.maxsize:
                _knob_config[k] = knob_config[k] * 1000
            else:
                _knob_config[k] = knob_config[k]

        flag = self._modify_cnf(_knob_config)
        if not flag:
            #copyfile(self.cnf.replace('experiment', 'default'), self.cnf)
            raise Exception('Apply knobs failed')
        self.logger.debug("Iteration {}: Knob Configuration Applied to MYCNF!".format(self.iteration))
        self.logger.debug('Knob Config: {}'.format(_knob_config))



    def apply_query_config(self, query_config):
        v = query_config[list(query_config.keys())[0]]
        self.workload_qdir = self.workload_qdir.replace(self.workload_qdir.split('_')[-1], str(v)) + '/'
        self.workload_qlist_file = self.workload_qlist_file.replace(self.workload_qlist_file.split('_')[-1], str(v)) + '.txt'
        self.workload = self.generate_workload(self.workload_qdir, self.workload_qlist_file)


    def apply_config(self,type, config):
        if type == 'knob':
            self.apply_knob_config(config)
        elif type == 'index':
            self.apply_index_config(config)
        elif type == 'query':
            self.apply_query_config(config)
        elif type == 'view':
            self.apply_view_config(config)

    def apply_index_config(self, index_config):
        if len(index_config.items()) == 0:
            self.logger.debug('No index changes.')
            return
        try:
            index_config = strip_config(index_config)
        except:
            pass
        current_indexes_dict = self.get_all_indexes(advisor_only=True)
        current_indexes = current_indexes_dict.keys()

        for tab_col, v in index_config.items():
            if v == 'on' and tab_col not in current_indexes:
                table, column = tab_col.split('.')
                self._create_index(table, column)

            if v == 'off' and tab_col in current_indexes:
                table, column = tab_col.split('.')
                name = current_indexes_dict[tab_col]
                self._drop_index(table, name)

        self._analyze_table()
        self.logger.debug("Iteration {}: Index Configuration Applied!".format(self.iteration))
        self.logger.debug('Index Config: {}'.format(index_config))


    def apply_view_config(self,  view_config):
        try:
            view_config = strip_config(view_config)
        except:
            pass

        v = view_config['file_id']
        view_config = view_config['edge']


        qvdir, mvlist = dict(), set()
        with open(os.path.join(self.mv_trainset_dir , "query_mv_q_mv_index.csv")) as fpr:
            reader = csv.reader(fpr)
            i = 0
            for content in reader:
                if view_config[i]:
                    qvdir[content[0]] = content[2]
                    mvlist.add(content[1])
                i = i + 1


        for mv in mvlist:
            self.build_mv(mv)

        self.logger.info("QV list is {}".format(qvdir))
        with open(self.workload_qlist_file) as f:
            sql_types = f.readlines()
            for i in range(len(sql_types)):
                sql_type = sql_types[i].split('.')[0]
                if not sql_type  in qvdir.keys():
                    if '-' in sql_type: #not in the edge
                        sql_types[i] = sql_type.split('-')[0] + '.sql\n'
                else:
                    sql_types[i] = qvdir[sql_type] + '.sql\n'
                    copyfile(os.path.join(self.q_mv_file, sql_types[i].strip()),  os.path.join(self.workload_qdir, sql_types[i].strip()))

        self.workload_qlist_file = self.workload_qlist_file.replace(self.workload_qlist_file.split('_')[-1], str(v)) + '.txt'
        with open(self.workload_qlist_file, 'w') as f:
            f.writelines(sql_types)

        self.workload = self.generate_workload(self.workload_qdir, self.workload_qlist_file)




    def generate_workload(self, workload_qdir=None, workload_qlist_file=None):
        if workload_qdir is None:
            workload_qdir = self.workload_qdir
        if workload_qlist_file is None:
            workload_qlist_file = self.workload_qlist_file
            
        if self.workload_name in ['tpch', 'job']:
            script = os.path.join(self.scripts_dir, 'run_{}.sh'.format(self.dbtype))
            wl = {
                'type': 'read',
                'cmd': 'bash %s %s %s {output} %s %s %s' % (script, workload_qdir, workload_qlist_file, self.sock, self.dbname, self.workload_timeout * 1000)
            }
        else:
            raise ValueError('Invalid workload name')
        return wl

    def get_queries(self):
        queries = []
        with open(self.workload_qlist_file, 'r') as f:
            query_list = f.read().strip().split('\n').copy()

        for q in query_list:
            qf = os.path.join(self.workload_qdir, q)
            with open(qf, 'r') as f:
                query = f.read().strip()
                queries.append(query)
        return queries

    def generate_candidates(self):
        all_used_columns = set()

        for i, sql in enumerate(self.queries):

            parser = sql_metadata.Parser(sql)
            try:
                all_used_columns.update(parser.columns)
                # columns_dict = parser.columns_dict
                # mapper = parser._columns_with_tables_aliases
                #
                # indexable_columns = {
                #     'projection': columns_dict.get('select', list()),
                #     'order_by': columns_dict.get('order_by', list()),
                #     'group_by': columns_dict.get('group_by', list()),
                #     'filter': list(),
                #     'join': list()
                # }
                #
                # # classify Filter and Join from WHERE clause
                # stmt = sqlparse.parse(sql)[0]
                # where_clause = stmt.token_matching(funcs=is_where, idx=0)
                # comparisons = flatten_comparison(where_clause)
                # for comp in comparisons:
                #     left = comp.left
                #     right = comp.right
                #     if isinstance(left, Identifier) and isinstance(right, Identifier):  # Join
                #         indexable_columns['join'].append(mapper[left.value])
                #         indexable_columns['join'].append(mapper[right.value])
                #     else:
                #         indexable_columns['filter'].append(mapper[left.value])
                #
                # used_columns = set()
                # for key in indexable_columns.keys():
                #     indexable_columns[key].sort()
                #     used_columns.update(set(indexable_columns[key]))
                #
                # all_used_columns.update(used_columns)

            except:
                print(f'{i+1}.sql ')
                # print(sqlparse.format(sql, reindent=True))
                continue

        all_used_columns = list(all_used_columns)
        result = list()

        for column in all_used_columns:
            if column == '*':
                continue
            if '.' not in column:  # no table
                for table, columns in self.all_columns.items():
                    if column in columns:
                        index = '%s.%s' % (table, column)
                        if index not in result:
                            result.append(index)
                        break
            else:
                index = column
                if index not in result:
                    result.append(index)

        result.sort()
        self.logger.info('Initialize {} Indexes'.format(len(result)))
        return result

    def generate_benchmark_cmd(self):
        timestamp = int(time.time())
        filename = self.result_path + '/{}.log'.format(timestamp)

        if self.workload_name in ['tpch', 'job']:
            cmd = self.workload['cmd'].format(output=filename)
        else:
            raise ValueError('Invalid workload name')
        return cmd, filename

    def setup_logger(self):
        if not os.path.exists(self.log_path):
            os.mkdir(self.log_path)

        logger = logging.getLogger(self.task_id)
        logger.propagate = False
        logger.setLevel(logging.DEBUG)
        # formatter = logging.Formatter('[%(asctime)s:%(filename)s#L%(lineno)d:%(levelname)s]: %(message)s')
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

        return logger

    def estimate(self, index_config=None):
        self.iteration += 1

        if index_config is not None:
            self.apply_index_config(index_config)

        all_cost = 0
        for query in self.queries:
            all_cost += self.estimate_query_cost(query)

        space_cost = self.get_index_size()

        return all_cost, space_cost

    def evaluate(self, config, collect_im=False):
        #return(np.random.random(), np.random.random()), 0, np.random.random(65)
        self.iteration += 1

        if isinstance(config, Configuration):
            config = config.get_dictionary()

        index_config = {}
        knob_config = {}
        view_config = {}
        workload_qlist_file = self.workload_qlist_file
        for k, v in config.items():
            if k.startswith('index.'):
                index_config[k[6:]] = v
            elif k.startswith('knob.'):
                knob_config[k[5:]] = v
            elif k.startswith('view.'):
                view_config[k]= v
            elif k.startswith('query.') and not str(v) == '':
                self.logger.debug("Iteration {}: Query Configuration Applied!".format(self.iteration))
                q_dir = self.workload_qdir.replace(self.workload_qdir.split('_')[-1], str(v)) + '/'
                workload_qlist_file = self.workload_qlist_file.replace(self.workload_qlist_file.split('_')[-1], str(v)) + '.txt'
                self.workload = self.generate_workload(q_dir, workload_qlist_file)
        self._close_db()
        self.apply_knob_config(knob_config)

        start_success = self._start_db()
        if not start_success:
            raise Exception

        self.logger.debug('restarting mysql, sleeping for {} seconds'.format(self.restart_wait_time))
        if len(view_config.keys()):
            self.apply_view_config(view_config)

        self.apply_index_config(index_config)

        # collect internal metrics
        internal_metrics = Manager().list()
        im = mp.Process(target=self.get_internal_metrics, args=(internal_metrics, self.workload_timeout, 0))
        self.set_im_alive(True)
        if collect_im:
            im.start()

        # run benchmark
        timeout = False
        cmd, filename = self.generate_benchmark_cmd()

        self.logger.debug("Iteration {}: Benchmark start, saving results to {}!".format(self.iteration, filename))
        self.logger.info(cmd)
        p_benchmark = subprocess.Popen(cmd, shell=True, stderr=subprocess.STDOUT, stdout=subprocess.PIPE,
                                       close_fds=True)
        self.logger.info(cmd)

        try:
            p_benchmark.communicate(timeout=self.workload_timeout)
            p_benchmark.poll()
            self.logger.debug("Iteration {}: Benchmark finished!".format(self.iteration))

        except subprocess.TimeoutExpired:
            timeout = True
            self.logger.debug("Iteration {}: Benchmark timeout!".format(self.iteration))
            self._clear_processlist()

            self.logger.debug("Iteration {}: Clear database processes!".format(self.iteration))

        # stop collecting internal metrics
        im_result = np.zeros(65)
        if collect_im:
            self.set_im_alive(False)
            im.join()

            keys = list(internal_metrics[0].keys())
            keys.sort()
            for idx in range(len(keys)):
                key = keys[idx]
                data = [x[key] for x in internal_metrics]
                im_result[idx] = float(sum(data)) / len(data)

        # get costs
        time.sleep(1)
        space_cost = self.get_index_size()

        if self.workload_name in ['tpch', 'job']:
            dirname, _ = os.path.split(os.path.abspath(__file__))
            time_cost, lat_mean, time_cost_dir = parse_benchmark_result(filename, workload_qlist_file, self.workload_timeout)
            self.time_cost_dir = time_cost_dir
        else:
            raise ValueError

        self.logger.info("Iteration {}: configuration {}\t time_cost {}\t space_cost {}\t timeout {} \t lat_mean {}".format(
            self.iteration, config, time_cost, space_cost, timeout, lat_mean))

        if time_cost < self.minimum_timeout:
            self.minimum_timeout = time_cost
        return (lat_mean, time_cost), space_cost, im_result

    def im_alive_init(self):
        global im_alive
        im_alive = mp.Value('b', True)

    def set_im_alive(self, value):
        im_alive.value = value

    def get_internal_metrics(self, internal_metrics, run_time, warmup_time):
        _counter = 0
        _period = 5
        count = (run_time + warmup_time) / _period - 1
        warmup = warmup_time / _period

        def collect_metric(counter):
            counter += 1
            timer = threading.Timer(float(_period), collect_metric, (counter,))
            timer.start()
            if counter >= count or not im_alive.value:
                timer.cancel()
            if counter > warmup:
                sql = 'SELECT NAME, COUNT from information_schema.INNODB_METRICS where status="enabled" ORDER BY NAME'
                res = self._fetch_results(sql)
                im_dict = {}
                for (k, v) in res:
                    im_dict[k] = v
                internal_metrics.append(im_dict)

        collect_metric(_counter)
        return internal_metrics

    def get_knobs(self):
        with open(self.knob_config_file, 'r') as f:
            knob_tmp = json.load(f)
            knobs = list(knob_tmp.keys())

        i = 0
        knob_details = dict()
        while i < self.knob_num:
            key = knobs[i]
            knob_details[key] = knob_tmp[key]
            i = i + 1

        self.logger.info('Initialize {} Knobs'.format(len(knob_details.keys())))
        return knob_details

    def get_all_index_sizes(self, path='/tmp/indexsize.json'):
        if os.path.exists(path):
            return

        indexsize = {}
        default = {index: 'off' for index in self.all_index_candidates}
        for index in self.all_index_candidates:
            config = default.copy()
            config[index] = 'on'
            self.apply_index_config(config)
            indexsize[index] = self.get_index_size()
            print("index {}:{}".format(index, indexsize[index] ))

        with open(path, 'w') as f:
            json.dump(indexsize, f, indent=4)