`timescale 1ns / 1ps

module mips(clk,reset);
input clk;
input reset;


wire branch,regwrite,memwrite,isbeq,alusrc,hf,bt,issll,issra,issrl,v;
wire [1:0] npcop,extop,aluop,regdst;
wire [2:0] memtoreg;
wire [31:0] instr;

ctrl control(.instr(instr),
.branch(branch),.regwrite(regwrite),.memwrite(memwrite),.npcop(npcop),.extop(extop),.aluop(aluop),.alusrc(alusrc),
.regdst(regdst),.memtoreg(memtoreg),
.isbeq(isbeq),.hf(hf),.bt(bt),
.isbgtz(isbgtz),.isbgez(isbgez),.isbltz(isbltz),.isblez(isblez),
.issll(issll),.issra(issra),.issrl(issrl),.v(v));

DATAPATH datapath(.clk(clk),.clr(reset),
.branch(branch),.regwrite(regwrite),.memwrite(memwrite),.npcop(npcop),.extop(extop),.aluop(aluop),.alusrc(alusrc),
.regdst(regdst),.memtoreg(memtoreg),
.isbeq(isbeq),
.instr(instr),.hf(hf),.bt(bt),
.isbgtz(isbgtz),.isbgez(isbgez),.isbltz(isbltz),.isblez(isblez),
.issll(issll),.issra(issra),.issrl(issrl),.v(v));

endmodule
