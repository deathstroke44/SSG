DATASET_PATH=/data/kabir/similarity-search/dataset
SIFT_PATH=$DATASET_PATH/gist
INDEX_PATH=/data/kabir/similarity-search/models/SSG/indexes
LOG_PATH=/data/kabir/similarity-search/models/SSG/logs

cd /data/kabir/similarity-search/models/efanna_graph/tests/

./test_nndescent $SIFT_PATH/gist_base.fvecs $INDEX_PATH/gist_100nn.knng 100 100 12 10 100 > $LOG_PATH/efannloggist1.txt

cd /data/kabir/similarity-search/models/SSG/

./build/tests/test_ssg_index $SIFT_PATH/gist_base.fvecs $INDEX_PATH/gist_100nn.knng 100 50 60 $INDEX_PATH/gist.ssg > $LOG_PATH/ssgbuildloggist1.txt

./build/tests/test_ssg_optimized_search $SIFT_PATH/gist_base.fvecs $SIFT_PATH/gist_query.fvecs $INDEX_PATH/gist.ssg 200 100 ssgsearchqueryresultgist1-1.txt 13 $SIFT_PATH/gist_groundtruth.ivecs > $LOG_PATH/ssgsearchloggist1-1.txt