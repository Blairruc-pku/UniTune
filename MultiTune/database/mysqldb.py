import os
import pdb
import sys
import threading
import pymysql
import time
import mysql.connector
import subprocess
import json
import eventlet
import csv
import multiprocessing as mp

sys.path.append('..')
from ..utils.parser import ConfigParser
from ..utils.limit import time_limit,  TimeoutException
from .base import DB


log_num_default = 2
log_size_default = 50331648


class MysqlDB(DB):
    def __init__(self, *args, mysqld, **kwargs):
        self.mysqld = mysqld
        

        # internal metrics collect signal
        self.im_alive_init()
        self.sql_dict = {
            'valid': {},
            'invalid': {}
        }

        super().__init__(*args, **kwargs)

    def _connect_db(self):
        #if self.sock:
        #    conn = mysql.connector.connect(host=self.host,
        #                                   user=self.user,
        #                                   passwd=self.passwd,
        #                                   db=self.dbname,
        #                                   port=self.port,
        #                                   unix_socket=self.sock)
        #else:
        #    conn = mysql.connector.connect(host=self.host,
        #                                   user=self.user,
        #                                   passwd=self.passwd,
        #                                   db=self.dbname,
        #                                   port=self.port)'''
        conn = pymysql.connect( host= self.host,
                                port= int(self.port),
                                database=self.dbname,
                                charset ="utf8",
                                user= "root",
                                unix_socket=self.sock
                                )
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
        mysqladmin = os.path.dirname(self.mysqld) + '/mysqladmin'
        kill_cmd = '{} -u{} -S {} shutdown'.format(mysqladmin, self.user, self.sock)
        force_kill_cmd1 = "ps aux|grep '" + self.sock + "'|awk '{print $2}'|xargs kill -9"
        force_kill_cmd2 = "ps aux|grep '" + self.cnf + "'|awk '{print $2}'|xargs kill -9"

        p_close = subprocess.Popen(kill_cmd, shell=True, stderr=subprocess.STDOUT, stdout=subprocess.PIPE,
                                   close_fds=True)
        try:
            p_close.communicate(timeout=60)
            p_close.poll()
            self.logger.debug('Close MySQL successfully.')
        except subprocess.TimeoutExpired:
            os.system(force_kill_cmd1)
            os.system(force_kill_cmd2)
            self.logger.debug('Force close MySQL!')

    def _start_db(self, isolation=False):
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
                if conn.open:
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
        modify_concurrency = False
        if 'innodb_thread_concurrency' in config.keys() and config['innodb_thread_concurrency'] * (
                200 * 1024) > self.pre_combine_log_file_size:
            true_concurrency = config['innodb_thread_concurrency']
            modify_concurrency = True
            config['innodb_thread_concurrency'] = int(self.pre_combine_log_file_size / (200 * 1024.0)) - 2
            self.logger.info("modify innodb_thread_concurrency")

        if 'innodb_log_file_size' in config.keys():
            log_size = config['innodb_log_file_size']
        else:
            log_size = log_size_default
        if 'innodb_log_files_in_group' in config.keys():
            log_num = config['innodb_log_files_in_group']
        else:
            log_num = log_num_default

        if 'innodb_thread_concurrency' in config.keys() and config['innodb_thread_concurrency'] * (
                200 * 1024) > log_num * log_size:
            self.logger.info("innodb_thread_concurrency is set too large")
            return False


        cnf_parser = ConfigParser(self.cnf)
        knobs_not_in_cnf = []
        for key in config.keys():
            if key not in self.knob_details.keys():
                knobs_not_in_cnf.append(key)
                continue
            cnf_parser.set(key, config[key])
        cnf_parser.replace(os.path.join(self.log_path, 'tmp.cnf'))

        if modify_concurrency:
            self._start_db()
            sql = "SET GLOBAL {}={}".format('innodb_thread_concurrency', true_concurrency)
            self._execute(sql)
            config['innodb_thread_concurrency'] = true_concurrency
            self._close_db()
            for key in config.keys():
                cnf_parser.set(key, config[key])
            cnf_parser.replace(os.path.join(self.log_path, 'tmp.cnf'))


        self.logger.debug('Modify db config file successfully.')
        if len(knobs_not_in_cnf):
            self.logger.debug('Append knobs: {}'.format(knobs_not_in_cnf))
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
        default_knob = {knob: self.knob_details[knob]['default'] for knob in self.knob_details.keys()}
        self._close_db()
        self._modify_cnf(default_knob)
        self.logger.info('Reset Knob: Set Default knobs.')
        self._start_db()

    def reset_all(self, advisor_only=True, advisor_prefix='advisor'):
        all_indexes_dict = self.get_all_indexes(advisor_only, advisor_prefix)
        all_indexes = all_indexes_dict.keys()

        for tab_col in all_indexes:
            if tab_col in self.all_pk_fk:
                continue
            table = tab_col.split('.')[0]
            self._drop_index(table, all_indexes_dict[tab_col])

        self._analyze_table()
        self.logger.info('Reset Index: Drop all indexes, advisor_only={}!'.format(advisor_only))

        default_knob = {knob: self.knob_details[knob]['default'] for knob in self.knob_details.keys()}
        self._close_db()
        self._modify_cnf(default_knob)
        self.logger.info('Reset Knob: Set Default knobs.')
        self._start_db()

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
        try:
            with time_limit(5):
                output = self._fetch_results(sql, json=False)
                explain = json.loads(output[0][0])
                if 'cost_info' in explain['query_block'].keys():
                    cost = float(explain['query_block']['cost_info']['query_cost'])
                else:
                    cost = 0
        except Exception as e:
            cost = 0
            if isinstance(e, TimeoutException):
                self.logger.info("Timed out!")
                self._clear_processlist()
            else:
                self.logger.info('{}: Exception when calling objective function: {}'.format(type, e))

        return cost

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


    def build_mv(self, mv_id):
        self.logger.info("loading " + mv_id)
        with open(os.path.join(self.q_mv_file, mv_id + ".sql"), "r") as fp:
            sql = fp.read()

        self.logger.info("executing " + mv_id + ":\n" + "CREATE TABLE " + mv_id +
                  " " + sql)
        self._execute("DROP TABLE IF EXISTS " + mv_id + ";")
        self._execute("CREATE TABLE " + mv_id + " " + sql)

    def drop_mv(self, mv_id):
        self.logger.info("dropping " + mv_id)
        self._execute("DROP TABLE " + mv_id + ";")


    def execute_from_file(self, sql_id, time_out=600):
        self.logger.info("loading " + sql_id)
        with open(os.path.join(self.q_mv_file , sql_id + ".sql"), "r") as fp:
            sql = fp.read()

        self.logger.info("executing " + sql_id)
        tstart = time.time()
        tend = -1

        try:
            with time_limit(int(time_out)):
                self._execute(sql)
                tend = time.time()
        except TimeoutException as e:
            print("Timed out!")
            self._clear_processlist()

        if tend == -1:
            self.logger.info("timeout!")
            return time_out
        else:
            self.logger.info("successfully executed " + sql_id + " using " +
                      str(tend - tstart) + " seconds.")
            return tend - tstart





