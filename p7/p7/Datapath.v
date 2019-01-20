`timescale 1ns / 1ps
`include "head.v"
module Datapath(clk,clr,stall,abus,resbus,forwardbus,res_d,
					branch,npcop,extop,regdst,otherctrl,aluop,alusrc,memwrite,memtoreg,regwrite,isbeq,isbne,
					instr_d,instr_e,instr_m,instr_w,
					addrbus,wdbus,bridge_rd,cp0_rd,cp0_epc,intreq,bd,exccode,ismfc0,fepcctrl,cp0dst,pc8_m,
					wordmode_m,wordmode_w,usemd,start,mdop);


//=====================input&output==============================
output [31:0] instr_d,instr_e,instr_m,instr_w;
output [39:0] abus;
output [8:0] resbus;
input clk,clr,stall;
input [12:0] forwardbus;
input [2:0]res_d,wordmode_m,wordmode_w;
//------------controler----------------------
input branch,memwrite,regwrite,isbeq,isbne,usemd,start;
input [1:0] extop,regdst,otherctrl,memtoreg,alusrc,mdop;
input  [2:0] npcop;
input [4:0] aluop;
//================p6_exception input&output=======================
output [31:0] addrbus,wdbus,pc8_m;
output bd;
output [4:0]exccode,cp0dst;
input[31:0] bridge_rd,cp0_rd,cp0_epc;
input intreq,ismfc0;
input [2:0] fepcctrl;

//--------------busdecode--------------------
//----------abus-----------------------------
wire [4:0] a1_d,a2_d,a1_e,a2_e,a2_m,a3_e,a3_m,a3_w;
assign abus[4:0]=a1_d;
assign abus[9:5]=a2_d;
assign abus[14:10]=a1_e;
assign abus[19:15]=a2_e;
assign abus[24:20]=a2_m;
assign abus[29:25]=a3_e;
assign abus[34:30]=a3_m;
assign abus[39:35]=a3_w;
//----resbus---------------------------------
wire[2:0] res_e,res_m,res_w;
assign resbus[2:0]=res_e;
assign resbus[5:3]=res_m;
assign resbus[8:6]=res_w;
//-----forwardbus----------------------------
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
wire [31:0] datam;
//-----------------
wire [31:0] instr_i,pc8_i;//i
wire branchlogic,zero,overflow;

wire [31:0] pc8_d;//d
wire [31:0]rd1,rd2,pc4_d,extout,npcout,zero32;
//--instruction decode-
wire [5:0] op;
wire [4:0] rs,rt,rd;
wire [15:0] imm;
assign op=instr_d[31:26];
assign rs=instr_d[25:21];
assign rt=instr_d[20:16];
assign rd=instr_d[15:11];
assign imm=instr_d[15:0];
assign a1_d=rs;
assign a2_d=rt;
//----------------------
wire [31:0] v1_e,v2_e,pc8_e,oth_e,ao_e;
wire [31:0]v2_m,ao_m,pc8_m,dr_m;
wire [31:0] ao_w, dr_w,pc8_w;
wire gtz,gez,ltz,lez;
wire isbgtz,isbgez,isbltz,isblez;
assign isbgtz=(op==`bgtz&&rt==0);
assign isblez=(op==`blez&&rt==0);
assign isbltz=(op==`bgezbltz&&rt==0);
assign isbgez=(op==`bgezbltz&&rt==1);

