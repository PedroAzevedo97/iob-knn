`timescale 1ns/1ps
`include "iob_lib.vh"

module control
   (
    `OUTPUT(Data_Loaded, 1),
    `INPUT(valid, 1),
    `INPUT(clk, 1),
    `INPUT(enable, 1),
    `INPUT(rst, 1),
    `INPUT(wstrb, 1)
    );

    `SIGNAL(pc, 2)
    `SIGNAL(next_pc, 2)
    `SIGNAL(cont_out, 1)
    `REG_ARE(clk, rst, 0, enable, pc, next_pc)
    `SIGNAL2OUT(Data_Loaded, cont_out)

    `COMB begin

    next_pc = pc;
    cont_out = 1'b0;

    case(pc)
      0: begin
        if(valid && wstrb) next_pc = pc + 1'b1;
      end

      1: begin
        if(valid && wstrb) next_pc = pc + 1'b1;
      end

      2: begin
        next_pc = 1'b0;
        cont_out = 1'b1;
      end

      default: begin
        next_pc = 1'b0;
        cont_out = 1'b0;
      end

    endcase

    end

endmodule
