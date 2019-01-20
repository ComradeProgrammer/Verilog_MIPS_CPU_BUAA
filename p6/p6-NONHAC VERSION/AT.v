`timescale 1ns / 1ps
`include "head.v"
module AT(instr_d,tuse_rs,tuse_rt,res_d);
input [31:0] instr_d;
output reg[1:0] tuse_rs,tuse_rt;
output reg [2:0] res_d;

initial begin
tuse_rs=0; tuse_rt=0; res_d=0;
end

wire [5:0] op,funct;
assign op=instr_d[31:26];
assign funct=instr_d[5:0];


always@(*)
	begin
		if(op==`special&&(funct==`addu_funct||funct==`subu_funct||funct==`mtlo_funct||funct==`mthi_funct
		||funct==`mult_funct||funct==`multu_funct||funct==`div_funct||funct==`divu_funct||funct==`add_funct||funct==`sub_funct
		||funct==`sllv_funct||funct==`srlv_funct||funct==`srav_funct||funct==`and_funct||funct==`or_funct||funct==`xor_funct||funct==`nor_funct
		||funct==`slt_funct||funct==`sltu_funct)
		||op==`ori||op==`lw||op==`sw||op==`lbu||op==`lb||op==`lhu||op==`lh||op==`sh||op==`sb||op==`addi||op==`addiu||op==`andi||op==`xori
		||op==`slti||op==`sltiu)
			tuse_rs<=1;
		else if(op==`special&&(funct==`jr_funct||funct==`jalr_funct )|| op==`beq||op==`bgtz||op==`blez||op==`bgezbltz||op==`bne)
			tuse_rs<=0;
		else
		   tuse_rs<=3;
		//-----------------------------------------	
		if(op==`special&&(funct==`addu_funct||funct==`subu_funct||funct==`add_funct||funct==`sub_funct
		||funct==`mult_funct||funct==`multu_funct||funct==`div_funct||funct==`divu_funct
		||funct==`sll_funct||funct==`sra_funct||funct==`srl_funct||funct==`sllv_funct||funct==`srlv_funct||funct==`srav_funct
		||funct==`and_funct||funct==`or_funct||funct==`xor_funct||funct==`nor_funct||funct==`slt_funct||funct==`sltu_funct))
			tuse_rt<=1;
		else if(op==`beq||op==`bne)
			tuse_rt<=0;
		else if(op==`sw||op==`sb||op==`sh)
			tuse_rt<=2;
		else
			tuse_rt<=3;
		//------------------------------------------
		if(op==`special&&(funct==`addu_funct||funct==`subu_funct||funct==`mflo_funct||funct==`mfhi_funct||funct==`add_funct||funct==`sub_funct
		   ||funct==`sll_funct||funct==`sra_funct||funct==`srl_funct||funct==`sllv_funct||funct==`srlv_funct||funct==`srav_funct
			||funct==`and_funct||funct==`or_funct||funct==`xor_funct||funct==`nor_funct||funct==`slt_funct||funct==`sltu_funct)
		||op==`ori||op==`addi||op==`addiu||op==`andi||op==`xori||op==`slti||op==`sltiu)
			res_d<=`alu;
		else if(op==`jal||op==`special&&funct==`jalr_funct)
			res_d<=`pc;
		else if(op==`lw||op==`lh||op==`lhu||op==`lb||op==`lbu)
			res_d<=`dm;
		else if(op==`lui)
			res_d<=`other;
		else
			res_d<=`nw;
	end




endmodule
