#include "interconnect.h"
#include "iob_knn.h"
#include "KNNsw_reg.h"

//base address
static int base;

void knn_reset(){
  IO_SET(base, KNN_RESET, 1);
  IO_SET(base, KNN_RESET, 0);
}

void knn_start(){
  IO_SET(base, KNN_ENABLE, 1);
}

void knn_stop(){
  IO_SET(base, KNN_ENABLE, 0);
}

void knn_init(int base_address){
  base = base_address;
  knn_reset();
}

void knn_set_TestP(unsigned int coordinate, unsigned int offset){
  unsigned int actualADDR = KNN_A0 + offset;
  IO_SET(base, actualADDR, coordinate);
}

void knn_set_DataP(unsigned int coordinate, char label){
  IO_SET(base, KNN_LABEL, label);
  IO_SET(base, KNN_B, coordinate);
}

unsigned char knn_read_Label(unsigned int offset, unsigned int point, unsigned int N_neighbour){
  int actualADDR = KNN_INFO0 + offset + N_neighbour*point;
  return IO_GET(base, actualADDR);
}
