`timescale 1ns / 1ps
`include "head.v"
module Datapath(clk,clr,stall,abus,resbus,forwardbus,res_d,
					branch,npcop,extop,regdst,otherctrl,aluop,alusrc,memwrite,memtoreg,regwrite,isbeq,isbne,
					instr_d,instr_e,instr_m,instr_w,usemd,start,mdop,wordmode_m,wordmode_w);

//=====================input&output==============================
output [31:0] instr_d,instr_e,instr_m,instr_w;
output [39:0] abus;
output [8:0] resbus;
input clk,clr,stall;
input [12:0] forwardbus;
input [2:0]res_d;

//------------controler-------------
input branch,memwrite,regwrite,isbeq,usemd,start,isbne;
input [1:0] npcop,extop,regdst,otherctrl,memtoreg,alusrc,mdop;
input  [2:0]wordmode_m,wordmode_w;
input [3:0] aluop;
//--------------busdecode--------------------
//----------abus
wire [4:0] a1_d,a2_d,a1_e,a2_e,a2_m,a3_e,a3_m,a3_w;
assign abus[4:0]=a1_d;
assign abus[9:5]=a2_d;
assign abus[14:10]=a1_e;
assign abus[19:15]=a2_e;
assign abus[24:20]=a2_m;
assign abus[29:25]=a3_e;
assign abus[34:30]=a3_m;
assign abus[39:35]=a3_w;
//----resbus
wire[2:0] res_e,res_m,res_w;
assign resbus[2:0]=res_e;
assign resbus[5:3]=res_m;
assign resbus[8:6]=res_w;
//-----forwardbus
wire [2:0] fv1dctrl,fv2dctrl,faluaectrl,falubectrl;
wire fdmmctrl;
assign fv1dctrl=forwardbus[2:0];
assign fv2dctrl=forwardbus[5:3];
assign faluaectrl=forwardbus[8:6];
assign falubectrl=forwardbus[11:9];
assign fdmmctrl=forwardbus[12];
//=======================wire====================================================
//-----------mux----
wire [31:0] regdata,fv1d,fv2d,other,faluae,falube,malub,fdmm;
wire [4:0] regaddr;
//-----------------
wire [31:0] instr_i,pc8_i;//i
wire branchlogic,zero;

wire [31:0] pc8_d;//d
wire [31:0]rd1,rd2,pc4_d,extout,npcout,zero32;
wire busy,newstall;
wire [31:0] v1_e,v2_e,pc8_e,oth_e,ao_e;
wire [31:0]v2_m,ao_m,pc8_m,dr_m;
wire lez,ltz,gtz,gez,isblez,isbltz,isbgtz,isbgez;

wire [31:0] ao_w, dr_w,pc8_w;

assign newstall=((start|busy)&usemd);
//=======================instruction fetch=======================================
IFU ifu(.clk(clk),.clr(clr),.stall(stall|newstall),.branch(branchlogic),.npcout(npcout),.instr(instr_i),.pc8(pc8_i));
assign zero=zero32[0];
assign branchlogic=(branch&isbeq&zero)|(branch&isbne&~zero)|(branch&isbgtz&gtz)|(branch&isbgez&gez)|(branch&isbltz&ltz)|(branch&isblez&lez)|(branch&~isbeq&~isblez&~isbltz&~isbgez&~isbgtz&~isbne);
//=======================d pipe==================================================
Dpipe dpipe(.clk(clk),.clr(clr),.en(stall|newstall),
				.instr_i(instr_i),.pc8_i(pc8_i),
				.instr_d(instr_d),.pc8_d(pc8_d));
//=======================decode==================================================
//--instruction decode-
wire [4:0] rs,rt,rd;
wire [5:0] op;
wire [15:0] imm;
assign rs=instr_d[25:21];
assign rt=instr_d[20:16];
assign rd=instr_d[15:11];
assign imm=instr_d[15:0];
assign op=instr_d[31:26];
assign a1_d=rs;
assign a2_d=rt;
assign isbgez=(op==`bgezbltz)&&rt==1;
assign isbgtz=(op==`bgtz);
assign isblez=(op==`blez);
assign isbltz=(op==`bgezbltz)&&rt==0;
//----------------------
assign pc4_d=pc8_d-4;
GRF grf(.clk(clk),.clr(clr),.we(regwrite),.a1(rs),.a2(rt),.a3(a3_w),.wd(regdata),.rd1(rd1),.rd2(rd2));
NPC npc(.pc4(pc4_d),.extout(extout),.instr(instr_d),.rd1(fv1d),.npcop(npcop),.npcout(npcout));
EXT ext(.imm(imm),.extop(extop),.extout(extout));
CMP cmp(.a(fv1d),.b(fv2d),.cmpout(zero32),.lez(lez),.ltz(ltz),.gtz(gtz),.gez(gez));
//----------mux-----------
assign fv1d=(fv1dctrl==`fd_pc8_e)?pc8_e:
				(fv1dctrl==`fd_oth_e)?oth_e:
				(fv1dctrl==`fd_ao_m)?ao_m:
				(fv1dctrl==`fd_pc8_m)?pc8_m:
				rd1;
