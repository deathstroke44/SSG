DATASET_PATH=/data/kabir/similarity-search/dataset
SIFT_PATH=$DATASET_PATH/MNIST
INDEX_PATH=/data/kabir/similarity-search/models/SSG/indexes
LOG_PATH=/data/kabir/similarity-search/models/SSG/logs

cd /data/kabir/similarity-search/models/efanna_graph/tests/

taskset --cpu-list 66-66 ./test_nndescent $SIFT_PATH/base.fvecs $INDEX_PATH/MNIST_100nn.knng 20 20 12 10 100 > $LOG_PATH/efannlogMNIST1.txt

cd /data/kabir/similarity-search/models/SSG/

taskset --cpu-list 66-66 ./build/tests/test_ssg_index $SIFT_PATH/base.fvecs $INDEX_PATH/MNIST_100nn.knng 20 50 60 $INDEX_PATH/MNIST.ssg > $LOG_PATH/ssgbuildlogMNIST1.txt

taskset --cpu-list 66-66 ./build/tests/test_ssg_optimized_search $SIFT_PATH/base.fvecs $SIFT_PATH/query.fvecs $INDEX_PATH/MNIST.ssg 100 20 ssgsearchqueryresultMNIST1-1.txt 13 $SIFT_PATH/groundtruth.ivecs > $LOG_PATH/ssgsearchlogMNIST1-1.txt