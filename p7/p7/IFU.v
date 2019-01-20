`timescale 1ns / 1ps
module IFU (clk,clr,stall,branch,intreq,npcout,instr,pc8);
input clk,clr,stall,branch,intreq;
input [31:0] npcout;
output [31:0] instr,pc8;

reg [31:0] inmem[4095:0];
reg [31:0]pc;

integer i;
initial begin
	for(i=0;i<4096;i=i+1)
		inmem[i]=0;
	pc=32'h00003000;
	$readmemh("code.txt",inmem);
	$readmemh("code_handler.txt",inmem,1120,2047);
end

always @(posedge clk)
begin
	if (clr)
		pc<=32'h00003000;
	else if (intreq)
		pc<=npcout;
	else if(stall)
		pc<=pc;
	else if(branch)
		pc<=npcout;

	else
		pc<=pc+4;
end
wire [31:0] add=pc-32'h00003000;
assign instr=inmem[add[31:2]];
assign pc8=pc+8;
endmodule 