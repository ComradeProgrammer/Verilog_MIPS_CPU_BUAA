`timescale 1ns / 1ps

module GRF(clk,clr,we,a1,a2,a3,wd,rd1,rd2);


input clk,clr,we;
input [31:0] wd;
input [4:0] a1,a2,a3;
output [31:0] rd1,rd2;
reg[31:0] regmem[31:0];

integer i;
initial begin
	for(i=0;i<32;i=i+1)
		regmem[i]<=0;

end

always@(posedge clk)
	begin
		if(clr)
			for(i=0;i<31;i=i+1)
				regmem[i]<=0;
		else if(we==1&&a3!=0)
			begin
				regmem[a3]<=wd;
				$display("%d@%h: $%d <= %h",$time, datapath.pc8_w-8,a3,wd);//FUCKHERE
			end
	end

assign rd1=(a1==a3&&we==1&&a1!=0)?wd:regmem[a1];
assign rd2=(a2==a3&&we==1&&a2!=0)?wd:regmem[a2];
endmodule
