DATASET_PATH=/data/kabir/similarity-search/dataset
DATASET_NAME=movielens
ID=6
DATA_PATH=$DATASET_PATH/${DATASET_NAME}
BASE_PATH=$DATA_PATH/base.fvecs
QUERY_PATH=$DATA_PATH/query.fvecs
GROUNDTRUTH_PATH=$DATA_PATH/groundtruth.ivecs
INDEX_PATH=/data/kabir/similarity-search/models/SSG/indexes
LOG_PATH=/data/kabir/similarity-search/models/SSG/logs
EFANNA_LOG=$LOG_PATH/efannlog${DATASET_NAME}${ID}.txt
SSG_LOG=$LOG_PATH/ssgbuildlog${DATASET_NAME}${ID}.txt
EFANNA_GRAPH=$INDEX_PATH/${DATASET_NAME}${ID}_100nn.knng
SSG_GRAPH=$INDEX_PATH/${DATASET_NAME}${ID}.ssg

# **K** is the 'K' of kNN graph.
# **L** is the parameter controlling the graph quality, larger is more accurate but slower, no smaller than K.
# **iter** is the parameter controlling the iteration times, iter usually < 30.
# **S** is the parameter contollling the graph quality, larger is more accurate but slower.
# **R** is the parameter controlling the graph quality, larger is more accurate but slower.

cd /data/kabir/similarity-search/models/efanna_graph/tests/

./test_nndescent $BASE_PATH $EFANNA_GRAPH 25 30 12 10 50 > $EFANNA_LOG

# L controls the quality of the NSG, the larger the better, L > R.
# R controls the index size of the graph, the best R is related to the intrinsic dimension of the dataset.
# Angle controls the angle between two edges.

cd /data/kabir/similarity-search/models/SSG/
./build/tests/test_ssg_index $BASE_PATH $EFANNA_GRAPH 25 15 60 $SSG_GRAPH > $SSG_LOG

SUB_ID=1
SEARCH_LOG=$LOG_PATH/ssgsearchlog${DATASET_NAME}${ID}-${SUB_ID}.txt
SEARCH_RESULT_LOG=ssgsearchqueryresult${DATASET_NAME}${ID}-${SUB_ID}.txt

SEARCH_L=100
SEARCH_K=100

./build/tests/test_ssg_optimized_search $BASE_PATH $QUERY_PATH $SSG_GRAPH $SEARCH_L $SEARCH_K $SEARCH_RESULT_LOG 13 $GROUNDTRUTH_PATH > $SEARCH_LOG

SUB_ID=2
SEARCH_LOG=$LOG_PATH/ssgsearchlog${DATASET_NAME}${ID}-${SUB_ID}.txt
SEARCH_RESULT_LOG=ssgsearchqueryresult${DATASET_NAME}${ID}-${SUB_ID}.txt

SEARCH_L=120
SEARCH_K=100

./build/tests/test_ssg_optimized_search $BASE_PATH $QUERY_PATH $SSG_GRAPH $SEARCH_L $SEARCH_K $SEARCH_RESULT_LOG 13 $GROUNDTRUTH_PATH > $SEARCH_LOG

SUB_ID=3
SEARCH_LOG=$LOG_PATH/ssgsearchlog${DATASET_NAME}${ID}-${SUB_ID}.txt
SEARCH_RESULT_LOG=ssgsearchqueryresult${DATASET_NAME}${ID}-${SUB_ID}.txt

SEARCH_L=140
SEARCH_K=100

./build/tests/test_ssg_optimized_search $BASE_PATH $QUERY_PATH $SSG_GRAPH $SEARCH_L $SEARCH_K $SEARCH_RESULT_LOG 13 $GROUNDTRUTH_PATH > $SEARCH_LOG

