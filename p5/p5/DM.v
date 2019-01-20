`timescale 1ns / 1ps

module DM(clk,clr,we,addr,wd,dr);
input clk,clr,we;
input [31:0] addr,wd;
output [31:0]dr;

reg [31:0] dmmem[1023:0];
integer i;

initial begin
	for(i=0;i<1024;i=i+1)
		dmmem[i]<=0;
end

always@(posedge clk)
	begin
		if(clr)
			begin
				for(i=0;i<1024;i=i+1)
					dmmem[i]<=0;
			end
		else
			begin
				if(we)
					begin
						dmmem[addr[11:2]]<=wd;
						$display("%d@%h: *%h <= %h",$time,datapath.pc8_m-8, addr,wd);//xian fang zheli
					end
			end
	end

assign dr=dmmem[addr[11:2]];
endmodule
