# coding:utf-8
from __future__ import print_function
from __future__ import division
from __future__ import unicode_literals

import argparse
#===============================================================
import os,sys,glob,re
import pandas as pd
import numpy as np
import math
from sklearn.metrics import roc_curve
from sklearn.metrics import matthews_corrcoef
#from sklearn.metrics import recall_score
#from sklearn.metrics import precision_score
from sklearn.metrics import auc, mean_absolute_error, mean_squared_error, precision_recall_curve, \
r2_score,roc_auc_score, accuracy_score, log_loss
from sklearn.metrics import confusion_matrix,cohen_kappa_score
from sklearn.metrics import f1_score,confusion_matrix

h1_list = ['pearson_r2','rmse','mse','mae','roc','prc','p-stat','Recall',
'Precision','f1','BA','accuracy', 'TN', 'FP', 'FN','TP','SP','SE','NPV','MCC']


def pd_read_file(a_file):    ## note the sep difference
	if a_file.endswith('.xlsx'):return pd.read_excel(a_file)
	if a_file.endswith('.csv'): return pd.read_csv(a_file)
	if a_file.endswith('.txt'):	return pd.read_csv(a_file,sep=' ')
	else:
		raise Exception('error in pd_read_file for filename : {}, must end in .xlsx, .csv or .txt'.format(a_file))

def df_to_file(df,o_file):    ## note the sep difference
	if o_file.endswith('.xlsx'):
		df.to_excel(o_file,index=False);return
	if o_file.endswith('.csv'):   ## can also be txt file
		df.to_csv(o_file,sep=',', index=False);return
	if o_file.endswith('.txt'):
		df.to_csv(o_file,sep=' ',index=False);return
	else:
		raise Exception('error in pd_read_file for filename : {}, must end in .xlsx, .csv or .txt'.format(o_file))

def polyfit(x, y, degree):
	#coeffs = numpy.polyfit(x, y, degree) # Polynomial Coefficients
	correlation = numpy.corrcoef(x, y)[0,1]
	return correlation**2

def calc_class_roc_prc(y_true,y_pred,pos_label=1):
	x_roc=roc_auc_score(y_true,y_pred)
	if pos_label==0:x_roc = 1 - x_roc		
	x_precision, x_recall, x_thresholds = precision_recall_curve(y_true,y_pred)
	x_prc = auc(x_recall, x_precision)
	return {'roc':x_roc,'prc':x_prc}

def calc_class_other_stats_with_threshold(y_true, y_pred, threshold=0.5):
	ind0=np.where(y_true==0)[0];ind1=np.where(y_true==1)[0]
	y_pred0=y_pred[ind0];y_pred1=y_pred[ind1];
	y_hard_pred = [1 if p > threshold else 0 for p in y_pred] # binary prediction
	#x_cohen_kappa = cohen_kappa_score(y_true, y_pred, weights='linear')	
	x_cohen_kappa = cohen_kappa_score(y_true, y_hard_pred, weights='linear')
	## True and false values
	TN, FP, FN, TP = confusion_matrix(y_true, y_hard_pred).ravel()	
	#TP = sum((y_true == 1) & (y_hard_pred == 1))
	#TN = sum((y_true == 0) & (y_hard_pred == 0))
	#FN = sum((y_true == 1) & (y_hard_pred == 0))
	#FP = sum((y_true == 0) & (y_hard_pred == 1))
	# SE (Sensitivity), hit rate, recall, or true positive rate
	x_Recall = TP/(TP+FN)
	SE=x_Recall
	# Precision or positive predictive value
	x_Precision = TP/(TP+FP)
	#f1_score = (2*x_Precision*x_Recall)/ (x_Precision + x_Recall)
	f1 = f1_score(y_true, y_hard_pred)
	# CCR (Correct classification rate), BA (balanced accuracy)
	# Specificity or true negative rate
	SP = TN/(TN+FP) 
	x_BA = (SE + SP)/2
	x_accuracy = accuracy_score(y_true, y_hard_pred)
	# Negative predictive value
	NPV = TN/(TN+FN)
	x_MCC = matthews_corrcoef(y_true, y_hard_pred)
	other_stats = {'Recall':x_Recall,'Precision':x_Precision, 'f1':f1,'BA':x_BA,
	'accuracy':x_accuracy, 'TN':TN, 'FP':FP, 'FN':FN,'TP':TP,'SP':SP,'SE':SE,
	'NPV':NPV,'MCC':x_MCC,'cohen_kappa':x_cohen_kappa}  # 
	return other_stats

