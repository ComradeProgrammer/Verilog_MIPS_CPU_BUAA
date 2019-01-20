`timescale 1ns / 1ps
`include"head.v"
module Exc_e(instr_e,overflow,bd_d,exccode_d,bd_e,exccode_e);
input [31:0] instr_e;
input overflow,bd_d;
input [4:0] exccode_d;
output bd_e;
output [4:0] exccode_e;

assign bd_e=bd_d;
wire [5:0] op,funct;
assign funct=instr_e[5:0];
assign op=instr_e[31:26];

assign exccode_e=(op==`special&&funct==`add_funct&&overflow||op==`special&&funct==`sub_funct&&overflow)?`exc_ov:
						(op==`sw&&overflow)?`exc_ades:
						(op==`lw&&overflow)?`exc_adel:
						exccode_d;




endmodule
