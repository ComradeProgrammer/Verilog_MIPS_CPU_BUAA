`timescale 1ns / 1ps
`include"head.v"
module CTRL(instr,
				branch,npcop,extop,regdst,otherctrl,aluop,alusrc,memwrite,memtoreg,regwrite,isbeq,isbne,
				mdop,start,usemd,wordmode);
integer debug;				
input [31:0] instr;
output [1:0] mdop;
output start,usemd;
output reg branch,memwrite,regwrite;
output reg[1:0] npcop,extop,regdst,otherctrl,alusrc,memtoreg;
output reg [3:0]aluop;
output isbeq,isbne;
output [2:0]wordmode;

wire [5:0] op,funct;
wire [4:0] rt;
assign rt=instr[20:16];
assign op=instr[31:26];
assign funct=instr[5:0];

assign isbeq=(op==`beq);
assign isbne=(op==`bne);
assign usemd=(op==`special&&(funct==`mfhi_funct||funct==`mflo_funct||funct==`mthi_funct||funct==`mtlo_funct
              ||funct==`mult_funct||funct==`multu_funct||funct==`div_funct||funct==`divu_funct));
assign start=(op==`special&&(funct==`mult_funct||funct==`multu_funct||funct==`div_funct||funct==`divu_funct));
assign  mdop=((op==`special)&&funct==`divu_funct)?`md_divu:
				  ((op==`special)&&funct==`div_funct)?`md_div:
				  ((op==`special)&&funct==`multu_funct)?`md_multu:
				  `md_mult;
assign wordmode=(op==`lw||op==`sw)?`wm_wd:
                (op==`lh||op==`sh)?`wm_hs:
					 (op==`lhu)?`wm_hu:
					 (op==`lb||op==`sb)?`wm_bs:
					 `wm_bu;
initial begin
	branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
	alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
	debug=0;
end


always @(*)
	begin
		if(op==`special &&(funct==`addu_funct||funct==`add_funct))
			begin
			debug=1;
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=`alu_add; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`special && (funct==`subu_funct||funct==`sub_funct))
			begin
			debug=2;
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=`alu_sub; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`special&&(funct==`and_funct||funct==`or_funct||funct==`xor_funct||funct==`nor_funct))
			begin
			debug=3;
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0;  
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if(funct==`and_funct)
					aluop<=`alu_and;
				else if(funct==`or_funct)
					aluop<=`alu_or;
				else if(funct==`xor_funct)
					aluop<=`alu_xor;
				else if(funct==`nor_funct)
					aluop<=`alu_nor;
			end
		else if(op==`special && funct==`jr_funct)
			begin
			debug=4;
				branch<=1; npcop<=`npc_reg; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`ori||op==`andi||op==`xori)
			begin
			debug=5;
				branch<=0; npcop<=0; extop<=`ext_unsign; regdst<=`regdst_rt; otherctrl<=`oth_ext; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if(op==`ori)
					aluop<=`alu_or;
				else if(op==`andi)
					aluop<=`alu_and;
				else if(op==`xori)
					aluop<=`alu_xor;
			end
		else if(op==`addi||op==`addiu)
			begin
			debug=6;
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`lw||op==`lbu||op==`lb||op==`lhu||op==`lh)
			begin
			debug=7;
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_dr; regwrite<=1;
			end
		else if(op==`sw||op==`sb||op==`sh)
			begin
			debug=8;
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=0; otherctrl<=`oth_ext; aluop<=`alu_add; 
				alusrc=`alusrc_oth; memwrite<=1; memtoreg<=0; regwrite<=0;
			end
		else if(op==`beq||op==`bgtz||op==`blez||op==`bgezbltz||op==`bne)
			begin
			debug=9;
				branch<=1; npcop<=`npc_16; extop<=`ext_sign; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end	
		else if(op==`lui)
			begin
			debug=10;
				branch<=0; npcop<=0; extop<=`ext_lui; regdst<=`regdst_rt; otherctrl<=`oth_ext; aluop<=`alu_oth; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`jal)
			begin
			debug=11;
				branch<=1; npcop<=`npc_26; extop<=0; regdst<=`regdst_31; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=`memtoreg_pc; regwrite<=1;
			end
		else if (op==`j)
			begin
			debug=12;
				branch<=1; npcop<=`npc_26; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`special&&funct==`jalr_funct)
			begin
			debug=13;
				branch<=1; npcop<=`npc_reg; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=`memtoreg_pc; regwrite<=1;
			end
		else if(start)//mult multu div divu
			begin
			debug=14;
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`special &&(funct==`mfhi_funct||funct==`mflo_funct) )
			begin
			debug=15;
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; aluop<=0; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
			end
		else if(op==`special &&(funct==`mthi_funct && funct ==`mtlo_funct))
			begin
			debug=16;
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		else if(op==`special&&(funct==`sll_funct||funct==`srl_funct||funct==`sra_funct||funct==`sllv_funct||funct==`srlv_funct
		        ||funct==`srav_funct))
			begin
			debug=17;
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0; 
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if(funct==`sll_funct) aluop<=`alu_sll;
				else if(funct==`sra_funct ) aluop<=`alu_sra;
				else if(funct==`srl_funct )aluop<=`alu_srl;
				else if(funct==`sllv_funct) aluop<=`alu_sllv;
				else if(funct==`srlv_funct) aluop<=`alu_srlv;
				else if(funct==`srav_funct) aluop<=`alu_srav;
			end
		else if(op==`special&&(funct==`slt_funct||funct==`sltu_funct))
			begin
			debug=18;
				branch<=0; npcop<=0; extop<=0; regdst<=`regdst_rd; otherctrl<=0;  
				alusrc=`alusrc_rd2; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if(funct==`slt_funct)
					aluop<=`alu_slt;
				else if(funct==`sltu_funct)
					aluop<=`alu_sltu;
			end
		else if(op==`slti||op==`sltiu)
			begin
			debug=19;
				branch<=0; npcop<=0; extop<=`ext_sign; regdst<=`regdst_rt; otherctrl<=`oth_ext; 
				alusrc=`alusrc_oth; memwrite<=0; memtoreg<=`memtoreg_ao; regwrite<=1;
				if(op==`slti)
					aluop<=`alu_slt;
				else if(op==`sltiu)
					aluop<=`alu_sltu;
			end
		else 
			begin
			debug=20;
				branch<=0; npcop<=0; extop<=0; regdst<=0; otherctrl<=0; aluop<=0; 
				alusrc=0; memwrite<=0; memtoreg<=0; regwrite<=0;
			end
		
			
		
		
	end


endmodule
