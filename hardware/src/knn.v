`timescale 1ns/1ps
`include "iob_lib.vh"

module knn_core
  #(
    parameter DATA_W = 32,
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
    
    `SIGNAL_OUT(DIST_OUT, `DATA_W)  
      
    `SIGNAL_SIGNED(X_DIFF, `DATA_W/2)
    `SIGNAL_SIGNED(Y_DIFF, `DATA_W/2)
    `SIGNAL_SIGNED(X_SQR, `DATA_W)
    `SIGNAL_SIGNED(Y_SQR, `DATA_W)
    `SIGNAL_SIGNED(DIST_VALUE, `DATA_W)

    `COMB begin

     X_DIFF = A[31:16] - B[31:16];
     X_SQR = X_DIFF * X_DIFF;
     Y_DIFF = A[15:0] - B[15:0];
     Y_SQR = Y_DIFF * Y_DIFF;
     DIST_VALUE = X_SQR + Y_SQR;

     end

    `SIGNAL2OUT(DIST_OUT, DIST_VALUE)      

    `SIGNAL(write_previous, 1)
    `SIGNAL(write_L, N_Neighbour)
    `SIGNAL(Neighbour_info, (`DATA_W+`LABEL)*N_Neighbour)
    `SIGNAL(Neighbour_info_LABEL, `LABEL*N_Neighbour)  
    
    `SIGNAL2OUT(Neighbour_info_out, Neighbour_info_LABEL)
    
    `SIGNAL(Write_l, 1)
    
    genvar i;

    generate
      for (i = `N_Neighbour; i > 0; i = i-1) begin
       assign Neighbour_info_LABEL[(i*`LABEL)-1:((i-1)*`LABEL)] = Neighbour_info[(i*(`DATA_W+`LABEL))-`DATA_W-1:(i-1)*(`DATA_W+`LABEL)];
      end
    endgenerate
    
    `SIGNAL(Reg_out, 40)
    `SIGNAL(Reg_in, 40)

    `COMB begin

    if(write_previous || (DIST_OUT < Reg_out[(`DATA_W+`LABEL)-1:`LABEL])) Write_l = 1'b1;
    else Write_l = 1'b0;

    if(write_previous == 1) Reg_in = Neighbour_info[(`DATA_W+`LABEL)-1:0];
    else Reg_in = {DIST_OUT, label};

    end

    `REG_ARE(clk, rst, '1, valid & start & Write_l, Reg_out, Reg_in)
    assign write_L[0] = Write_l;
    assign Neighbour_info[(`DATA_W+`LABEL)-1:0]=Reg_out;
    

    generate
      for(i = 1; i < N_Neighbour; i = i + 1) begin
        `COMB begin

          if(write_L[i-1] || (DIST_OUT < Reg_out[DATA_W+LABEL-1:LABEL])) Write_l = 1'b1;
          else Write_l = 1'b0;

          if(write_L[i-1] == 1) Reg_in = Neighbour_info[(DATA_W+LABEL)*i-1:(DATA_W+LABEL)*(i-1)];
          else Reg_in = {DIST_OUT, label};

        end

        `REG_ARE(clk, rst, '1, valid & start & Write_l, Reg_out, Reg_in)

        assign write_L[i] = Write_l;
        assign Neighbour_info[(DATA_W+LABEL)*(i+1)-1:(DATA_W+LABEL)*i]=Reg_out;
      end
    endgenerate

    assign write_previous = 1'b0;       
      
endmodule



