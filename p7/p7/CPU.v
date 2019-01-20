`timescale 1ns / 1ps
`include"head.v"
module CPU(clk,clr,
				bridge_we,addrbus,wdbus,ismtc0,exlclr,cp0dst,pc8_m,bd,exccode,
				bridge_rd,cp0_rd,intreq,cp0_epc);
input clk,clr;
//-------------for the fucking p6------------------------------------------
output [31:0] addrbus,wdbus,pc8_m;
output bridge_we,ismtc0,exlclr,bd;
output [4:0] cp0dst,exccode;
input [31:0] bridge_rd,cp0_rd,cp0_epc;
input intreq;
wire [2:0]fepcctrl;
wire ismtc0,ismfc0,dm_we;

//-------------for the glory of original hac-------------------------------
wire [31:0] instr_d,instr_e,instr_m,instr_w;
wire [39:0] abus;
wire [8:0] resbus;
wire stall,isbeq,isbne,usemd,start;
wire [12:0] forwardbus;
wire [2:0]res_d,npcop,wordmode_m,wordmode_w;
wire branch,memwrite,regwrite;
wire [1:0] extop,regdst,otherctrl,memtoreg,alusrc,tuse_rs,tuse_rt,mdop;
wire [4:0] aluop;

assign dm_we=(addrbus>=0&&addrbus<=32'h00002fff&&memwrite==1)?1:0;
assign bridge_we=(((addrbus>=32'h00007f00&&addrbus<=32'h00007f07)||(addrbus>=32'h00007f10&&addrbus<=32'h00007f17))&&memwrite==1)?1:0;
assign exlclr=(instr_m==`eret);
assign fepcctrl=(instr_e[31:26]==`cop0&&instr_e[25:21]==`mtc0_rs&&instr_e[15:11]==14)?`fepc_e:
					 (instr_m[31:26]==`cop0&&instr_m[25:21]==`mtc0_rs&&instr_m[15:11]==14)?`fepc_m:
					 `fepc_cp0;
Datapath datapath (.clk(clk),.clr(clr),.stall(stall),.abus(abus),.resbus(resbus),.forwardbus(forwardbus),.res_d(res_d),
						.branch(branch),.npcop(npcop),.extop(extop),.regdst(regdst),.otherctrl(otherctrl),.aluop(aluop),.alusrc(alusrc),
						.memwrite(dm_we),.memtoreg(memtoreg),.regwrite(regwrite),.isbeq(isbeq),
						.instr_d(instr_d),.instr_e(instr_e),.instr_m(instr_m),.instr_w(instr_w),
						//=========for the p6======================
						.addrbus(addrbus),.wdbus(wdbus),.bridge_rd(bridge_rd),.cp0_rd(cp0_rd),.cp0_epc(cp0_epc),.intreq(intreq),
						.bd(bd),.exccode(exccode),.ismfc0(ismfc0),.fepcctrl(fepcctrl),.cp0dst(cp0dst),.pc8_m(pc8_m),
						//==========for the fucking p7
						.wordmode_m(wordmode_m),.wordmode_w(wordmode_w),.usemd(usemd),.start(start),.mdop(mdop),.isbne(isbne));

FORWARD forward(abus,resbus,forwardbus);
STALL st(tuse_rs,tuse_rt,resbus,abus,stall);
AT at(instr_d,tuse_rs,tuse_rt,res_d);

CTRL ctrld(.instr(instr_d),
				.branch(branch),.npcop(npcop),.extop(extop),.regdst(regdst),
				.otherctrl(otherctrl),.isbeq(isbeq),.usemd(usemd),.isbne(isbne));
CTRL ctrle(.instr(instr_e),
				.aluop(aluop),.alusrc(alusrc),.start(start),.mdop(mdop));
CTRL ctrlm(.instr(instr_m),
				.memwrite(memwrite),.ismfc0(ismfc0),.ismtc0(ismtc0),.wordmode(wordmode_m));
CTRL ctrlw(.instr(instr_w),
				.memtoreg(memtoreg),.regwrite(regwrite),.wordmode(wordmode_w));

endmodule
