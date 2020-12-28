`define KNN_ADDR_W 16  //address width
`define KNN_WDATA_W 32 //write data width
`ifndef DATA_W
 `define DATA_W 32      //cpu data width
`endif
`ifndef DATASET_SIZE
 `define DATASET_SIZE 100      //Dataset number (abitrario) - numero total de pontos
`endif
`ifndef NEIGHBOUR_NR				//Neighbor number
 `define NEIGHBOUR_NR 20      // Numero de pontos na vizinhanca
`endif
`ifndef LABEL_W			
 `define LABEL_W 8      // Tamanho dos rotulos em bits
`endif



