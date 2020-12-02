`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"
`include "iob_knn.vh"

module iob_knn 
  #(
    parameter ADDR_W = `KNN_ADDR_W, //NODOC Address width
    parameter DATA_W = `DATA_W, //NODOC Data word width
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
   
   `SIGNAL(x1, DATA_W) //internal y
   `SIGNAL(x2, DATA_W) //internal y
   `SIGNAL(y1, DATA_W) //internal y
   `SIGNAL(y2, DATA_W) //internal y

   //
   //BLOCK 64-bit time counter & Free-running 64-bit counter with enable and soft reset capabilities
   //
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
         $display("Coordenates x1: %d  x2: %d  y1: %d  y2: %d Distance %d",x1, x2, y1, y2, KNN_VALUE);
      end
      
      
      //ORDENAR DISTANCIAS
      for (i=0; i<99; i=i+1) begin 
        for(j=0; j<99-i; j=j+1) begin
          if(distances[j]>distances[j+1]) begin
            bubble=distances[j];
            distances[j]=distances[j+1];
            distances[j+1]=bubble;
          end
        end
      end
      
          
      for (i=0; i<100; i=i+1)
        $display("Distance %d: %d", i+1, distances[i]);
        

      @(posedge clk) #100 $finish;

   end 
   
   knn_core knn0
     (
      .KNN_ENABLE(KNN_ENABLE),
      .clk(clk),
      .rst(rst_int),
      .x1(x1),
      .x2(x2),
      .y1(y1),
      .y2(y2),
      .z(KNN_VALUE)
      );
   
   
   //ready signal   
   `SIGNAL(ready_int, 1)
   `REG_AR(clk, rst, 0, ready_int, valid)

   `SIGNAL2OUT(ready, ready_int)

   //rdata signal
   //`COMB begin
   //end
   
      
endmodule



