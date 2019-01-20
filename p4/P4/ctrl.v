`timescale 1ns / 1ps
`include"head.v"
module ctrl(instr,
branch,regwrite,memwrite,npcop,extop,aluop,alusrc,
regdst,memtoreg,hf,bt,
isbeq,isbgtz,isbgez,isbltz,isblez,issll,issra,issrl,v);
input [31:0]instr;
output reg branch,regwrite,memwrite,alusrc,hf,bt;
output reg [1:0] npcop,extop,aluop,regdst;
output reg [2:0] memtoreg;
output isbeq,isbgtz,isbgez,isbltz,isblez,issll,issra,issrl,v;
wire [5:0]op,funct;
wire [4:0] rt;
assign op=instr[31:26];
assign funct=instr[5:0];
assign rt=instr[20:16];

assign issll=(op==`special&&(funct==`sll_funct||funct==`sllv_funct));
assign issra=(op==`special&&(funct==`sra_funct||funct==`srav_funct));
assign issrl=(op==`special&&(funct==`srl_funct||funct==`srlv_funct));
assign v=(op==`special &&(funct==`sllv_funct||funct==`srav_funct||funct==`srlv_funct));
assign isbeq=(op==`beq);
assign isbgtz=(op==`bgtz);
assign isblez=(op==`blez);
assign isbgez=(op==`bgezorbltz&&rt==1);
assign isbltz=(op==`bgezorbltz&&rt==0);

initial begin
	branch=0; regwrite=0; memwrite=0; alusrc=0;
	npcop=0;  extop=0;  aluop=0; regdst=0; memtoreg=0;
	hf<=0; bt<=0;
end

always@(*)
	begin
		case (op)
		`special:
			begin
					//-----------------------------------------------------------------------------------------------
				if(funct==`addu_funct)
					begin
						branch<=0; regwrite<=1; memwrite<=0; alusrc<=0;
						npcop<=0;  extop<=0;  aluop<=`alu_add; regdst<=`regdst_rd; memtoreg<=`mtr_alu;
						hf<=0; bt<=0;
					end
					//-----------------------------------------------------------------------------------------------
				else if(funct==`subu_funct)
					begin
						branch<=0; regwrite<=1; memwrite<=0; alusrc<=0;
						npcop<=0;  extop<=0;  aluop<=`alu_sub; regdst<=`regdst_rd; memtoreg<=`mtr_alu;
						hf<=0; bt<=0;
					end
					//-----------------------------------------------------------------------------------------------
				else if(funct==`jr_funct)
					begin
						branch<=1; regwrite<=0; memwrite<=0; alusrc<=0;
						npcop<=`npc_reg;  extop<=0;  aluop<=0; regdst<=0; memtoreg<=0;
						hf<=0; bt<=0;
					end
				else if(funct==`jalr_funct)
					begin
						branch<=1; regwrite<=1; memwrite<=0; alusrc<=0;
						npcop<=`npc_reg;  extop<=0;  aluop<=0; regdst<=`regdst_rd; memtoreg<=`mtr_pc4;
						hf<=0; bt<=0;
					end
				else if(funct==`slt_funct)
					begin
						branch<=0; regwrite<=1; memwrite<=0; alusrc<=0;
						npcop<=0;  extop<=0;  aluop<=0; regdst<=`regdst_rd; memtoreg<=`mtr_slt;
						hf<=0; bt<=0;
					end
				else if(funct==`sll_funct||funct==`sra_funct||funct==`srl_funct||funct==`sllv_funct||funct==`srav_funct||funct==`srlv_funct)
					begin
						branch<=0; regwrite<=1; memwrite<=0; alusrc<=0;
						npcop<=0;  extop<=0;  aluop<=0; regdst<=`regdst_rd; memtoreg<=`mtr_shift;
						hf<=0; bt<=0;
					end
					
				else
					begin
						branch<=0; regwrite<=0; memwrite<=0; alusrc<=0;
						npcop<=0;  extop<=0;  aluop<=0; regdst<=0; memtoreg<=0;
						hf<=0; bt<=0;
					end
			end
			//-----------------------------------------------------------------------------------------------
			//--------------------------------------------------------------------------------------------------
		`ori:
			begin
				branch<=0; regwrite<=1; memwrite<=0; alusrc<=`alusrc_ext;
				npcop<=0;  extop<=`ext_unsign;  aluop<=`alu_or; regdst<=`regdst_rt; memtoreg<=`mtr_alu;
				hf<=0; bt<=0;
			end
			//-----------------------------------------------------------------------------------------------
		`lw:
			begin
				branch<=0; regwrite<=1; memwrite<=0; alusrc<=`alusrc_ext;
				npcop<=0;  extop<=`ext_sign;  aluop<=`alu_add; regdst<=`regdst_rt; memtoreg<=`mtr_dm;
				hf<=0; bt<=0;
			end
			//-----------------------------------------------------------------------------------------------
		`sw:
			begin
				branch<=0; regwrite<=0; memwrite<=1; alusrc<=`alusrc_ext;
				npcop<=0;  extop<=`ext_sign;  aluop<=`alu_add; regdst<=0; memtoreg<=0;
				hf<=0; bt<=0;
			end
			//-----------------------------------------------------------------------------------------------
		`lui:
			begin
				branch<=0; regwrite<=1; memwrite<=0; alusrc<=0;
				npcop<=0;  extop<=`ext_lui;  aluop<=0; regdst<=`regdst_rt; memtoreg<=`mtr_ext;
				hf<=0; bt<=0;
			end
			//-----------------------------------------------------------------------------------------------
		`beq:
			begin
				branch<=1; regwrite<=0; memwrite<=0; alusrc<=0;
				npcop<=`npc_16;  extop<=`ext_sign;  aluop<=0; regdst<=0; memtoreg<=0;
				hf<=0; bt<=0;
			end
			//-----------------------------------------------------------------------------------------------
		`jal:
			begin
				branch<=1; regwrite<=1; memwrite<=0; alusrc<=0;
				npcop<=`npc_26;  extop<=0;  aluop<=0; regdst<=`regdst_31; memtoreg<=`mtr_pc4;
				hf<=0; bt<=0;
			end
		`sh:
			begin
				branch<=0; regwrite<=0; memwrite<=1; alusrc<=`alusrc_ext;
				npcop<=0;  extop<=`ext_sign;  aluop<=`alu_add; regdst<=0; memtoreg<=0;
				hf<=1; bt<=0;
			end
		`sb:
			begin
				branch<=0; regwrite<=0; memwrite<=1; alusrc<=`alusrc_ext;
				npcop<=0;  extop<=`ext_sign;  aluop<=`alu_add; regdst<=0; memtoreg<=0;
				hf<=0; bt<=1;
			end
		`lbu:
			begin
				branch<=0; regwrite<=1; memwrite<=0; alusrc<=`alusrc_ext;
				npcop<=0;  extop<=`ext_sign;  aluop<=`alu_add; regdst<=`regdst_rt; memtoreg<=`mtr_dm;
				hf<=0; bt<=1;
			end
			//------------------------------------------------------------------------------------------------
		`lhu:
			begin
				branch<=0; regwrite<=1; memwrite<=0; alusrc<=`alusrc_ext;
				npcop<=0;  extop<=`ext_sign;  aluop<=`alu_add; regdst<=`regdst_rt; memtoreg<=`mtr_dm;
				hf<=1; bt<=0;
			end
			//-----------------------------------------------------------------------------------------------
		`addiu:
			begin
				branch<=0; regwrite<=1; memwrite<=0; alusrc<=`alusrc_ext;
				npcop<=0;  extop<=`ext_sign;  aluop<=`alu_add; regdst<=`regdst_rt; memtoreg<=`mtr_alu;
				hf<=0; bt<=0;
			end
			//-----------------------------------------------------------------------------------------------
		`bgtz:
			begin
				branch<=1; regwrite<=0; memwrite<=0; alusrc<=0;
				npcop<=`npc_16;  extop<=`ext_sign;  aluop<=0; regdst<=0; memtoreg<=0;
				hf<=0; bt<=0;
			end
		`bgezorbltz:
			begin
				branch<=1; regwrite<=0; memwrite<=0; alusrc<=0;
				npcop<=`npc_16;  extop<=`ext_sign;  aluop<=0; regdst<=0; memtoreg<=0;
				hf<=0; bt<=0;
			end
		`blez:
			begin
				branch<=1; regwrite<=0; memwrite<=0; alusrc<=0;
				npcop<=`npc_16;  extop<=`ext_sign;  aluop<=0; regdst<=0; memtoreg<=0;
				hf<=0; bt<=0;
			end
			//-------------------------------------------------------------
		`j:
			begin
				branch<=1; regwrite<=0; memwrite<=0; alusrc<=0;
				npcop<=`npc_26;  extop<=0;  aluop<=0; regdst<=0; memtoreg<=0;
				hf<=0; bt<=0;
			end
			//-------------------------------------------------------------
		`slti:
			begin
				branch<=0; regwrite<=1; memwrite<=0; alusrc<=0;
				npcop<=0;  extop<=`ext_sign;  aluop<=0; regdst<=`regdst_rt; memtoreg<=`mtr_slti;
				hf<=0; bt<=0;
			end
		
			//-----------------------------------------------------------------------------------------------
		default:
			begin
				branch<=0; regwrite<=0; memwrite<=0; alusrc<=0;
				npcop<=0;  extop<=0;  aluop<=0; regdst<=0; memtoreg<=0;
				hf<=0; bt<=0;
			end
		
		
		
		
		endcase
	end

endmodule
