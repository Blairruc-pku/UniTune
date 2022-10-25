# -*- coding: utf-8 -*-
"""
desciption: system variables or other constant information
"""

import os
import requests
import argparse
import math

def parse_cmd_args():

    parser = argparse.ArgumentParser(description='Query Rewrite (Policy Tree Search)')

    # rewrite
    parser.add_argument('--rewrite_policy', type=str, default='mcts', help='[mcts, topdown, arbitrary, heuristic]')
    parser.add_argument('--driver', type=str, default= 'com.mysql.jdbc.Driver', help='Calcite adapter')
    #'com.mysql.jdbc.Driver', help='Calcite adapter')
    parser.add_argument('--sql', type=str, help='input query')
    parser.add_argument('--parallel_num', type=int, default=1, help='Parallel Node Number')

    # mcts
    parser.add_argument('--num_turns', action="store", type=int, default=1,
                        help="Number of turns to run")
    parser.add_argument('--num_sims', action="store", type=int, default=10,
                        help="Number of simulations to run")
    #parser.add_argument('--gamma', type=float, default=1/math.sqrt(2.0), help='Rate of explorations of uncovered rewrite orders')
    parser.add_argument('--gamma', type=float, default=0.1,
                        help='Rate of explorations of uncovered rewrite orders')

    args = parser.parse_args()
    #argus = vars(args)

    return args
