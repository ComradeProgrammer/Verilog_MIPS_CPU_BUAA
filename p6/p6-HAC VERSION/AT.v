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
wire [4:0] rs;
assign op=instr_d[31:26];
assign funct=instr_d[5:0];
assign rs=instr_d[25:21];


always@(*)
	begin
		if((op==`special&&(funct==`addu_funct||funct==`subu_funct||funct==`add_funct||funct==`sub_funct||funct==`and_funct))
		    ||op==`ori||op==`lw||op==`sw||op==`andi||op==`addiu)
			tuse_rs<=1;
		else if(op==`special&&funct==`jr_funct || op==`beq)
			tuse_rs<=0;
		else
		   tuse_rs<=3;
		//-----------------------------------------	
		if((op==`special&&(funct==`addu_funct||funct==`subu_funct||funct==`add_funct||funct==`sub_funct||funct==`and_funct))
			||(op==`cop0&&rs==`mtc0_rs))
			tuse_rt<=1;
		else if(op==`beq)
			tuse_rt<=0;
		else if(op==`sw)
			tuse_rt<=2;
		else
			tuse_rt<=3;
		//------------------------------------------
		if((op==`special&&(funct==`addu_funct||funct==`subu_funct||funct==`add_funct||funct==`sub_funct||funct==`and_funct))
		  ||op==`ori||op==`andi||op==`addiu)
			res_d<=`alu;
		else if(op==`jal)
			res_d<=`pc;
		else if(op==`lw||(op==`cop0&&rs==`mfc0_rs))
			res_d<=`dm;
		else if(op==`lui)
			res_d<=`other;
		else
			res_d<=`nw;
	end




endmodule
