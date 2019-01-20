`timescale 1ns / 1ps
module CPU(clk,clr);
input clk,clr;

wire [31:0] instr_d,instr_e,instr_m,instr_w;
wire [39:0] abus;
wire [8:0] resbus;
wire stall,isbeq,isbne;
wire [12:0] forwardbus;
wire [2:0]res_d;
wire branch,memwrite,regwrite,usemd,start;
wire [1:0] npcop,extop,regdst,otherctrl,memtoreg,alusrc,mdop;
wire  [2:0] wordmode_m,wordmode_w;
wire [3:0]aluop;
wire [1:0] tuse_rs,tuse_rt;
Datapath datapath (.clk(clk),.clr(clr),.stall(stall),.abus(abus),.resbus(resbus),.forwardbus(forwardbus),.res_d(res_d),
						.branch(branch),.npcop(npcop),.extop(extop),.regdst(regdst),.otherctrl(otherctrl),.aluop(aluop),.alusrc(alusrc),.memwrite(memwrite),.memtoreg(memtoreg),.regwrite(regwrite),.isbeq(isbeq),
						.instr_d(instr_d),.instr_e(instr_e),.instr_m(instr_m),.instr_w(instr_w),.mdop(mdop),.start(start),.usemd(usemd),.wordmode_m(wordmode_m),.wordmode_w(wordmode_w),.isbne(isbne));

FORWARD forward(abus,resbus,forwardbus);
STALL st(tuse_rs,tuse_rt,resbus,abus,stall);
AT at(instr_d,tuse_rs,tuse_rt,res_d);

CTRL ctrld(.instr(instr_d),
				.branch(branch),.npcop(npcop),.extop(extop),.regdst(regdst),
				.otherctrl(otherctrl),.isbeq(isbeq),.usemd(usemd),.isbne(isbne));
CTRL ctrle(.instr(instr_e),
				.aluop(aluop),.alusrc(alusrc),.mdop(mdop),.start(start));
CTRL ctrlm(.instr(instr_m),
				.memwrite(memwrite),.wordmode(wordmode_m));
CTRL ctrlw(.instr(instr_w),
				.memtoreg(memtoreg),.regwrite(regwrite),.wordmode(wordmode_w));

endmodule