def parse_range(x_cols,max_colnum):	# e.g. 2,3,5-9;	 2-	; -9
	# 1st, split those comma
	x_cols = x_cols.replace(';','')
	tmp_list = x_cols.split(',')
	# 2nd, parse those dash
	cols = []
	for tmp in tmp_list:
		if '-' not in tmp: cols.append(int(tmp));continue
		if tmp.startswith('-'):cols.extend(list(range(0,int(tmp[1:])+1)))
		elif tmp.endswith('-'):cols.extend(list(range(int(tmp[:-1]),max_colnum)))
		else:b,e = tmp.split('-');cols.extend(list(range(int(b),int(e)+1)))
	print('cols = ', cols)
	return cols

def list_stat_for_class(t_df,p_df,cols,pos_label):
	prs = [];rocs = []	
	for i,xx_col in enumerate(cols):
		label_col = t_df.columns[int(xx_col)] 
		value_col = p_df.columns[int(xx_col)] 
		print('xx_col, label_col, value_col = ',xx_col, label_col, value_col)
		#t_values = t_df[label_col].values
		t_values = t_df[label_col].values.astype(int)
		p_values = p_df[value_col].values
		ind = np.where((t_values==0) | (t_values==1))[0]	 ### to remove those NaN label
		#print('ind = ',ind)
		y_true = t_values[ind]
		y_pred = p_values[ind]
		dic = {}
		dic.update(calc_class_roc_prc(y_true,y_pred,pos_label))
		dic.update(calc_class_other_stats_with_threshold(y_true, y_pred,threshold))
		header=list(dic.keys()); #header=sorted(header)
		tmp = [x for x in h1_list if x in header] + [x for x in header if x not in h1_list]
		header = tmp
		print('header=',header)
		f = open(eva_csv_name, 'a');f.write('col_names,' + ','.join(header)+'\n')			
		w_line=label_col+'_'+ value_col +',' + ','.join([str(dic[x]) for x in header])+'\n'
		f.write(w_line)
	f.close()
	return 


def main():
	parser = argparse.ArgumentParser(
			description='evaluate performance for classification models')			
	parser.add_argument('-t',dest='true_file', type=str, default='', help="true file with true")
	parser.add_argument('-p',dest='pred_file', type=str, default='', help="pred file. ")
	parser.add_argument('-c','--cols', type=str, default='',help="e.g. 2-	; e.g.2	2,3,5-9; ")
	parser.add_argument('-thre',dest='threshold', type=float, default=0.5,
		help='binary class thershold')
	parser.add_argument('-roc_pos',dest='roc_pos_label', type=int, default=1,
		help='choice 0 or 1(for ML,default)')
	parser.add_argument('-roc_colors',dest='roc_colors', nargs='*', default=[],
		help='use show_colors see choice list')

	args = parser.parse_args()
	true_file = args.true_file; pred_file = args.pred_file; 
	cols = args.cols;roc_colors=args.roc_colors	
	global pos_label,eva_csv_name,threshold
	pos_label = args.roc_pos_label
	eva_csv_name = 'eva_{}_{}.csv'.format(true_file.split('.')[0],pred_file.split('.')[0])
	threshold = args.threshold

	t_df = pd_read_file(true_file);p_df = pd_read_file(pred_file)
	t_columns_num=len(t_df.columns);p_columns_num=len(p_df.columns)
	if t_columns_num != p_columns_num: raise IOError('the col num of two files are not same')
	max_colnum = t_columns_num
	cols = parse_range(cols,max_colnum)
	list_stat_for_class(t_df,p_df,cols,pos_label)	
	return

if __name__=='__main__':
	main()
