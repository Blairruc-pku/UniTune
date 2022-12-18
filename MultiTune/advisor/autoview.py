import os
import pdb
import time
import re
import random
import sys
import csv
from collections import defaultdict
o_path = os.getcwd()
o_path = o_path + "/./"
sys.path.append('..')
sys.path.append('//MultiTune')
sys.path.append(o_path)
from MultiTune.advisor.rl_estimator import RLEstimator
from MultiTune.utils.parser import parse_args
from MultiTune.database.mysqldb import MysqlDB
from .av_files.utils import Trainset_Utils
from .av_files.algorithms.DQN import train_dqn_with_budget, evaluate_with_budget
from .av_files.algorithms.encoder_reducer import Encoder_reducer, EncoderRNN, AttnReducerRNN, Lang, Scale_log_std

sql_list_file = o_path + "scripts/job_queries_each_template_0.txt"
q_mv_list_file = o_path + "MultiTune/advisor/av_files/trainset/q_mv_list.txt"
bitmap_path = o_path + "MultiTune/advisor/av_files/"
log_file = o_path + "MultiTune/advisor/av_files/log.txt"
enc_rdc_model_dir = o_path + "MultiTune/advisor/av_files/algorithms/encoder_reducer/"

DQN_TRAIN_PERC = 0.3


def write_log(log):
    if (len(log) == 1 and log[0] == '\n'):
        with open(log_file, "a") as fd:
            fd.write(log)
        return
    with open(log_file, "a") as fd:
        fd.write("[" + time.asctime() + "]\n" + log + "\n")


