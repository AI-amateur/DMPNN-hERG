#!/bin/bash


### 1. D-MPNN+moe206

check_fold='train_moe206_rand'
test_path='test_108VS147.csv'
features_path='test_108VS147_moe206.csv'
preds_base='P_test_108VS147_moe206'
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

check_fold='train_noFP_rand'
test_path='test_108VS147.csv'
preds_base='P_test_108VS147_noFP'
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



 