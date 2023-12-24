DATASET_PATH=/data/kabir/similarity-search/dataset
SIFT_PATH=$DATASET_PATH/enron
INDEX_PATH=/data/kabir/similarity-search/models/SSG/indexes
LOG_PATH=/data/kabir/similarity-search/models/SSG/logs

cd /data/kabir/similarity-search/models/efanna_graph/tests/

taskset --cpu-list 64-64 ./test_nndescent $SIFT_PATH/base.fvecs $INDEX_PATH/enron_100nn.knng 100 100 12 10 100 > $LOG_PATH/efannlogenron1.txt

cd /data/kabir/similarity-search/models/SSG/

taskset --cpu-list 64-64 ./build/tests/test_ssg_index $SIFT_PATH/base.fvecs $INDEX_PATH/enron_100nn.knng 100 50 60 $INDEX_PATH/enron.ssg > $LOG_PATH/ssgbuildlogenron1.txt

taskset --cpu-list 64-64 ./build/tests/test_ssg_optimized_search $SIFT_PATH/base.fvecs $SIFT_PATH/query.fvecs $INDEX_PATH/enron.ssg 100 20 ssgsearchqueryresultenron1-1.txt 13 $SIFT_PATH/groundtruth.ivecs > $LOG_PATH/ssgsearchlogenron1-1.txt