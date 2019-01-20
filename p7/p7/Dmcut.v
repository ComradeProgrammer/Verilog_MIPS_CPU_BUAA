`timescale 1ns / 1ps
`include"head.v"
module Dmcut(dmout,ao_w,dr_w,wordmode);
input [31:0] dmout,ao_w;
input [2:0] wordmode;
output reg [31:0] dr_w;

initial begin
	dr_w=0;
end
wire [31:0] word[1:0];
assign word[0]=(ao_w[1]==1)?{16'b0,dmout[31:16]}:{16'b0,dmout[15:0]};
assign word[1]=(ao_w[1:0]==0)?{24'b0,dmout[7:0]}:
               (ao_w[1:0]==1)?{24'b0,dmout[15:8]}:
					(ao_w[1:0]==2)?{24'b0,dmout[23:16]}:
					{24'b0,dmout[31:24]};

always@(*)
	begin
		if(wordmode==`wm_wd)
			dr_w<=dmout;
		else if(wordmode==`wm_hs)
			dr_w<={{16{word[0][15]}},word[0][15:0]};
		else if(wordmode==`wm_hu)
			dr_w<={16'b0,word[0][15:0]};
		else if(wordmode==`wm_bs)
			dr_w<={{24{word[1][7]}},word[1][7:0]};
		else if(wordmode==`wm_bu)
			dr_w<={24'b0,word[1][7:0]};
		else dr_w<=32'h17231181;
	end


endmodule
