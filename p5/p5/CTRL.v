`timescale 1ns / 1ps
`include"head.v"
module CTRL(instr,
				branch,npcop,extop,regdst,otherctrl,aluop,alusrc,memwrite,memtoreg,regwrite,isbeq);
				
input [31:0] instr;
output reg branch,memwrite,regwrite;
output reg[1:0] npcop,extop,regdst,otherctrl,alusrc,memtoreg;
output reg [2:0]aluop;
output isbeq;

wire [5:0] op,funct;
assign op=instr[31:26];
assign funct=instr[5:0];


initial begin
	branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
	alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
end

assign isbeq=(op==`beq);
always @(*)
	begin
		if(op==`special &&funct==`addu_funct)
			begin
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=`alu_add; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`special && funct==`subu_funct)
			begin
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=`alu_sub; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`special && funct==`jr_funct)
			begin
				branch<=1; npcop<=`npc_reg; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`ori)
			begin
				branch<=0; npcop<=0; extop<=`ext_unsign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_or; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`lw)
			begin
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_dr; regwrite<=1;
			end
		else if(op==`sw)
			begin
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=0; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc=`alusrc_oth; memwrite<=1; memtoreg<=0; regwrite<=0;
			end
		else if(op==`beq)
			begin
				branch<=1; npcop<=`npc_16; extop<=`ext_sign; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end	
		else if(op==`lui)
			begin
				branch<=0; npcop<=0; extop<=`ext_lui; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_oth; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`jal)
			begin
				branch<=1; npcop<=`npc_26; extop<=0; regdst<=`regdst_31; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=`memtoreg_pc; regwrite<=1;
			end
		else if (op==`j)
			begin
				branch<=1; npcop<=`npc_26; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else 
			begin
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		
			
		
		
	end


endmodule
