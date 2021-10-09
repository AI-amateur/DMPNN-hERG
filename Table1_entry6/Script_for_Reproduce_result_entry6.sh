#!/bin/bash

## 0. uncompress two files:

unzip test87366_moe206.csv.zip
## this will give  the orginal the  test87366_moe206.csv

zip -F train203853_moe206.csv.zip --out single-archive.zip
unzip single-archive.zip
## this will give the orginal the train203853_moe206.csv



### 1. D-MPNN+moe206

check_fold='Ogura_train_moe206'
test_path='test87366.csv'
features_path='test87366_moe206.csv'
preds_base='P_test87366_moe206'
## =============================

## pred
chemprop_pred='python ../chemprop/predict.py'
for i in {0..4};do
  echo $i
  echo $chemprop_pred --checkpoint_path ${check_fold}/fold_${i}/model_0/model.pt --test_path $test_path \
--features_path $features_path --preds_path ${preds_base}${i}.csv
  $chemprop_pred --checkpoint_path ${check_fold}/fold_${i}/model_0/model.pt --test_path $test_path \
--features_path $features_path --preds_path ${preds_base}${i}.csv
  done

## eva
calc_metric='python ../calc_metric.py'
for i in {0..4};do
  echo $i
  echo $calc_metric -t ${test_path} -p ${preds_base}${i}.csv -c 1
  $calc_metric -t ${test_path} -p ${preds_base}${i}.csv -c 1
  done

## cat
test_base=`basename $test_path .csv`
cat eva_${test_base}_${preds_base}*.csv >eva_folds_${test_base}_${preds_base}.csv

## ========================================================================

####  2. D-MPNN without feature

check_fold='Ogura_train_noFP'
test_path='test87366.csv'
preds_base='P_test87366_noFP'
## =====================================

## pred
chemprop_pred='python ../chemprop/predict.py'
for i in {0..4};do
  echo $i
  echo $chemprop_pred --checkpoint_path ${check_fold}/fold_${i}/model_0/model.pt --test_path $test_path \
--preds_path ${preds_base}${i}.csv
  $chemprop_pred --checkpoint_path ${check_fold}/fold_${i}/model_0/model.pt --test_path $test_path \
--preds_path ${preds_base}${i}.csv
  done

## eva
calc_metric='python ../calc_metric.py'
for i in {0..4};do
  echo $i
  echo $calc_metric -t ${test_path} -p ${preds_base}${i}.csv -c 1
  $calc_metric -t ${test_path} -p ${preds_base}${i}.csv -c 1
  done

## cat
test_base=`basename $test_path .csv`
cat eva_${test_base}_${preds_base}*.csv >eva_folds_${test_base}_${preds_base}.csv



 