class AutoView(RLEstimator):

    def __init__(self, current_context=None,**kwargs):
        super().__init__(**kwargs)
        write_log("initializing advisor")
        self.q_lis = dict()
        self.q_mv_lis = dict()
        self.trainset_utils = Trainset_Utils(self.db)

        self.trainset_utils.generate_trainset_from_data()

        with open(sql_list_file, "r") as fp:
            for line in fp:
                self.q_lis[re.match(r"(.*)\.sql", line).group(1)] = 0

        with open(q_mv_list_file, "r") as fp:
            for line in fp:
                self.q_mv_lis[re.match(r"(.*)\.sql", line).group(1)] = 0

        self.max_opti_solution = None,
        self.max_optimize_tim = -1
        self.current_context = current_context

    def get_view_size(self):
        self.view_size = dict()
        with open(os.path.join(self.db.mv_trainset_dir, "mvdata.csv")) as fp:
            csv_reader = csv.reader(fp)
            for line in csv_reader:
                   self.view_size[line[0]] = float(line[4])/1e6



    def get_view_benefit(self):
        self.mv_benefit = dict()
        self.mv_paris  = defaultdict(list)
        for key in self.trainset_utils.mv_benefit:
            q = key.split('-')[0]
            mv = 'mv' + key.split('-')[1]
            if q in self.trainset_utils.q_time.keys():
                self.trainset_utils.mv_benefit[key]['q'] = self.trainset_utils.q_time[q]
                self.trainset_utils.mv_benefit[key]['benefit'] = - self.trainset_utils.mv_benefit[key]['q_mv'] + self.trainset_utils.mv_benefit[key]['q']
                self.mv_benefit[mv] = self.mv_benefit.get(mv, 0) + self.trainset_utils.mv_benefit[key]['benefit']
                self.mv_paris[mv].append(key)

    def fill_dqn_solution(self, view_config, mv_budget):
        self.get_view_benefit()
        self.get_view_size()
        qvdir, mvlist = dict(), set()
        budget_used = 0
        view_added = list()
        with open(os.path.join(self.db.mv_trainset_dir, "query_mv_q_mv_index.csv")) as fpr:
            reader = csv.reader(fpr)
            i = 0
            for content in reader:
                if view_config[i]:
                    qvdir[content[0]] = content[2]
                    mvlist.add(content[1])
                    budget_used = budget_used + self.view_size[content[1]]
                i = i + 1

        self.logger.info("Storage budget used by DQN is {}".format(budget_used))
        for v in  sorted(self.mv_benefit, key=self.mv_benefit.get, reverse=True):
            if v in mvlist:
                continue
            else:
                if self.mv_benefit[v] > 0 and self.view_size[v] + budget_used < mv_budget:
                    view_added.append(v)
                    self.logger.info("Add view {}, its benefit is {}".format(v, self.mv_benefit[v]))


        with open(os.path.join(self.db.mv_trainset_dir, "query_mv_q_mv_index.csv")) as fpr:
            reader = csv.reader(fpr)
            i = 0
            for content in reader:
                if content[1] in view_added and content[2] in self.mv_paris[content[1]]:
                    view_config[i] = 1
                i = i + 1

        return view_config

    def reset_context(self, context):
        self.current_context = context.tolist()

    def Suggest(self):
        self.max_optimize_tim, self.max_opti_solution = evaluate_with_budget(
            time_budget=self.allocated_infer_time,
            max_opti_solution=self.max_opti_solution,
            max_optimize_tim=self.max_optimize_tim,
            context_feature=self.current_context)

    def run(self,  mv_budget=500, context_feature=None):
        if context_feature is not None and len(context_feature) != 5:
            write_log("using context feature with wrong size, quitting")
            return

        if context_feature is not None:
            self.current_context = context_feature

        time_budget = self.sub_budget
        write_log("advise start with time_budget=%d and mv_budget=%d" %
                  (time_budget, mv_budget))
        write_log("minimum_timeout {} for finial evaluation".format(self.db.minimum_timeout))
        tstart = int(time.time())

        allocated_train_time = time_budget - (self.db.minimum_timeout + 120)
        while time.time() - tstart < allocated_train_time:
            self.UpdatePolicy(allocated_train_time - (time.time() - tstart), mv_budget, self.current_context)

        tmid = time.time()
        self.allocated_infer_time = max(int(time_budget - (tmid - tstart) - self.db.minimum_timeout) - 10, 10)
        write_log("evaluating with budget=%d" % self.allocated_infer_time)
        self.Suggest()
        write_log("evaluation result: %d" % self.max_optimize_tim)
        view_config = {'view.edge': self.max_opti_solution['edge_bitmap'],
                       'view.file_id': int(time.time())}
        with open(self.output_file, 'a') as f:
            write_log("DQN's result:{}\n".format(view_config))

        view_config['view.edge'] = self.fill_dqn_solution(view_config['view.edge'], mv_budget)
        with open(self.output_file, 'a') as f:
            write_log('After filling: {}\n'.format(view_config))
        time_cost, space_cost, _ = self.db.evaluate(view_config)
        with open(self.output_file, 'a') as f:
            f.write('{}\n'.format({
                'configuration': view_config,
                'time_cost': time_cost,
                'max_optimize_tim': self.max_optimize_tim,
                'space_cost': 0,
                'context': self.current_context,
                'arm': 'view_' + str(self.pull_num)
            }))
        write_log("Total time {}".format(time.time() - tstart))


        return  view_config, time_cost[0]


    def UpdatePolicy(self, time_budget, mv_budget=500, context_feature=None):
        write_log("iter start with time_budget=%d and mv_budget=%d" %
                  (time_budget, mv_budget))
        tstart = int(time.time())

        tmp_lis = []
        #for q_id in self.q_lis.keys():
        #    if self.q_lis[q_id] == 0:
        #        tmp_lis.append(q_id)
        for q_mv_id in self.q_mv_lis.keys():
            if self.q_mv_lis[q_mv_id] == 0:
                tmp_lis.append(q_mv_id)

        ##TODO(Jia)
        # first built uncerteinty model
        #X_train = hidden_feature_from_encoder(trainset)
        #Y_train = evluation_result(trainset)
        enc_rdc = Encoder_reducer(context_feature=context_feature)
        enc_rdc.load_model(enc_rdc_path=enc_rdc_model_dir)
        self.trainset_utils.get_hidden_and_benefit_by_triple(enc_rdc)
        #uncertainty_model.build(X_train, Y_train)

        #for q_mv  in tmp_lis:
        #    x_feature = hidden_feature_from_encoder(q_mv)
        #    uncertainty = uncertainty_model(x_feature)

        while len(tmp_lis) > 0 and time.time() - tstart < time_budget * 0.4:
            print("time spent:{}, total budget:{}".format(time.time() - tstart, time_budget * 0.4))
            id_chosen =  random.choice(tmp_lis)
            write_log("found untested item and chose " + id_chosen)

            self.trainset_utils.get_trainset_from_data(
                id_chosen, "q_mv", self.db.workload_timeout)
            self.q_mv_lis[id_chosen] = 1

            self.trainset_utils.get_trainset_from_data(
                id_chosen.split('-')[0], "q", self.db.workload_timeout)
            self.q_lis[id_chosen.split('-')[0]] = 1

            self.update_bitmap()

        tmid = int(time.time())
        if tmid - tstart <= time_budget * 0.5:
            write_log("having enough time left, training...")
            time_left = int(time_budget - (tmid - tstart))
            if random.random() > DQN_TRAIN_PERC:
                write_log("...encoder_reducer with budget=%d" % time_left)
                encoder_reducer = Encoder_reducer(context_feature=context_feature)
                encoder_reducer.init_do_continuously(budget=time_left)
                encoder_reducer.save_model()
            else:
                write_log("...DQN with budget=%d" % time_left)
                train_dqn_with_budget(time_budget=time_left, mv_budget=mv_budget)


    def update_bitmap(self):
        with open(sql_list_file, "r") as fpr:
            with open(bitmap_path + "q.txt", "w") as fpw:
                for line in fpr:
                    fpw.write(
                        str(self.q_lis[re.match(r"(.*)\.sql", line).group(1)])
                        + "\n")

        with open(q_mv_list_file, "r") as fpr:
            with open(bitmap_path + "q_mv.txt", "w") as fpw:
                for line in fpr:
                    fpw.write(
                        str(self.q_mv_lis[re.match(r"(.*)\.sql", line).group(
                            1)]) + "\n")

    def read_bitmap(self):
        with open(sql_list_file, "r") as fp1:
            with open(bitmap_path + "q.txt", "r") as fp2:
                for line in fp1:
                    self.q_lis[re.match(r"(.*)\.sql",
                                        line).group(1)] = int(fp2.readline())

        with open(q_mv_list_file, "r") as fp1:
            with open(bitmap_path + "q_mv.txt", "r") as fp2:
                for line in fp1:
                    self.q_mv_lis[re.match(r"(.*)\.sql", line).group(1)] = int(
                        fp2.readline())


