`timescale 1ns / 1ps
module IFU (clk,clr,stall,branch,npcout,instr,pc8);
input clk,clr,stall,branch;
input [31:0] npcout;
output [31:0] instr,pc8;

reg [31:0] inmem[1023:0];
reg [31:0]pc;

integer i;
initial begin
	for(i=0;i<1024;i=i+1)
		inmem[i]=32'b0;
	pc=32'h00003000;
	$readmemh("code.txt",inmem);
end

always @(posedge clk)
begin
	if (clr)
		pc<=32'h00003000;
	else if(stall)
		pc<=pc;
	else if (branch)
		pc<=npcout;
	else
		pc<=pc+4;
end

assign instr=inmem[pc[11:2]];
assign pc8=pc+8;
endmodule 