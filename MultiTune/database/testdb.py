import os
import pdb
import sys
import copy
import numpy as np
import threading
import pandas as pd
import time
import mysql.connector
import subprocess
import json
import joblib
import multiprocessing as mp

sys.path.append('..')
from ..utils.parser import ConfigParser
from .base import DB

log_num_default = 2
log_size_default = 50331648


class TestDB(DB):
    def __init__(self, *args, mysqld, model=None, **kwargs):
        super().__init__(*args, **kwargs)
        self.mysqld = mysqld
        self.db_connected = False
        #self.loaded_rf = joblib.load(os.path.join("/data2/ruike/MultiTune/scripts/rf_models", model))
        default_index = dict()
        for c in self.all_index_candidates:
            default_index['index.%s' % c] = 'off'

        self.applied_config ={
            'index': default_index,
            'knob': {'knob.innodb_buffer_pool_size': 7811652887.0, 'knob.innodb_log_file_size': 1073741824, 'knob.innodb_thread_concurrency': 0, 'knob.table_definition_cache': 524288},
            'query': {'query.file_id':0}
        }

        # internal metrics collect signal
        self.im_alive_init()
        self.sql_dict = {
            'valid': {},
            'invalid': {}
        }
        self.query_count = 0
        self.config_perf_dict = self.get_grid_result()

        super().__init__(*args, **kwargs)

    def get_grid_result(self):
        f = open("/data2/ruike/MultiTune/scripts/table_models/table_result.json")
        config_perf_dict = json.load(f)
        '''f1 = open("/data2/ruike/MultiTune/scripts/table_models/grid_result_0821_24.json")
        f2 = open("/data2/ruike/MultiTune/scripts/table_models/grid_result_0821.json")
        config_perf_dict = {}
        res1 = json.load(f1)
        res2 = json.load(f2)
        for k in res1.keys():
            if res1[k]['time'] == 'timeout':
                res1[k]['time'] = 180
            if k in res2.keys():
                if res2[k]['time'] == 'timeout':
                    res2[k]['time'] = 180
                t = (float(res1[k]['time']) + float(res2[k]['time']))/2
            else:
                t = res1[k]['time']
            config_perf_dict[k] = copy.deepcopy(res1[k])
            config_perf_dict[k]['time'] = t

        for k in res2.keys():
            if not k in res1.keys():
                config_perf_dict[k] = copy.deepcopy(res2[k])'''

        return config_perf_dict


    def rf_inference(self, config):
        f = open('/data2/ruike/MultiTune/knob_configs/mysql_new.json')
        knobs_dict = json.load(f)
        if 'time' in config.keys():
            del config['time']

        for k in config.keys():
            if config[k] == 'on':
                config[k] = 1
            if config[k] == 'off':
                config[k] = 0
            if isinstance(config[k], str):
                unique_value = knobs_dict[k[5:]]['enum_values']
                unique_value.sort()
                value_map = dict((v, i) for i, v in enumerate(unique_value))
                config[k] = value_map[config[k]]

        df = pd.DataFrame([config])
        columns = df.columns.tolist()
        columns.sort()
        df = df[columns]
        y_pred = self.loaded_rf.predict(df)[0]

        return y_pred

    '''def evaluate(self, config, collect_im=False):
        config_type = np.unique([k.split('.')[0] for k in config.keys()]).tolist()
        if  config_type[0] == 'query':
            self.query_count = self.query_count + 1
        if not isinstance(config, dict):
            config_input = config.get_dictionary()
        else:
            config_input = copy.deepcopy(config)

        config_evaluated = copy.deepcopy(config_input)
        if not 'knob' in config_type:
            config_evaluated = {**config_evaluated, **self.applied_config['knob']}
        if not 'index' in config_type:
            config_evaluated = {**config_evaluated, **self.applied_config['index']}

        for key in config_input.keys():
            if key.startswith('knob.'):
                self.applied_config['knob'][key] = config_input[key]
            elif key.startswith('index.'):
                self.applied_config['index'][key] = config_input[key]
            elif key.startswith('query.'):
                self.applied_config['query'][key] = config_input[key]
                del config_evaluated['query.file_id']

        if self.query_count == 2 or self.query_count == 3:
            delta_value = - 12
        else:
            delta_value = int(self.applied_config['query']['query.file_id'])

        lat_mean = self.rf_inference(config_evaluated) + delta_value
        time_cost = np.random.rand()
        space_cost = np.random.rand()
        im_result = None
        return  (lat_mean, time_cost), space_cost, im_result'''

    def evaluate(self, config, collect_im=False):
        config_type = np.unique([k.split('.')[0] for k in config.keys()]).tolist()
        if not isinstance(config, dict):
            config_input = config.get_dictionary()
        else:
            config_input = copy.deepcopy(config)

        config_evaluated = copy.deepcopy(config_input)
        if not 'knob' in config_type:
            config_evaluated = {**config_evaluated, **self.applied_config['knob']}
        if not 'index' in config_type:
            config_evaluated = {**config_evaluated, **self.applied_config['index']}
        if not 'query' in config_type:
            config_evaluated = {**config_evaluated, **self.applied_config['query']}


        queries_dir = {
            "0": [],
            "1": [2],
            "2": [2, 1],
            "3": [2,1,1]
        }

        index_config = {}
        knob_config = {}

        for k, v in config_evaluated.items():
            if k.startswith('knob.'):
                self.applied_config['knob'][k] = v
                knob_config[k[5:]] = v
            elif k.startswith('index.'):
                self.applied_config['index'][k] = v
                index_config[k[6:]] = v
            elif k.startswith('query.'):
                self.applied_config['query'][k] = v
                rules = queries_dir[v]

        lat_mean = -1
        for k,v  in self.config_perf_dict.items():
            if not v['index'] == index_config:
                continue
            if not v['knob'] == knob_config:
                continue
            if v['rule'] == rules:
                lat_mean =  v['time']


        if lat_mean == -1:
            lat_mean = 180

        if isinstance(lat_mean, tuple ) or isinstance(lat_mean, str ):
            lat_mean = 180


        time_cost = np.random.rand()
        space_cost = np.random.rand()
        im_result = None
        return (lat_mean, time_cost), space_cost, im_result



        #if config in self.config_perf_dict:

    def apply_knob_config(self, knob_config):
        self.applied_config['knob'] = copy.deepcopy(knob_config)
        self.logger.debug("Iteration {}: Knob Configuration Applied to MYCNF!".format(self.iteration))
        self.logger.debug('Knob Config: {}'.format(knob_config))

    def apply_query_config(self, query_config):
        self.applied_config['query'] = copy.deepcopy(query_config)
        return

    def apply_index_config(self, index_config):
        self.applied_config['index'] = copy.deepcopy(index_config)
        self.logger.debug("Iteration {}: Index Configuration Applied!".format(self.iteration))
        self.logger.debug('Index Config: {}'.format(index_config))

    def _connect_db(self):
        if self.sock:
            conn = mysql.connector.connect(host=self.host,
                                           user=self.user,
                                           passwd=self.passwd,
                                           db=self.dbname,
                                           port=self.port,
                                           unix_socket=self.sock)
        else:
            conn = mysql.connector.connect(host=self.host,
                                           user=self.user,
                                           passwd=self.passwd,
                                           db=self.dbname,
                                           port=self.port)
        self.db_connected = True
        return conn

    def _execute(self, sql):
        conn = self._connect_db()
        cursor = conn.cursor()
        cursor.execute(sql)
        if cursor: cursor.close()
        if conn: conn.close()


    def _fetch_results(self, sql, json=False):
        conn = self._connect_db()
        cursor = conn.cursor()
        try:
            cursor.execute(sql)
            results = cursor.fetchall()
            if cursor: cursor.close()
            if conn: conn.close()

            if json:
                columns = [col[0] for col in cursor.description]
                return [dict(zip(columns, row)) for row in results]
            return results
        except:
            return  None

    def _fetch_results2(self, sql, json=False):
        conn = self._connect_db()
        cursor = conn.cursor()
        try:
            cursor.execute(sql)
            results = cursor.fetchall()
            if cursor: cursor.close()
            if conn: conn.close()

            if json:
                columns = [col[0] for col in cursor.description]
                return [dict(zip(columns, row)) for row in results]
            return results, True
        except:
            return  None, False

    def _close_db(self):
        return

    def _start_db(self, isolation=False):
        if self.db_connected:
            return
        proc = subprocess.Popen([self.mysqld, '--defaults-file={}'.format(self.cnf)])
        self.pid = proc.pid
        if isolation:
            cmd = 'sudo cgclassify -g memory,cpuset:server ' + str(self.pid)
            p = os.system(cmd)
            if not p:
                self.logger.debug('add {} to memory,cpuset:server'.format(self.pid))
            else:
                self.logger.debug('Failed: add {} to memory,cpuset:server'.format(self.pid))

        time.sleep(self.restart_wait_time)
        # test connection
        count = 0
        start_success = True
        while True:
            try:
                conn = self._connect_db()
                if conn.is_connected():
                    self.logger.debug('Start MySQL successfully. PID {}.'.format(self.pid))
                    # self.logger.debug('Wait {} seconds for connection'.format(count))
                    conn.close()
                    self.pre_combine_log_file_size = float(self.get_varialble_value("innodb_log_file_size")) * float(
                        self.get_varialble_value("innodb_log_files_in_group"))
                    break
            except:
                time.sleep(1)
                count = count + 1
                if count > 600:
                    start_success = False
                    self.logger.error("Can not start MySQL!")
                    break

        return start_success

    def _modify_cnf(self, config):
        self.logger.debug('Modify db config file successfully.')
        return True

    def _create_index(self, table, column, name=None, advise_prefix='advisor'):
        if name is None:
            name = '%s_%s' % (advise_prefix, column)
        sql = "CREATE INDEX %s ON %s (%s);" % (name, table, column)
        try:
            self._execute(sql)
            self.logger.debug('[success] %s' % sql)
        except Exception as e:
            self.logger.debug('[failed] %s %s' % (sql, e))

    def _drop_index(self, table, name):
        sql = "ALTER TABLE %s DROP INDEX %s;" % (table, name)
        try:
            self._execute(sql)
            self.logger.debug('[success] %s' % sql)
        except Exception as e:
            self.logger.debug('[failed] %s %s' % (sql, e))

    def _analyze_table(self):
        sql = "ANALYZE TABLE {};"
        for table in self.all_columns.keys():
            self._fetch_results(sql.format(table))

    def _show_processlist(self):
        sql = "show processlist"
        return self._fetch_results(sql, json=True)

    def _clear_processlist(self):
        mysqladmin = os.path.dirname(self.mysqld) + '/mysqladmin'
        clear_cmd = mysqladmin + ' processlist -uroot -S ' + self.sock + """ | awk '$2 ~ /^[0-9]/ {print "KILL "$2";"}' | mysql -uroot -S """ + self.sock
        subprocess.Popen(clear_cmd, shell=True, stderr=subprocess.STDOUT, stdout=subprocess.PIPE, close_fds=True)

    def reset_index(self, advisor_only=True, advisor_prefix='advisor'):
        all_indexes_dict = self.get_all_indexes(advisor_only, advisor_prefix)
        all_indexes = all_indexes_dict.keys()

        for tab_col in all_indexes:
            if tab_col in self.all_pk_fk:
                continue
            table = tab_col.split('.')[0]
            self._drop_index(table, all_indexes_dict[tab_col])

        self._analyze_table()
        self.logger.debug('Reset Index: Drop all indexes, advisor_only={}!'.format(advisor_only))
        self._close_db()
        self._start_db()

    def reset_knob(self):
        return

    def reset_all(self, advisor_only=True, advisor_prefix='advisor'):
        self.logger.info('Reset Index: Drop all indexes, advisor_only={}!'.format(advisor_only))
        self.logger.info('Reset Knob: Set Default knobs.')


    def get_pk_fk(self):
        sql = "SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA='%s';" % self.dbname
        results = self._fetch_results(sql, json=False)
        return ['{}.{}'.format(row[0], row[1]) for row in results]

    def get_all_columns(self):
        sql = "SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='%s' ORDER BY TABLE_NAME, ORDINAL_POSITION;" % self.dbname
        result = self._fetch_results(sql, json=False)

        columns_dict = {}
        for row in result:
            table, column = row
            if table not in columns_dict.keys():
                columns_dict[table] = list()
            columns_dict[table].append(column)
        return columns_dict

    def get_all_indexes(self, advisor_only=True, advisor_prefix='advisor'):
        sql = 'SHOW INDEX FROM {};'
        indexes = {}
        for table in self.all_columns.keys():
            results = self._fetch_results(sql.format(table), json=False)
            for row in results:
                name, column = row[2], row[4]
                if not advisor_only:
                    indexes['%s.%s' % (table, column)] = name
                elif name.startswith(advisor_prefix):
                    indexes['%s.%s' % (table, column)] = name
        return indexes

    def get_data_size(self):
        sql = "SELECT ROUND(SUM(data_length)/(1024*1024), 2) AS 'Total Data Size' FROM INFORMATION_SCHEMA.TABLES  WHERE table_schema='%s';" % self.dbname
        data_size = self._fetch_results(sql, json=False)[0][0]
        return float(data_size)

    def get_index_size(self):
        sql = "SELECT ROUND(SUM(index_length)/(1024*1024), 2) AS 'Total Index Size' FROM INFORMATION_SCHEMA.TABLES  WHERE table_schema='%s';" % self.dbname
        index_size = self._fetch_results(sql, json=False)[0][0]
        return float(index_size)

    def get_varialble_value(self, variable):
        sql = 'show global variables like "{}"'.format(variable)
        value = self._fetch_results(sql, json=False)[0][1]
        return value

    def get_each_index_size(self):
        all_index_sizes = {}
        for candidate in self.all_index_candidates:
            table, column = candidate.split('.')
            self.reset_index()
            self._create_index(table, column)
            all_index_sizes[candidate] = self.get_index_size()
            print("{}:{}".format(candidate, all_index_sizes[candidate]))
        return all_index_sizes

    def estimate_query_cost(self, query):
        sql = "EXPLAIN FORMAT=JSON {}".format(query)
        output = self._fetch_results(sql, json=False)
        explain = json.loads(output[0][0])
        if 'cost_info' in explain['query_block'].keys():
            cost = float(explain['query_block']['cost_info']['query_cost'])
        else:
            cost = 0

        return cost



    def im_alive_init(self):
        global im_alive
        im_alive = mp.Value('b', True)

    def set_im_alive(self, value):
        im_alive.value = value

    def validate_sql(self, sql):
        sql = sql.replace("FALSE IS NULL DESC, FALSE DESC,","")
        sql = sql.replace(", FALSE IS NULL DESC, FALSE DESC", "")
        sql = sql.replace(", FALSE IS NULL, FALSE", "")
        sql = sql.replace("FALSE IS NULL, FALSE,", "")
        if sql in self.sql_dict['valid'].keys():
            return 1, self.sql_dict['valid'][sql]
        elif sql in self.sql_dict['invalid'].keys():
            #pdb.set_trace()
            return 0, ''

        conn = self._connect_db()
        cur = conn.cursor()
        fail = 1
        i=0
        cnt = 3
        while fail == 1 and i<cnt:
            try:
                fail = 0
                cur.execute('explain FORMAT=JSON '+sql)
            except Exception as e:
                fail = 1
                print(e)
                print(sql+'\n')
            res = []
            if fail == 0:
                res = cur.fetchall()
            i = i + 1

        if fail == 1:
            #print("SQL Execution Fatal!!")
            self.sql_dict['invalid'][sql] = ''
            return 0, ''
        elif fail == 0:
            self.sql_dict['invalid'][sql] = res
            return 1, res