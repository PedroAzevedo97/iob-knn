`define KNN_ADDR_W 11  //address width
`define KNN_WDATA_W 32 //write data width
`ifndef DATA_W
 `define DATA_W 32      //cpu data width
`endif
`ifndef LABEL
 `define LABEL 8
`endif
`ifndef N_Neighbour
 `define N_Neighbour 10
`endif
`ifndef LABEL_W
 `define LABEL_W 8      // Tamanho dos rotulos em bits
`endif
`ifndef NT_points
 `define NT_points 45
