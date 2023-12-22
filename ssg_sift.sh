DATASET_PATH=/data/kabir/similarity-search/dataset
SIFT_PATH=$DATASET_PATH/sift
INDEX_PATH=/data/kabir/similarity-search/models/SSG/indexes
LOG_PATH=/data/kabir/similarity-search/models/SSG/logs

cd /data/kabir/similarity-search/models/efanna_graph/tests/
taskset --cpu-list 62-62 ./test_nndescent $SIFT_PATH/sift_base.fvecs $INDEX_PATH/sift_100nn.knng 100 100 12 10 100 > $LOG_PATH/efannlogsift1.txt
cd /data/kabir/similarity-search/models/SSG/
taskset --cpu-list 62-62 ./build/tests/test_ssg_index $SIFT_PATH/sift_base.fvecs $INDEX_PATH/sift_100nn.knng 100 50 60 $INDEX_PATH/sift.ssg > $LOG_PATH/ssgbuildlogsift1.txt

taskset --cpu-list 62-62 ./build/tests/test_ssg_optimized_search $SIFT_PATH/sift_base.fvecs $SIFT_PATH/sift_query.fvecs $INDEX_PATH/sift.ssg 200 100 ssgsearchqueryresultsift1-1.txt 13 $SIFT_PATH/sift_groundtruth.ivecs > $LOG_PATH/ssgsearchlogsift1-1.txt
