`timescale 1ns / 1ps

module IM(clk,clr,branch,npc,instr,pc4);
input clk,clr,branch;
input [31:0] npc;
output [31:0] instr,pc4;

reg [31:0]pc;
reg [31:0] inmem[1023:0];
integer i;

wire [31:0]pointer;
initial begin
	for(i=0;i<1024;i=i+1)
		inmem[i]=0;
	pc=32'h0003000;
	$readmemh("code.txt",inmem,0,1023);
end



always @(posedge clk)
	begin
		if(clr)
			begin
				for(i=0;i<1024;i=i+1)
					inmem[i]=0;
				$readmemh("code.txt",inmem,0,1023);
				pc<=32'h00003000;
			end
		else
			begin
				if(branch==1)
					pc<=npc;
				else
					pc<=pc+4;
			end
	end
	
assign pc4=pc+4;
assign pointer=pc-32'h00003000;
assign instr=inmem[pointer[31:2]];
	
endmodule
