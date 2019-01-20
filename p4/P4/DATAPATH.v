`timescale 1ns / 1ps
`include "head.v"
module DATAPATH(clk,clr,
branch,regwrite,memwrite,npcop,extop,aluop,alusrc,hf,bt,
regdst,memtoreg,
isbeq,isbgtz,isbgez,isbltz,isblez,
issll,issra,issrl,v,
instr);
input clk,clr,branch,regwrite,memwrite,isbeq,alusrc,hf,bt,isbgtz,isbgez,isbltz,isblez,issra,issrl,issll,v;
input [1:0] npcop,extop,aluop,regdst;
input [2:0] memtoreg;
output[31:0] instr;
//==================mux=====================================
wire [4:0]regaddr;
wire [31:0] regdata,alubdata;
//==================wire declearation=======================
wire [31:0]pc4;
wire [31:0] rd1,rd2,extout,zero32,npcout,gtz32,gez32,ltz32,lez32,shiftout;
wire [31:0] aluout;
wire [31:0] dmout;
wire branchlogic;
//===================instr fetch============================
IM im(.clk(clk),.clr(clr),.branch(branchlogic),.npc(npcout),.instr(instr),.pc4(pc4));
assign branchlogic=(branch&isbeq&zero32[0])|(branch&isbgtz&gtz32[0])|(branch&isbgez&gez32[0])|(branch&isbltz&ltz32[0])
							|(branch&isblez&lez32[0])|(branch&~isbeq&~isbgtz&~isbgtz&~isbgez&~isbltz&~isblez);
//=====================decode===============================
wire [4:0] rs,rd,rt,shamt;
wire [5:0] op,funct;
wire [15:0] imm;
assign op=instr[31:26];
assign funct=instr[5:0];
assign shamt=instr[10:6];
assign rd=instr[15:11];
assign rt=instr[20:16];
assign rs=instr[25:21];
assign imm=instr[15:0];
GPR gpr(.clk(clk),.clr(clr),.we(regwrite),.a1(rs),.a2(rt),.a3(regaddr),.wd(regdata),.rd1(rd1),.rd2(rd2));
EXT ext(.imm(imm),.extop(extop),.extout(extout));
CMP cmp(.a(rd1),.b(rd2),.zero32(zero32),.gtz32(gtz32),.gez32(gez32),.ltz32(ltz32),.lez32(lez32));
NPC npc(.pc4(pc4),.extout(extout),.instr(instr),.rd1(rd1),.npcop(npcop),.npcout(npcout));
shift sft(rd2,rd1,shamt,issll,issrl,issra,v,shiftout);

//========================execute===============================
ALU alu(.a(rd1),.b(alubdata),.aluop(aluop),.aluout(aluout));
assign alubdata=(alusrc==`alusrc_rd2)?rd2:extout;
//======================memory==================================
DM dm(.clk(clk),.clr(clr),.we(memwrite),.addr(aluout),.wd(rd2),.dmout(dmout),.hf(hf),.bt(bt));
//========================writeback===================================
assign regaddr= (regdst==`regdst_rd)?rd:
					  (regdst==`regdst_rt)?rt:
					  5'd31;
					  
					  
					  
assign regdata=   (memtoreg==`mtr_slti)?($signed(rd1)<$signed(extout))?32'b1:32'b0:
						(memtoreg==`mtr_shift)?shiftout:
						(memtoreg==`mtr_slt)?(($signed(rd1)<$signed(rd2))?32'b1:32'b0):
						(memtoreg==`mtr_alu)?aluout:
						(memtoreg==`mtr_dm)?dmout:
						(memtoreg==`mtr_ext)?extout:
						pc4;
//================================================================================





endmodule
