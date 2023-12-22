//
// Created by 付聪 on 2017/6/21.
//

#include <chrono>

#include "index_random.h"
#include "index_ssg.h"
#include "util.h"
#include<bits/stdc++.h>
using namespace std;

void save_result(char* filename, std::vector<std::vector<unsigned> >& results) {
  std::ofstream out(filename, std::ios::binary | std::ios::out);

  for (unsigned i = 0; i < results.size(); i++) {
    unsigned GK = (unsigned)results[i].size();
    out.write((char*)&GK, sizeof(unsigned));
    out.write((char*)results[i].data(), GK * sizeof(unsigned));
  }
  out.close();
}

double getRecallAtR(std::vector<std::vector<unsigned> > res, const std::vector<std::vector<int>> &topnn, const int K) {
  int nq = res.size();
  double ans = 0.0;
  for (int p_idx=0; p_idx<nq; p_idx++) {
    for (int k_idx=0; k_idx<K; k_idx++) {
      if (topnn[p_idx][k_idx] == res[p_idx][k_idx]) {
        ans += 1;
        break;
      }
    }
  }
  ans /= nq;
  return ans;
}

std::vector<std::vector<int>> readIVecsFromExternal(std::string filepath, int N) {
  FILE *infile = fopen(filepath.c_str(), "rb");
  std::vector<std::vector<int>> dataset;
  if (infile == NULL) {
    std::cout << "File not found" << std::endl;
    return dataset;
  }
  
  int dimen;
  while (true) {
    if (fread(&dimen, sizeof(int), 1, infile) == 0) {
      break;
    }
    if (dimen != N) {
      std::cout << "N and actual dimension mismatch" << std::endl;
      return dataset;
    }
    std::vector<int> v(dimen);
    if (fread(v.data(), sizeof(int), dimen, infile) == 0) {
      std::cout << "error when reading" << std::endl;
    };
    
    dataset.push_back(v);
  }

  if (fclose(infile)) {
    std::cout << "Could not close data file" << std::endl;
  }
  return dataset;
}

int main(int argc, char** argv) {
  if (argc < 7) {
    std::cout << "./run data_file query_file ssg_path L K result_path [seed]"
              << std::endl;
    exit(-1);
  }

  if (argc == 8) {
    unsigned seed = (unsigned)atoi(argv[7]);
    srand(seed);
    std::cerr << "Using Seed " << seed << std::endl;
  }

  std::cerr << "Data Path: " << argv[1] << std::endl;

  unsigned points_num, dim;
  float* data_load = nullptr;
  data_load = efanna2e::load_data(argv[1], points_num, dim);
  data_load = efanna2e::data_align(data_load, points_num, dim);

  std::cerr << "Query Path: " << argv[2] << std::endl;

  unsigned query_num, query_dim;
  float* query_load = nullptr;
  query_load = efanna2e::load_data(argv[2], query_num, query_dim);
  query_load = efanna2e::data_align(query_load, query_num, query_dim);

  assert(dim == query_dim);

  efanna2e::IndexRandom init_index(dim, points_num);
  efanna2e::IndexSSG index(dim, points_num, efanna2e::FAST_L2,
                           (efanna2e::Index*)(&init_index));

  std::cerr << "SSG Path: " << argv[3] << std::endl;
  std::cerr << "Result Path: " << argv[6] << std::endl;

  index.Load(argv[3]);
  index.OptimizeGraph(data_load);

  unsigned L = (unsigned)atoi(argv[4]);
  unsigned K = (unsigned)atoi(argv[5]);

  std::cerr << "L = " << L << ", ";
  std::cerr << "K = " << K << std::endl;

  efanna2e::Parameters paras;
  paras.Set<unsigned>("L_search", L);

  std::vector<std::vector<unsigned> > res(query_num);
  for (unsigned i = 0; i < query_num; i++) res[i].resize(K);

  // Warm up
  for (int loop = 0; loop < 3; ++loop) {
    for (unsigned i = 0; i < 10; ++i) {
      index.SearchWithOptGraph(query_load + i * dim, K, paras, res[i].data());
    }
  }

  auto s = std::chrono::high_resolution_clock::now();
  for (unsigned i = 0; i < query_num; i++) {
    index.SearchWithOptGraph(query_load + i * dim, K, paras, res[i].data());
  }
  auto e = std::chrono::high_resolution_clock::now();

  std::chrono::duration<double> diff = e - s;
  std::cerr << "Search Time: " << diff.count() << std::endl;

  vector<std::vector<int>> gt = readIVecsFromExternal(argv[8], 100);
  std::cerr << "Recall: " << getRecallAtR(res, gt, K) << std::endl;

  save_result(argv[6], res);

  return 0;
}
