`timescale 1ns / 1ps
`include"head.v"
module Exc_i(instr_d,pc8_i,bd_i,exccode_i);

input [31:0] pc8_i,instr_d;
output bd_i;
output [4:0] exccode_i;

wire [31:0] pc;
assign pc=pc8_i-8;
assign bd_i=(instr_d[31:26]==`beq
				||instr_d[31:26]==`j
				||instr_d[31:26]==`jal
				||instr_d[31:26]==`special&&instr_d[5:0]==`jr_funct);
assign exccode_i=(pc>32'h4ffc||pc<32'h3000||pc[1:0]!=0)?`exc_adel:0;

endmodule