if __name__ == "__main__":
    args_db, args_tune = parse_args()
    db = MysqlDB(args_tune['task_id'], **args_db)
    index_config = {'index.aka_name.name': 'off', 'index.aka_name.person_id': 'on', 'index.cast_info.movie_id': 'off', 'index.cast_info.note': 'off', 'index.cast_info.person_id': 'off', 'index.cast_info.person_role_id': 'off', 'index.cast_info.role_id': 'off', 'index.char_name.id': 'off', 'index.char_name.name': 'off', 'index.comp_cast_type.id': 'off', 'index.comp_cast_type.kind': 'on', 'index.company_name.country_code': 'on', 'index.company_name.id': 'off', 'index.company_name.name': 'off', 'index.company_type.id': 'off', 'index.company_type.kind': 'off', 'index.complete_cast.movie_id': 'on', 'index.complete_cast.status_id': 'on', 'index.complete_cast.subject_id': 'on', 'index.info_type.id': 'on', 'index.info_type.info': 'on', 'index.keyword.id': 'on', 'index.keyword.keyword': 'on', 'index.kind_type.id': 'off', 'index.kind_type.kind': 'on', 'index.link_type.id': 'on', 'index.link_type.link': 'on', 'index.movie_companies.company_id': 'on', 'index.movie_companies.company_type_id': 'on', 'index.movie_companies.movie_id': 'on', 'index.movie_companies.note': 'on', 'index.movie_info.info': 'off', 'index.movie_info.info_type_id': 'off', 'index.movie_info.movie_id': 'on', 'index.movie_info.note': 'off', 'index.movie_info_idx.info': 'off', 'index.movie_info_idx.info_type_id': 'on', 'index.movie_info_idx.movie_id': 'on', 'index.movie_keyword.keyword_id': 'off', 'index.movie_keyword.movie_id': 'on', 'index.movie_link.link_type_id': 'on', 'index.movie_link.linked_movie_id': 'on', 'index.movie_link.movie_id': 'on', 'index.name.gender': 'off', 'index.name.id': 'on', 'index.name.name': 'off', 'index.person_info.info_type_id': 'on', 'index.person_info.note': 'on', 'index.person_info.person_id': 'on', 'index.role_type.id': 'off', 'index.role_type.role': 'on', 'index.title.episode_nr': 'off', 'index.title.id': 'on', 'index.title.kind_id': 'on', 'index.title.production_year': 'on', 'index.title.title': 'off'}
    knob_config = {'knob.back_log': 64052, 'knob.connect_timeout': 19483709, 'knob.eq_range_index_dive_limit': 3055391316, 'knob.flush_time': 0, 'knob.host_cache_size': 41333, 'knob.innodb_adaptive_hash_index': 'on', 'knob.innodb_adaptive_hash_index_parts': 31, 'knob.innodb_adaptive_max_sleep_delay': 838291, 'knob.innodb_api_bk_commit_interval': 859712704, 'knob.innodb_buffer_pool_size': 10513949176, 'knob.innodb_change_buffer_max_size': 0, 'knob.innodb_change_buffering': 'changes', 'knob.innodb_commit_concurrency': 52, 'knob.innodb_compression_failure_threshold_pct': 21, 'knob.innodb_ft_min_token_size': 2, 'knob.innodb_ft_sort_pll_degree': 11, 'knob.innodb_log_file_size': 39307883, 'knob.innodb_log_write_ahead_size': 4898, 'knob.innodb_max_dirty_pages_pct_lwm': 19, 'knob.innodb_max_undo_log_size': 8135181925611179, 'knob.innodb_old_blocks_time': 1891521278, 'knob.innodb_online_alter_log_max_size': 3279057547500876, 'knob.innodb_open_files': 50616, 'knob.innodb_page_cleaners': 8, 'knob.innodb_stats_method': 'nulls_unequal', 'knob.innodb_stats_persistent': 'ON', 'knob.innodb_stats_transient_sample_pages': 58, 'knob.innodb_thread_concurrency': 210, 'knob.join_buffer_size': 878885157, 'knob.key_cache_age_threshold': 10123, 'knob.key_cache_block_size': 7814, 'knob.max_binlog_cache_size': 1008820369947926, 'knob.max_binlog_stmt_cache_size': 22217287787267, 'knob.max_delayed_threads': 3902, 'knob.max_heap_table_size': 464208698, 'knob.max_length_for_sort_data': 6578561, 'knob.max_prepared_stmt_count': 201451, 'knob.max_seeks_for_key': 8127061450255403, 'knob.max_sort_length': 5836862, 'knob.optimizer_prune_level': 0, 'knob.query_alloc_block_size': 94811141, 'knob.query_cache_min_res_unit': 42813, 'knob.range_alloc_block_size': 65244, 'knob.read_rnd_buffer_size': 120366250, 'knob.sort_buffer_size': 34405285, 'knob.stored_program_cache': 313924, 'knob.table_definition_cache': 268796, 'knob.table_open_cache': 151663, 'knob.tmp_table_size': 879506863, 'knob.transaction_prealloc_size': 129737}
    query_config = {'query.file_id': 0}

    db.apply_index_config(index_config)
    db.apply_knob_config(knob_config)
    db.apply_query_config(query_config)

    if os.path.exists(log_file):
        os.remove(log_file)

    av = AutoView(db=db, **args_tune, tune_knob='False', tune_index='False')
    for i in range(36):
        write_log("iter " + str(i))
        max_optimize_tim, max_opti_solution = av.run( context_feature=[1.5,100.0,233,1432.62432,532.66])
