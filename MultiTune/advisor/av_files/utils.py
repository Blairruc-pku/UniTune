import os
import sys
import pymysql
import eventlet
import time
import csv
import re
from collections import defaultdict

o_path = os.getcwd()
o_path = o_path + "/./"
sys.path.append(o_path)

sql_list_file = o_path + "scripts/job_queries_each_template_0.txt"
q_mv_list_file = o_path + "MultiTune/advisor/av_files/trainset/q_mv_list.txt"
sql_dir = o_path + "queries/join-order-benchmark/"
trainset_dir = o_path + "MultiTune/advisor/av_files/trainset/"
data_dir = o_path + "MultiTune/advisor/av_files/trainset/data/"
log_file = o_path + "MultiTune/advisor/av_files/log.txt"
scripts_dir = o_path + "scripts"

CONFIG = {
    "host": "127.0.0.1",
    "port": 3306,
    "database": "imdbload",
    "charset": "utf8",
    "user": "root"
}


def write_log(log):
    with open(log_file, "a") as fd:
        fd.write("[" + time.asctime() + "]\n" + log + "\n")



class Trainset_Utils(object):

    def __init__(self, db):
        self.db = db
        self.q_time = dict()
        self.mv_benefit = defaultdict(dict)


    def get_trainset_from_data(self, sql_id, type, budget):
        if type == "q_mv":
            write_log("building view for q_mv")
            with open(data_dir + "query_mv_q_mv_index.csv") as fpr:
                reader = csv.reader(fpr)
                for row in reader:
                    if row[2] == sql_id:
                        self.db.build_mv(row[1])

        write_log("getting trainset for " + sql_id)
        t = self.db.execute_from_file(sql_id, budget)

        if t == -1:
            if type == 'q':
                self.q_time[sql_id] = t
            else:
                self.mv_benefit[sql_id]['q_mv'] = t
            return
        else:
            if type == "q":
                with open(trainset_dir + "querydata.csv") as fpr:
                    reader = csv.reader(fpr)
                    for row in reader:
                        if row[0] == sql_id:
                            row[3] = t
                        with open(trainset_dir + "nquerydata.csv",
                                  "a",
                                  newline="") as fpw:
                            writer = csv.writer(fpw)
                            writer.writerow(row)
                os.remove(trainset_dir + "querydata.csv")
                os.rename(trainset_dir + "nquerydata.csv",
                          trainset_dir + "querydata.csv")
                self.q_time[sql_id] = t
            elif type == "q_mv":
                with open(trainset_dir + "query-mvdata.csv") as fpr:
                    reader = csv.reader(fpr)
                    for row in reader:
                        if row[0] == sql_id:
                            row[3] = t
                        with open(trainset_dir + "nquery-mvdata.csv",
                                  "a",
                                  newline="") as fpw:
                            writer = csv.writer(fpw)
                            writer.writerow(row)
                os.remove(trainset_dir + "query-mvdata.csv")
                os.rename(trainset_dir + "nquery-mvdata.csv",
                          trainset_dir + "query-mvdata.csv")
                with open(trainset_dir + "query_mv_q_mv_index.csv",
                          "r") as fpr:
                    reader = csv.reader(fpr)
                    for row in reader:
                        if row[2] == sql_id:
                            # with open(trainset_dir + "query_mv_q_mv_index.csv",
                            #           "a") as fpw:
                            #     writer = csv.writer(fpw)
                            #     writer.writerow(row)
                            write_log("dropping view")
                            self.db.drop_mv(row[1])

                self.mv_benefit[sql_id]['q_mv'] = t

    def generate_trainset_from_data(self):
        write_log("getting query list")
        q_lis = []
        with open(sql_list_file, "r") as fp:
            for line in fp:
                q_lis.append(re.match(r"(.*)\.sql", line).group(1))

        write_log("getting mv and q_mv list, producing q_mv list file")
        mv_lis = []
        q_mv_lis = []
        if os.path.exists(q_mv_list_file):
            os.remove(q_mv_list_file)
        if os.path.exists(trainset_dir + "query_mv_q_mv_index.csv"):
            os.remove(trainset_dir + "query_mv_q_mv_index.csv")
        with open(data_dir + "query_mv_q_mv_index.csv") as fpr:
            with open(trainset_dir + "query_mv_q_mv_index.csv", "a") as fp:
                reader = csv.reader(fpr)
                writer = csv.writer(fp)
                for row in reader:
                    for q_id in q_lis:
                        if row[0] == q_id:
                            q_mv_lis.append(row[2])
                            with open(q_mv_list_file, "a") as fp:
                                fp.write(row[2] + ".sql\n")

                            if row[1] not in mv_lis:
                                mv_lis.append(row[1])

                            writer.writerow(row)

        write_log("producing trainset")
        if os.path.exists(trainset_dir + "querydata.csv"):
            os.remove(trainset_dir + "querydata.csv")
        with open(data_dir + "querydata.csv") as fpr:
            with open(trainset_dir + "querydata.csv", "a") as fpw:
                reader = csv.reader(fpr)
                writer = csv.writer(fpw)
                for row in reader:
                    if row[0] in q_lis:
                        row[3] = "600"
                        writer.writerow(row)

        if os.path.exists(trainset_dir + "mvdata.csv"):
            os.remove(trainset_dir + "mvdata.csv")
        with open(data_dir + "mvdata.csv") as fpr:
            with open(trainset_dir + "mvdata.csv", "a") as fpw:
                reader = csv.reader(fpr)
                writer = csv.writer(fpw)
                for row in reader:
                    if row[0] in mv_lis:
                        writer.writerow(row)

        if os.path.exists(trainset_dir + "query-mvdata.csv"):
            os.remove(trainset_dir + "query-mvdata.csv")
        with open(data_dir + "query-mvdata.csv") as fpr:
            with open(trainset_dir + "query-mvdata.csv", "a") as fpw:
                reader = csv.reader(fpr)
                writer = csv.writer(fpw)
                for row in reader:
                    if row[0] in q_mv_lis:
                        row[3] = "600"
                        writer.writerow(row)

    def get_hidden_and_benefit_by_triple(self, enc_rdc):
        result = dict()
        with open(trainset_dir + "query_mv_q_mv_index.csv") as fd1:
            reader1 = csv.reader(fd1)
            with open(trainset_dir + "querydata.csv") as fd2:
                reader2 = csv.reader(fd2)
                with open(trainset_dir + "mvdata.csv") as fd3:
                    reader3 = csv.reader(fd3)
                    with open(trainset_dir + "query-mvdata.csv") as fd4:
                        reader4 = csv.reader(fd4)
                        for row1 in reader1:
                            for row2 in reader2:
                                if row2[0] == row1[0]:
                                    q_seq = row2[1]
                                    q_tim = row2[3]
                            for row3 in reader3:
                                if row3[0] == row1[1]:
                                    mv_seq = row3[1]
                            for row4 in reader4:
                                if row4[0] == row4[2]:
                                    q_mv_tim = row4[3]
                            _, _, _, hidden = enc_rdc.evaluate(q_seq, mv_seq)
                            result[row1[2]]=[hidden, q_tim - q_mv_tim]
        return result