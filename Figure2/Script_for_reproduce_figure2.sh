
## this is an examples for training DMPNN on Cai_TableS3_fixed.csv dataset with moe206 descriptor, and this is containing five fold cross validation process. 

python ../chemprop/train.py --gpu 0 --data_path Cai_TableS3_fixed.csv --dataset_type classification --save_dir S3_moe206_rand_check_test --epochs 50 \
--split_type random --features_path Cai_TableS3_moe206.csv --num_folds 5 --quiet

## result can be check in the quiet.log file