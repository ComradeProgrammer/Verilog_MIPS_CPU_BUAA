`timescale 1ns / 1ps
`include"head.v"
module Dmdecode(wordmode,addr,be);
input [31:0] addr;
input [2:0]wordmode;
output reg [3:0]be;

initial begin
	be<=0;
end

always @(*)
	begin
		if(wordmode==`wm_wd)
			be<=4'b1111;
		else if(wordmode==`wm_hu||wordmode==`wm_hs)
			begin
				be[0]<=(addr[1])==0?1:0;
				be[1]<=(addr[1])==0?1:0;
				be[2]<=(addr[1])==1?1:0;
				be[3]<=(addr[1])==1?1:0;
			end
		else if(wordmode==`wm_bu||wordmode==`wm_bs)
			begin
				be[0]<=(addr[1:0])==0?1:0;
				be[1]<=(addr[1:0])==1?1:0;
				be[2]<=(addr[1:0])==2?1:0;
				be[3]<=(addr[1:0])==3?1:0;
			end
	end

endmodule
