#!/usr/bin/env python
import random
import math
import time
import os
import pdb
import json
import hashlib
import logging
import argparse
import sys
sys.path.append('../query_rewrite')


"""
A quick Monte Carlo Tree Search implementation.  For more details on MCTS see See http://pubs.doc.ic.ac.uk/survey-mcts-methods/survey-mcts-methods.pdf
The State is just a game where you have NUM_TURNS and at turn i you can make
a choice from [-2,2,3,-3]*i and this to to an accumulated value.  The goal is for the accumulated value to be as close to 0 as possible.
The game is not very interesting but it allows one to study MCTS which is.  Some features 
of the example by design are that moves do not commute and early mistakes are more costly.  
In particular there are two models of best child that one can use 
"""

# MCTS scalar.  Larger scalar will increase exploitation, smaller will increase exploration.
SCALAR=1/math.sqrt(2.0)

logging.basicConfig(level=logging.WARNING)
logger = logging.getLogger('MyLogger')


def record_eval(origin_sql, rewrite_sql, rewrite_sequence, estimate_cost):
	return
	key = origin_sql + str(rewrite_sequence)
	if os.path.exists("train.json"):
		f = open("train.json", 'r')
		train_dir = json.load(f)
		f.close()
	else:
		train_dir = {}
	train_dir[key] = {}
	train_dir[key]['origin_sql'] = origin_sql
	train_dir[key]['rewrite_sql'] = rewrite_sql
	train_dir[key]['rewrite_sequence'] = rewrite_sequence
	train_dir[key]['run_time'] = estimate_cost
	# train_dir[key]['type'] = self.origin_type
	try:
		with open("train.json", 'w') as fp:
			json.dump(train_dir, fp, indent=4)
	except:
		pdb.set_trace()

class Node():
	def __init__(self, sql, db, estimator, origin_cost, reward, origin_sql,  origin_type,rewriter, gamma, parent=None):
		self.visits = 1
		self.state = sql
		self.reward = reward#origin_cost - estimator.previous_cost_estimation(origin_sql, sql, []) # initialize with previous cost reduction
		self.estimator = estimator
		#print("previous reward: " + str(self.reward))
		self.rewriter = rewriter
		self.children=[]
		self.parent=parent
		self.rewrite_sequence = []
		self.node_num = 1

		# for multiple node selection
		self.non_computed = 1
		self.selected_nodes = []
		self.selected_nodes_utilities = []

		self.db = db
		self.origin_cost = origin_cost
		self.origin_sql = origin_sql
		self.origin_type = origin_type
		self.gamma = gamma
		self.selected = 0

	def add_child(self, csql, db, origin_cost, reward, rewriter, rule_id):
		child = Node(csql, db, self.estimator, origin_cost, reward, self.origin_sql, self.origin_type, rewriter, self.gamma, self)
		child.rewrite_sequence = self.rewrite_sequence + [rule_id]
		#print(child.rewrite_sequence)

		if self.children == None:
			self.children = []
		self.children.append(child)

	def update(self,reward):
		self.reward+=reward
		self.visits+=1
	def __repr__(self):
		s="Node; children: %s; visits: %d; reward: %f"%(self.children,self.visits,self.reward)
		return s

	def is_terminal(self):
		# self.sql cannot be rewritten by any rules
		if self.children != None and len(self.children) > 0:
			return False

		return True



	def	node_children(self):
		for i in range(len(self.rewriter.rulelist)):
			#
			#print("evaluate rule:{} {}".format(i, self.rewriter.rulelist[i]))
			is_rewritten, csql = self.rewriter.single_rewrite(self.state, i)
			if is_rewritten:
				#print("convert {} to {}".format(self.state, csql))
				estimate_cost = self.estimator.previous_cost_estimation_rf(self.state, csql, [i], record_rules=self.rewrite_sequence + [i])
				record_eval(self.origin_sql, csql, self.rewrite_sequence + [i], estimate_cost)
				record_eval(self.state, csql, self.rewrite_sequence + [i], estimate_cost)
				#print("use rule {}, cost: {}".format(self.rewriter.rulelist[i], estimate_cost))
			if is_rewritten == 1 and estimate_cost < self.origin_cost:
				#print("Add child!")
				self.add_child(csql, self.db, self.origin_cost,  self.origin_cost - estimate_cost,self.rewriter, i)