wire bd_i,bd_dl,bd_dr,bd_el,bd_er,bd_ml;
wire [4:0] exccode_i,exccode_dl,exccode_dr,exccode_el,exccode_er,exccode_ml;
wire iseret_d;
assign iseret_d=(instr_d==`eret);
assign cp0dst=instr_m[15:11];
wire stop,ret,busy,mdstall;
assign mdstall=(start|busy)&&usemd;
assign ret=((instr_m[31:26]==`special&&instr_m[20:6]==0&&instr_m[5:0]==`mthi_funct)
				||(instr_m[31:26]==`special&&instr_m[20:6]==0&&instr_m[5:0]==`mtlo_funct))
				&&intreq;
assign stop=((instr_m[31:26]==`special&&instr_m[5:0]==`divu_funct&&instr_m[15:6]==0)
				 ||(instr_m[31:26]==`special&&instr_m[5:0]==`div_funct&&instr_m[15:6]==0)
				 ||(instr_m[31:26]==`special&&instr_m[5:0]==`multu_funct&&instr_m[15:6]==0)
				 ||(instr_m[31:26]==`special&&instr_m[5:0]==`mult_funct&&instr_m[15:6]==0)
				 ||(instr_e[31:26]==`special&&instr_e[5:0]==`divu_funct&&instr_e[15:6]==0)
				 ||(instr_e[31:26]==`special&&instr_e[5:0]==`div_funct&&instr_e[15:6]==0)
				 ||(instr_e[31:26]==`special&&instr_e[5:0]==`multu_funct&&instr_e[15:6]==0)
				 ||(instr_e[31:26]==`special&&instr_e[5:0]==`mult_funct&&instr_e[15:6]==0)
				 ||(instr_m[31:26]==`special&&instr_m[20:6]==0&&instr_m[5:0]==`mthi_funct)
				 ||(instr_m[31:26]==`special&&instr_m[20:6]==0&&instr_m[5:0]==`mtlo_funct)
				 ||(instr_e[31:26]==`special&&instr_e[20:6]==0&&instr_e[5:0]==`mthi_funct)
				 ||(instr_e[31:26]==`special&&instr_e[20:6]==0&&instr_e[5:0]==`mtlo_funct))
				 &&intreq;
//======================main part================================================
//**********************ypa!*****************************************************
//=======================instruction fetch=======================================
IFU ifu(.clk(clk),.clr(clr),.stall(stall|mdstall),.branch(branchlogic),.intreq(intreq),.npcout(npcout),.instr(instr_i),.pc8(pc8_i));
assign zero=zero32[0];
assign branchlogic=(branch&isbeq&zero)|(branch&isbne&~zero)|(branch&isbgtz&gtz)|(branch&isbgez&gez)|(branch&isblez&lez)
       |(branch&isbltz&ltz) |(branch&~isbeq&~isbgtz&~isbltz&~isblez&~isbgez&~isbne);
Exc_i exc_i(.instr_d(instr_d),.pc8_i(pc8_i),.bd_i(bd_i),.exccode_i(exccode_i),.b_d(branchlogic));
//=======================d pipe==================================================
wire [31:0] newinstr_i;
assign newinstr_i=(exccode_i==0)?instr_i:0;
Dpipe dpipe(.clk(clk),.clr(clr|intreq),.en(stall|mdstall),.npcout(npcout),.iseret(iseret_d),
				.instr_i(newinstr_i),.pc8_i(pc8_i),.bd_i(bd_i),.exccode_i(exccode_i),
				.instr_d(instr_d),.pc8_d(pc8_d),.bd_d(bd_dl),.exccode_d(exccode_dl));
//=======================decode==================================================

assign pc4_d=pc8_d-4;
wire [31:0] fepc;
GRF grf(.clk(clk),.clr(clr),.we(regwrite),.a1(rs),.a2(rt),.a3(a3_w),.wd(regdata),.rd1(rd1),.rd2(rd2));
NPC npc(.pc4(pc4_d),.extout(extout),.instr(instr_d),.rd1(fv1d),.epc(fepc),.npcop(npcop),.intreq(intreq),.npcout(npcout));
EXT ext(.imm(imm),.extop(extop),.extout(extout));
CMP cmp(.a(fv1d),.b(fv2d),.cmpout(zero32),.lez(lez),.ltz(ltz),.gtz(gtz),.gez(gez));
Exc_d exc_d(.instr_d(instr_d),.exccode_i(exccode_dl),.bd_d(bd_dr),.exccode_d(exccode_dr),.bd_i(bd_dl));
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
assign other=(otherctrl==`oth_ext)?extout:32'h1723ffff;
assign fepc=(fepcctrl==`fepc_e)?falube:
            (fepcctrl==`fepc_m)?fdmm:
				(fepcctrl==`fepc_cp0)?cp0_epc:
				32'h17230003;
//======================Epipe========================================================
Epipe epipe (.clk(clk),.clr(clr|intreq),.stall(stall|mdstall),
		 .res_d(res_d),.instr_d(instr_d),.v1_d(fv1d),.v2_d(fv2d),.a1_d(a1_d),.a2_d(a2_d),.a3_d(regaddr),.oth_d(other),.pc8_d(pc8_d),.bd_d(bd_dr),.exccode_d(exccode_dr),
		 .res_e(res_e),.instr_e(instr_e),.v1_e(v1_e),.v2_e(v2_e),.a1_e(a1_e),.a2_e(a2_e),.a3_e(a3_e),.oth_e(oth_e),.pc8_e(pc8_e),.bd_e(bd_el),.exccode_e(exccode_el));
//========================execute===================================================
wire [31:0]aluout,hi,lo;
wire mdwe,mdwsel;
ALU alu(.a(faluae),.b(malub),.aluop(aluop),.instr_e(instr_e),.ao(aluout),.overflow(overflow));	
Exc_e exc_e(.instr_e(instr_e),.overflow(overflow),.bd_d(bd_el),.exccode_d(exccode_el),.bd_e(bd_er),.exccode_e(exccode_er));
Multdiv multdiv(.clk(clk),.clr(clr),.a(faluae),.b(falube),.a1(mdwsel),.start(start),.mode(mdop),.stop(stop),.ret(ret),.we(mdwe),.busy(busy),.hi(hi),.lo(lo));
assign faluae=(faluaectrl==`falue_pc8_m)?pc8_m:
				  (faluaectrl==`falue_ao_m)?ao_m:
				  (faluaectrl==`falue_wd_w)?regdata:
				  v1_e;