assign fv2d=(fv2dctrl==`fd_pc8_e)?pc8_e:
				(fv2dctrl==`fd_oth_e)?oth_e:
				(fv2dctrl==`fd_ao_m)?ao_m:
				(fv2dctrl==`fd_pc8_m)?pc8_m:
				rd2;
assign regaddr=(regdst==`regdst_rd)?rd:
					(regdst==`regdst_rt)?rt:
					5'd31;
assign other=(otherctrl==`oth_ext)?extout:32'hffffffff;
//======================Epipe========================================================
Epipe epipe (.clk(clk),.clr(clr|stall|newstall),
		 .res_d(res_d),.instr_d(instr_d),.v1_d(fv1d),.v2_d(fv2d),.a1_d(a1_d),.a2_d(a2_d),.a3_d(regaddr),.oth_d(other),.pc8_d(pc8_d),
		 .res_e(res_e),.instr_e(instr_e),.v1_e(v1_e),.v2_e(v2_e),.a1_e(a1_e),.a2_e(a2_e),.a3_e(a3_e),.oth_e(oth_e),.pc8_e(pc8_e));
//========================execute===================================================
wire [31:0] hi,lo,aluout;
wire mdwe;
assign mdwe=(instr_e[31:26]==0&&(instr_e[5:0]==`mthi_funct||instr_e[5:0]==`mtlo_funct));
ALU alu(.a(faluae),.b(malub),.aluop(aluop),.ao(aluout),.instr_e(instr_e));	
multdiv md (.clk(clk),.clr(clr),.a(faluae),.b(falube),.a1(instr_e[1]),.start(start),.mode(mdop),.we(mdwe),.busy(busy),.hi(hi),.lo(lo));
assign faluae=(faluaectrl==`falue_pc8_m)?pc8_m:
				  (faluaectrl==`falue_ao_m)?ao_m:
				  (faluaectrl==`falue_wd_w)?regdata:
				  v1_e;

assign falube=(falubectrl==`falue_pc8_m)?pc8_m:
				  (falubectrl==`falue_ao_m)?ao_m:
				  (falubectrl==`falue_wd_w)?regdata:
				  v2_e;		
assign malub=(alusrc==`alusrc_oth)?oth_e:falube;		
assign ao_e=(instr_e[31:26]==0&&instr_e[5:0]==`mfhi_funct)?hi:
            (instr_e[31:26]==0&&instr_e[5:0]==`mflo_funct)?lo:
				aluout;
wire [2:0]newres_e;
assign newres_e=(res_e==`other)?`alu:res_e;
//==========================mpipe=======================================================
Mpipe mpipe(.clk(clk),.clr(clr),
				.res_e(newres_e),.instr_e(instr_e),.v2_e(falube),.a2_e(a2_e),.ao_e(ao_e),.pc8_e(pc8_e),.a3_e(a3_e),
				.res_m(res_m),.instr_m(instr_m),.v2_m(v2_m),.a2_m(a2_m),.ao_m(ao_m),.pc8_m(pc8_m),.a3_m(a3_m));
//======================memory===========================================================
wire[3:0] be;
dmdecode decode(.wordmode(wordmode_m),.addr(ao_m),.be(be));
DM dm(.clk(clk),.clr(clr),.be(be),.we(memwrite),.addr(ao_m),.wd(fdmm),.dr(dr_m));
assign fdmm=(fdmmctrl==1)?regdata:v2_m;
//--------------------------wpipe-------------------------------------------------------------
wire [31:0]dmout;
Wpipe wpipe(.clk(clk),.clr(clr),
				.res_m(res_m),.instr_m(instr_m),.ao_m(ao_m),.dr_m(dr_m),.pc8_m(pc8_m),.a3_m(a3_m),
				.res_w(res_w),.instr_w(instr_w),.ao_w(ao_w),.dr_w(dmout),.pc8_w(pc8_w),.a3_w(a3_w));
//============================writeback=========================================================

dmcut dm_cut(.dmout(dmout),.ao_w(ao_w),.dr_w(dr_w),.wordmode(wordmode_w));
assign regdata=(memtoreg==`memtoreg_ao)?ao_w:
					(memtoreg==`memtoreg_dr)?dr_w:
					pc8_w;
endmodule
