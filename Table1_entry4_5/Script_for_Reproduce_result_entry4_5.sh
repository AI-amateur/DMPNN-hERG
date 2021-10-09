#!/bin/bash

### 1. D-MPNN+moe206 predict I_test dataset

check_fold='I_train_moe206_rand' 
test_path='I_test.csv'
features_path='I_test_moe206.csv'
preds_base='P_I_test_moe206'
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

######=====================================================================================================

####  2. D-MPNN without feature  I_test dataset

check_fold='I_train_rand' 
test_path='I_test.csv'
preds_base='P_I_test_noFP'

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


######=====================================================================================================

### 3. D-MPNN+moe206 predict II_test dataset

check_fold='II_train_moe206_rand' 
test_path='II_test.csv'
features_path='II_test_moe206.csv'
preds_base='P_II_test_moe206'

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


######=====================================================================================================

######=====================================================================================================

####  4. D-MPNN without feature  II_test dataset

check_fold='II_train_rand' 
test_path='II_test.csv'
preds_base='P_II_test_noFP'

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



 