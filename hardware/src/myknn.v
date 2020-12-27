`timescale 1ns/1ps
`include "iob_lib.vh"

module myknn_core
  #(
    parameter DATA_W = 32
    	      LABEL=8,
			  N_Neighbour=10
    )
   (
    `INPUT(A, `DATA_W),    
    `INPUT(B, `DATA_W),
    `INPUT(label, `LABEL),
    `OUTPUT(Neighbour_info_out, `LABEL*`N_Neighbour),
    `INPUT(clk, 1),
    `INPUT(rst, 1),
    `INPUT(valid, 1),
    `INPUT(start, 1)
    );

    `SIGNAL_SIGNED(Ax, `DATA_W/2)
    `SIGNAL_SIGNED(Bx, `DATA_W/2)
    `SIGNAL_SIGNED(Ay, `DATA_W/2)
    `SIGNAL_SIGNED(By, `DATA_W/2)  
    `SIGNAL_SIGNED(X_DIFF, `DATA_W/2)
    `SIGNAL_SIGNED(Y_DIFF, `DATA_W/2)
    `SIGNAL_SIGNED(X_SQR, `DATA_W)
    `SIGNAL_SIGNED(Y_SQR, `DATA_W)
    `SIGNAL(DIST_VALUE, `DATA_W)  
     
    `SIGNAL_OUT(DIST_OUT, `DATA_W)
    
    `COMB begin
    Ax=A[31:16];
    Bx=B[31:16];
    Ay=A[15:0];
    By=B[15:0];
    X_DIFF = Ax - Bx;
    X_SQR = X_DIFF * X_DIFF;
    Y_DIFF = Ay - By;
    Y_SQR = Y_DIFF * Y_DIFF;
    DIST_VALUE = X_SQR + Y_SQR;

    end
    
    `SIGNAL2OUT(DIST_OUT, DIST_VALUE)
    
     `SIGNAL(write_previous, 1)
    `SIGNAL(write_L, N_Neighbour)
    `SIGNAL(Neighbour_info, (DATA_W+LABEL)*N_Neighbour)
    `SIGNAL(Neighbour_info_LABEL, LABEL*N_Neighbour)  
    
    `SIGNAL(Reg_in, 40)
    
    `SIGNAL2OUT(Neighbour_info_out, Neighbour_info_LABEL)
    
    assign Neighbour_info_LABEL = {Neighbour_info[367:360], Neighbour_info[327:320], Neighbour_info[287:280], Neighbour_info[247:240], Neighbour_info[207:200],
    Neighbour_info[167:160], Neighbour_info[127:120], Neighbour_info[87:80], Neighbour_info[47:40], Neighbour_info[7:0]};

    `COMB begin

    if(write_previous || (DIST_OUT < Neighbour_info[DATA_W+LABEL-1:LABEL])) write_L[0] = 1'b1;
    else write_L[0] = 1'b0;

    if(write_previous == 1) Reg_in = Neighbour_info[(DATA_W+LABEL)-1:0];
    else Reg_in = {DIST_OUT, label};

    end

    `REG_ARE(clk, rst, '1, valid & start & write_L[0], Neighbour_info[DATA_W+LABEL-1:0], Reg_in)

    genvar i;

    for(i = 1; i < N_Neighbour; i = i + 1) begin
      `COMB begin

        if(write_L[i-1] || (DIST_OUT < Neighbour_info[(DATA_W+LABEL)*(i+1)-1:(LABEL)*i])) write_L[i] = 1'b1;
        else write_L[i] = 1'b0;

        if(write_L[i-1] == 1) Reg_in = Neighbour_info[(DATA_W+LABEL)*i-1:(DATA_W+LABEL)*(i-1)];
        else Reg_in = {DIST_OUT, label};

      end

      `REG_ARE(clk, rst, '1, valid & start & write_L[i], Neighbour_info[(DATA_W+LABEL)*(i+1)-1:(DATA_W+LABEL)*i], Reg_in)
    end

    assign write_previous = 1'b0;
         
    
endmodule




