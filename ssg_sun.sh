DATASET_PATH=/data/kabir/similarity-search/dataset
SIFT_PATH=$DATASET_PATH/sun
INDEX_PATH=/data/kabir/similarity-search/models/SSG/indexes
LOG_PATH=/data/kabir/similarity-search/models/SSG/logs

cd /data/kabir/similarity-search/models/efanna_graph/tests/

./test_nndescent $SIFT_PATH/base.fvecs $INDEX_PATH/sun_100nn.knng 20 20 12 10 100 > $LOG_PATH/efannlogsun1.txt

cd /data/kabir/similarity-search/models/SSG/

./build/tests/test_ssg_index $SIFT_PATH/base.fvecs $INDEX_PATH/sun_100nn.knng 20 50 60 $INDEX_PATH/sun.ssg > $LOG_PATH/ssgbuildlogsun1.txt

./build/tests/test_ssg_optimized_search $SIFT_PATH/base.fvecs $SIFT_PATH/query.fvecs $INDEX_PATH/sun.ssg 100 20 ssgsearchqueryresultsun1-1.txt 13 $SIFT_PATH/groundtruth.ivecs > $LOG_PATH/ssgsearchlogsun1-1.txt