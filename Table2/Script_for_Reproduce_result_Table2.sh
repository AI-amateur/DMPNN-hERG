#!/bin/bash

### 1. D-MPNN+moe206  predict external_test_set_pos.csv

check_fold='model'
test_path='external_test_set_pos.csv'
features_path='external_test_set_pos_moe206.csv'
preds_base='P_pos_moe206'
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


#### =================================================================================================================

### 2. D-MPNN+moe206  predict external_test_set_pos.csv

check_fold='model'
test_path='external_test_set_neg.csv'
features_path='external_test_set_neg_moe206.csv'
preds_base='P_neg_moe206'

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

#### =================================================================================================================


### 3. D-MPNN+moe206  predict external_test_set_pos.csv

check_fold='model'
test_path='external_test_set_new.csv'
features_path='external_test_set_new_moe206.csv'
preds_base='P_new_moe206'
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




 