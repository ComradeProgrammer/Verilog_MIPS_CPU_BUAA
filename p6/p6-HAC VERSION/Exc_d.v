`timescale 1ns / 1ps
`include"head.v"
module Exc_d(instr_d,exccode_i,bd_d,exccode_d,bd_i);
input [31:0] instr_d;
input bd_i;
input [4:0] exccode_i;

output bd_d;
output [4:0] exccode_d;

wire[5:0] op,funct;
wire [4:0] rs,rt,rd,shamt;
assign funct=instr_d[5:0];
assign op=instr_d[31:26];
assign rs=instr_d[25:21];
assign rt=instr_d[20:16];
assign rd=instr_d[15:11];
assign shamt=instr_d[10:6];

/*assign exccode_d=!(op==`ori||op==`lw||op==`sw||op==`beq||op==`lui||op==`jal||op==`andi
		||op==`j||op==`cop0
		||(op==`special&&(funct==`jr_funct||funct==`addu_funct||funct==`subu_funct||funct==`add_funct||funct==`sub_funct||funct==`and_funct))
		||instr_d==`eret||instr_d==0)?`exc_ri:exccode_i;*/
assign bd_d=bd_i;
assign exccode_d=!(instr_d==`eret
						||(op==`special&&shamt==0&&(funct==`add_funct||funct==`addu_funct||funct==`and_funct||funct==`sub_funct||funct==`subu_funct))
						||(op==`special&&funct==`jr_funct&&instr_d[20:6]==0)
						||op==`ori||op==`lw||op==`sw||op==`beq||op==`j||op==`jal||op==`andi||op==`addiu
						||op==`lui&&rs==0
						||op==`cop0&&rs==`mtc0_rs&&instr_d[10:0]==0
						||op==`cop0&&rs==`mfc0_rs&&instr_d[10:0]==0
						||instr_d==0
						)?`exc_ri:exccode_i;


endmodule
