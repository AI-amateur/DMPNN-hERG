#!/bin/bash

### 1. D-MPNN+moe206 predict fda_drugs_set

check_fold='training_set_moe206_rand_check' 
test_path='fda_drugs_set_1uM.csv'
features_path='fda_drugs_set_moe206.csv'
preds_base='P_fda_moe206_rand'
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


### 2. D-MPNN+moe206 predict validation_set

check_fold='training_set_moe206_rand_check' 
test_path='validation_set.csv'
features_path='validation_set_moe206.csv'
preds_base='P_val_moe206_rand'

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

####  3. D-MPNN without feature  predict fda_drugs_set

check_fold='training_set_no_fp_rand_check' 
test_path='fda_drugs_set_1uM.csv'
preds_base='P_fda_no_fp'
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

####  4. D-MPNN without feature  predict validation_set

check_fold='training_set_no_fp_rand_check' 
test_path='validation_set.csv'
preds_base='P_val_no_fp'


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



 