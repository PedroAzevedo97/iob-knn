`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"
`include "iob_knn.vh"

module iob_knn
  #(
    parameter ADDR_W = `KNN_ADDR_W, //NODOC Address width
    parameter DATA_W = `DATA_W, //NODOC Data word width
    parameter LABEL = `LABEL,
    parameter N_Neighbour = `N_Neighbour,
    parameter NT_points = `NT_points,
    parameter WDATA_W = `KNN_WDATA_W //NODOC Data word width on writes
    )
   (
`include "cpu_nat_s_if.v"
`include "gen_if.v"
    );

//BLOCK Register File & Configuration, control and status registers accessible by the sofware
`include "KNNsw_reg.v"
`include "KNNsw_reg_gen.v"

    //combined hard/soft reset
   `SIGNAL(rst_int, 1)
   `COMB rst_int = rst | KNN_RESET;

   //write signal
   `SIGNAL(write, 1)
   `COMB write = | wstrb;


   //
   //BLOCK 64-bit time counter & Free-running 64-bit counter with enable and soft reset capabilities
   // Isto é o commit do Afonso durante as major changes
   `SIGNAL_OUT(KNN_VALUE, 2*DATA_W)
   reg [2*DATA_W-1:0]  distances[99:0];
   //`SIGNAL(distances, 2*DATA_W) [99:0]
   reg [2*DATA_W-1:0]  bubble;

   integer i, j;

   initial begin
      $dumpfile("knn.vcd");
      $dumpvars();
      //en=0;

      //GERAR PONTOS E CALCULAR DISTANCIAS
      for (i=0; i<100; i=i+1) begin
         @(posedge clk) #1
         //en=1;
         x1={$random}%1000;
         x2={$random}%1000;
         y1={$random}%1000;
         y2={$random}%1000;
         #1
         distances[i]=KNN_VALUE;
      end


      //ORDENAR DISTANCIAS


      @(posedge clk) #100 $finish;

   end

   knn_core knn0
     (
      .KNN_ENABLE(KNN_ENABLE),
      .DATA_POINT(KNN_DATASET),
      .TEST_POINT(KNN_TEST_POINT),
      .clk(clk),
      .rst(rst_int),
      .x1(x1),
      .x2(x2),
      .y1(y1),
      .y2(y2)
      );

   `SIGNAL(INFO_OUT, `N_Neighbour*`LABEL*`NT_points)
   `SIGNAL_OUT(valid_control, 1)

   genvar i;
   genvar j;

   generate
     for (i = 0; i < `NT_points; i = i+1) begin
      for (j = 0; j < `N_Neighbour; j = j + 1) begin
        assign KNN_INFO[j+i*`N_Neighbour] = INFO_OUT[(j+1)*`LABEL+i*`N_Neighbour*`LABEL-1:j*`LABEL+i*`N_Neighbour*`LABEL];
      end
     end
   endgenerate

   generate
    for(i = 0; i < `NT_points; i = i+1) begin
     knn_core knn
       (
        .A(KNN_A[i]),
        .B(KNN_B),
        .label(KNN_LABEL),
        .Neighbour_info_out(INFO_OUT[(i+1)*`LABEL*`N_Neighbour-1:i*`LABEL*`N_Neighbour]),
        .clk(clk),
        .rst(rst_int),
        .valid(valid_control),
        .start(KNN_ENABLE)
        );
      end
    endgenerate

    control FSM
       (
        .Data_Loaded(valid_control),
        .valid(valid),
        .clk(clk),
        .enable(KNN_ENABLE),
        .rst(rst),
        .wstrb(write)
       );


   //ready signal
   `SIGNAL(ready_int, 1)
   `REG_AR(clk, rst, 0, ready_int, valid)

   `SIGNAL2OUT(ready, ready_int)

   //rdata signal
   //`COMB begin
   //end

endmodule