assign falube=(falubectrl==`falue_pc8_m)?pc8_m:
				  (falubectrl==`falue_ao_m)?ao_m:
				  (falubectrl==`falue_wd_w)?regdata:
				  v2_e;		
assign malub=(alusrc==`alusrc_oth)?oth_e:falube;		
wire [2:0]newres_e;
assign newres_e=(res_e==`other)?`alu:res_e;
assign ao_e=(instr_e[31:26]==`special&&instr_e[25:16]==0&&instr_e[10:6]==0&&instr_e[5:0]==`mfhi_funct)?hi:
				(instr_e[31:26]==`special&&instr_e[25:16]==0&&instr_e[10:6]==0&&instr_e[5:0]==`mflo_funct)?lo:
				aluout;
assign mdwe=(instr_e[31:26]==`special&&instr_e[20:6]==0&&instr_e[5:0]==`mthi_funct)
				||(instr_e[31:26]==`special&&instr_e[20:6]==0&&instr_e[5:0]==`mtlo_funct);
assign mdwsel=(instr_e[31:26]==`special&&instr_e[20:6]==0&&instr_e[5:0]==`mtlo_funct)?0:1;

//==========================mpipe=======================================================
Mpipe mpipe(.clk(clk),.clr(clr|intreq),
				.res_e(newres_e),.instr_e(instr_e),.v2_e(falube),.a2_e(a2_e),.ao_e(ao_e),.pc8_e(pc8_e),.a3_e(a3_e),.bd_e(bd_er),.exccode_e(exccode_er),
				.res_m(res_m),.instr_m(instr_m),.v2_m(v2_m),.a2_m(a2_m),.ao_m(ao_m),.pc8_m(pc8_m),.a3_m(a3_m),.bd_m(bd_ml),.exccode_m(exccode_ml));
//======================memory===========================================================
assign addrbus=ao_m;
assign wdbus=fdmm;
assign fdmm=(fdmmctrl==1)?regdata:v2_m;
wire [31:0] dmout;
wire [3:0] be;
Dmdecode dmdecode (.wordmode(wordmode_m),.addr(addrbus),.be(be)); 
DM dm(.clk(clk),.clr(clr),.we(memwrite&(~intreq)),.be(be),.addr(ao_m),.wd(fdmm),.dr(dmout));
Exc_m exc_m(.instr_m(instr_m),.ao_m(ao_m),.exccode_e(exccode_ml),.bd_e(bd_ml),.exccode_m(exccode),.bd_m(bd));
assign datam=(ismfc0)?cp0_rd:
				 (addrbus>=32'h00007f00&&addrbus<=32'h00007f0b||addrbus>=32'h00007f10&&addrbus<=32'h00007f1b)?bridge_rd:
				 (addrbus>=0&&addrbus<=32'h00002fff)?dmout:
				 32'h17230002;
assign dr_m= datam;
//--------------------------wpipe-------------------------------------------------------------
wire [31:0]dmold;
Wpipe wpipe(.clk(clk),.clr(clr|intreq),
				.res_m(res_m),.instr_m(instr_m),.ao_m(ao_m),.dr_m(dr_m),.pc8_m(pc8_m),.a3_m(a3_m),
				.res_w(res_w),.instr_w(instr_w),.ao_w(ao_w),.dr_w(dmold),.pc8_w(pc8_w),.a3_w(a3_w));
//============================writeback=========================================================
Dmcut dmcut(.dmout(dmold),.ao_w(ao_w),.dr_w(dr_w),.wordmode(wordmode_w));
assign regdata=(memtoreg==`memtoreg_ao)?ao_w:
					(memtoreg==`memtoreg_dr)?dr_w:
					pc8_w;
endmodule