def UCTSEARCH(budget,root, parallel_num, estimator):

	root.selected = 1
	root.node_children()  # first expand root's children
	for c in root.children:
		c.parent = root

	for iter in range(int(budget)):
		#print("iter " + str(iter) + ".....\n")
		# if iter%20==19:
		# 	logger.info("simulation: %d"%iter)
		# 	logger.info(root)
		if parallel_num == 1 or parallel_num > root.node_num: # select single node
			# print("Parallel_num 1 ...\n")
			front = TREEPOLICY(root) # node selection
			front_list = [front]
		else:
			# print("Parallel_num 0 ...\n")
			from parallel_algorithm import parallel_node_selection
			front_list = parallel_node_selection(root,parallel_num)

		for front in front_list:
			front.selected = 1

			front.node_children()  # expansion
			for c in front.children:
				c.parent = front
			root.node_num = root.node_num + len(front.children)

			reward = DEFAULTPOLICY(front, estimator) # estimation (simplified as the future cost reduction by default rewrite order)
			#print("sub reward: " + str(reward))
			if reward > front.reward:
				BACKUP(front,reward) # backpropagation

	# return the node with maximal utility
	best_node = root
	while best_node.is_terminal() == False:
		bestchildren = [best_node.children[0]]
		bestscore = best_node.children[0].reward
		for c in best_node.children:
			#if c.reward == bestscore:  # utility
			#	bestchildren.append(c)
			if c.reward > bestscore:
				bestchildren = [c]
				bestscore = c.reward

		best_node = random.choice(bestchildren)

	return best_node

'''
	best_node = root
	while best_node.is_terminal() == False:
		bestchildren = [best_node.children[0]]
		bestscore = best_node.children[0].reward
		for c in best_node.children:
			if c.reward == bestscore:  # utility
				bestchildren.append(c)
			if c.reward > bestscore:
				bestchildren = [c]
				bestscore = c.reward
		random.choice(bestchildren)
'''

def TREEPOLICY(node):

	while node.is_terminal()==False:

		node=BESTCHILD(node) # highest utility

	return node

#current this uses the most vanilla MCTS formula it is worth experimenting with THRESHOLD ASCENT (TAGS)
def BESTCHILD(node):
	bestscore=node.children[0].reward
	bestchildren=[node.children[0]]
	for c in node.children:
		# utility function
		exploit=c.reward/c.visits
		explore=math.sqrt(2.0*math.log(node.visits)/float(c.visits))
		score=exploit+node.gamma*explore

		if score==bestscore: # utility
			bestchildren.append(c)
		if score>bestscore:
			bestchildren=[c]
			bestscore=score
	# if len(bestchildren)==0:
	# 	logger.warn("OOPS: no best child found, probably fatal")

	return random.choice(bestchildren)

def DEFAULTPOLICY(selected_node, estimator):
	# random sample from the selected node
	is_rewritten, sampled_sql = selected_node.rewriter.single_rewrite(selected_node.state, -1)

	if is_rewritten == 1:
		previous_selected_cost =  estimator.previous_cost_estimation_rf(selected_node.state, sampled_sql, [])
		record_eval(selected_node.state, sampled_sql, [], previous_selected_cost)
		return selected_node.origin_cost - previous_selected_cost
	else:
		return -1

def BACKUP(node,reward):
	while node!=None:
		node.visits+=1
		if reward > node.reward:
			node.reward = reward
		node=node.parent # verified