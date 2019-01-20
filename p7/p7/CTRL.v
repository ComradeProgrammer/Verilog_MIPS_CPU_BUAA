`timescale 1ns / 1ps
`include"head.v"
module CTRL(instr,
				branch,npcop,extop,regdst,otherctrl,aluop,alusrc,memwrite,memtoreg,regwrite,isbeq,isbne,
				ismtc0,ismfc0,
				wordmode,
				usemd,start,mdop);
integer debug;				
input [31:0] instr;
output reg branch,memwrite,regwrite;
output reg[1:0] extop,regdst,otherctrl,alusrc,memtoreg;
output reg [2:0]npcop;
output isbeq,ismtc0,ismfc0,isbne;
output [2:0] wordmode;
output start,usemd;
output [1:0]mdop;
output reg[4:0] aluop;


wire [5:0] op,funct;
assign op=instr[31:26];
assign funct=instr[5:0];
wire [4:0] rs,rt,rd,shamt;
assign rs=instr[25:21];
assign rt=instr[20:16];
assign rd=instr[15:11];
assign shamt=instr[10:6];

assign isbeq=(op==`beq);
assign isbne=(op==`bne);
assign ismfc0=(op==`cop0&&rs==`mfc0_rs);
assign ismtc0=(op==`cop0&&rs==`mtc0_rs);
assign wordmode=(op==`lbu)?`wm_bu:
                (op==`lh||op==`sh)?`wm_hs:
					 (op==`lhu)?`wm_hu:
					 (op==`lb||op==`sb)?`wm_bs:
					 `wm_wd;
					 
assign  mdop=((op==`special)&&funct==`divu_funct&&instr[15:6]==0)?`md_divu:
				  ((op==`special)&&funct==`div_funct&&instr[15:6]==0)?`md_div:
				  ((op==`special)&&funct==`multu_funct&&instr[15:6]==0)?`md_multu:
				  `md_mult;
assign usemd=(op==`special&&instr[20:6]==0&&(funct==`mthi_funct||funct==`mtlo_funct)
				 ||op==`special&&instr[25:16]==0&&instr[10:6]==0&&(funct==`mfhi_funct||funct==`mflo_funct)
				 ||(op==`special&&funct==`divu_funct&&instr[15:6]==0)
				 ||(op==`special&&funct==`div_funct&&instr[15:6]==0)
				 ||(op==`special&&funct==`multu_funct&&instr[15:6]==0)
				 ||(op==`special&&funct==`mult_funct&&instr[15:6]==0));
assign start=(op==`special&&funct==`divu_funct&&instr[15:6]==0)
				 ||(op==`special&&funct==`div_funct&&instr[15:6]==0)
				 ||(op==`special&&funct==`multu_funct&&instr[15:6]==0)
				 ||(op==`special&&funct==`mult_funct&&instr[15:6]==0);
initial begin
debug=0;
	branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
	alusrc<=0; memwrite<=0; memtoreg<=0; regwrite<=0;
end


always @(*)
	begin
		if(op==`special &&shamt==0&&(funct==`addu_funct||funct==`add_funct||funct==`subu_funct||funct==`sub_funct
		                    ||funct==`and_funct||funct==`or_funct||funct==`xor_funct||funct==`nor_funct))
			begin//addu add subu sub and or xor nor
			debug=1;
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; 
				alusrc<=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if (funct==`addu_funct||funct==`add_funct)
					aluop<=`alu_add;
				else if(funct==`subu_funct||funct==`sub_funct)
					aluop<=`alu_sub;
				else if(funct==`and_funct)
					aluop<=`alu_and;
				else if(funct==`or_funct)
					aluop<=`alu_or;
				else if(funct==`xor_funct)
					aluop<=`alu_xor;
				else if(funct==`nor_funct)
					aluop<=`alu_nor;	
				else 
					aluop<=`alu_debug;
			end
		else if(op==`ori||op==`andi||op==`xori)
			begin//ori andi xori
				debug=2;
				branch<=0; npcop<=0; extop<=`ext_unsign; regdst<=`regdst_rt; otherctrl<=`oth_ext;
				alusrc<=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if(op==`ori) 
						aluop<=`alu_or;
				else if(op==`andi)
						aluop<=`alu_and;
				else if(op==`xori)
						aluop<=`alu_xor;
	
			end
		else if(op==`special&&shamt==0&&funct==`jr_funct&&instr[20:6]==0)
			begin//jr
				branch<=1; npcop<=`npc_reg; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		
		else if(op==`addiu||op==`addi)
			begin//addiu addi 
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc<=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`lw||op==`lh||op==`lhu||op==`lb||op==`lbu)
			begin//lw lh lhu lb lbu
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc<=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_dr; regwrite<=1;
			end
		else if(op==`sw||op==`sb||op==`sh)
			begin//sw sb sh
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=0; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc<=`alusrc_oth; memwrite<=1; memtoreg<=0; regwrite<=0;
			end
		else if(op==`special&&rs==0&&(funct==`sll_funct||funct==`sra_funct||funct==`srl_funct))
			begin//sll sra srl
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; 
				alusrc<=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
					if(funct==`sll_funct) aluop<=`alu_sll;
					else if(funct==`srl_funct) aluop<=`alu_srl;
					else if(funct==`sra_funct) aluop<=`alu_sra;
			end
		else if(op==`special&&shamt==0&&(funct==`sllv_funct||funct==`srlv_funct||funct==`srav_funct))
			begin//sllv srlv srav
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; 
				alusrc<=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
					if (funct==`sllv_funct) aluop<=`alu_sllv;
					else if(funct==`srlv_funct) aluop<=`alu_srlv;
					else if(funct==`srav_funct) aluop<=`alu_srav;
			end
		else if(op==`special&&shamt==0&&(funct==`slt_funct||funct==`sltu_funct))
			begin//slt sltu
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; 
				alusrc<=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if(funct==`slt_funct) aluop<=`alu_slt;
				else if(funct==`sltu_funct) aluop<=`alu_sltu;
			end
		else if(op==`slti||op==`sltiu)
			begin//slti sltiu
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; 
				alusrc<=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if(op==`slti)       aluop<=`alu_slt;
				else if(op==`sltiu) aluop<=`alu_sltu;
			end
		else if(op==`beq||op==`bne
		   ||((op==`bgtz||op==`blez)&&rt==0)
		   ||op==`bgezbltz)
			begin//beq bgtz blez bgez bltz bne
				branch<=1; npcop<=`npc_16; extop<=`ext_sign; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc<=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end	
		else if(op==`lui)
			begin//lui
				branch<=0; npcop<=0; extop<=`ext_lui; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_oth; 
				alusrc<=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`jal)
			begin//jal
				branch<=1; npcop<=`npc_26; extop<=0; regdst<=`regdst_31; otherctrl<=0; aluop<=0; 
				alusrc<=0; memwrite<=0; memtoreg<=`memtoreg_pc; regwrite<=1;
			end
		else if (op==`j)
			begin//j
				branch<=1; npcop<=`npc_26; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`special&&funct==`jalr_funct&&shamt==0)
			begin//jalr
				branch<=1; npcop<=`npc_reg; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=0; 
				alusrc<=0; memwrite<=0; memtoreg<=`memtoreg_pc; regwrite<=1;
			end
		else if(instr==`eret)
			begin//eret
				branch<=1; npcop<=`npc_epc; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc<=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`cop0&&rs==`mfc0_rs&&instr[10:0]==0)
			begin//mfc0
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rt; otherctrl<=0; aluop<=0; 
				alusrc<=0; memwrite<=0; memtoreg<=`memtoreg_dr; regwrite<=1;
			end
		else if(op==`cop0&&rs==`mtc0_rs&&instr[10:0]==0)
			begin//mtc0
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc<=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`special&&instr[15:6]==0&&(funct==`mult_funct||funct==`multu_funct||funct==`div_funct||funct==`divu_funct))
			begin//mult multu div divu
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc<=`alusrc_rd2; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`special &&(funct==`mfhi_funct||funct==`mflo_funct) )
			begin//mfhi mflo
			debug=15;
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=0; 
				alusrc<=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`special &&(funct==`mthi_funct || funct ==`mtlo_funct))
			begin//mtli mtlo
			debug=16;
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc<=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else 
			begin//default
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc<=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
	end


endmodule
