`timescale 1ns / 1ps
`include"head.v"
module CTRL(instr,
				branch,npcop,extop,regdst,otherctrl,aluop,alusrc,memwrite,memtoreg,regwrite,isbeq,
				ismtc0,ismfc0);
				
input [31:0] instr;
output reg branch,memwrite,regwrite;
output reg[1:0] extop,regdst,otherctrl,alusrc,memtoreg;
output reg [2:0]aluop,npcop;
output isbeq,ismtc0,ismfc0;

wire [5:0] op,funct;
assign op=instr[31:26];
assign funct=instr[5:0];
wire [4:0] rs,rt,rd;
assign rs=instr[25:21];
assign rt=instr[20:16];
assign rd=instr[15:11];

initial begin
	branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
	alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
end

assign isbeq=(op==`beq);
assign ismfc0=(op==`cop0&&rs==`mfc0_rs);
assign ismtc0=(op==`cop0&&rs==`mtc0_rs);
always @(*)
	begin
		if(op==`special &&(funct==`addu_funct||funct==`add_funct))
			begin//addu
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=`alu_add; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`special && (funct==`subu_funct||funct==`sub_funct))
			begin//subu
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=`alu_sub; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`special&&funct==`jr_funct&&instr[20:6]==0)
			begin//jr
				branch<=1; npcop<=`npc_reg; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`special && funct==`and_funct)
			begin//and
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=`alu_and; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`andi)
			begin//andi
				branch<=0; npcop<=0; extop<=`ext_unsign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_and; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`ori)
			begin//ori
				branch<=0; npcop<=0; extop<=`ext_unsign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_or; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`lw)
			begin//lw
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_dr; regwrite<=1;
			end
		else if(op==`sw)
			begin//sw
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=0; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc=`alusrc_oth; memwrite<=1; memtoreg<=0; regwrite<=0;
			end
		else if(op==`beq)
			begin//beq
				branch<=1; npcop<=`npc_16; extop<=`ext_sign; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end	
		else if(op==`lui)
			begin//lui
				branch<=0; npcop<=0; extop<=`ext_lui; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_oth; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`jal)
			begin//jal
				branch<=1; npcop<=`npc_26; extop<=0; regdst<=`regdst_31; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=`memtoreg_pc; regwrite<=1;
			end
		else if (op==`j)
			begin//j
				branch<=1; npcop<=`npc_26; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(instr==`eret)
			begin
				branch<=1; npcop<=`npc_epc; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`cop0&&rs==`mfc0_rs&&instr[10:0]==0)
			begin
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rt; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=`memtoreg_dr; regwrite<=1;
			end
		else if(op==`cop0&&rs==`mtc0_rs&&instr[10:0]==0)
			begin
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`addiu)
			begin
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else 
			begin//default
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		
			
		
		
	end


endmodule
