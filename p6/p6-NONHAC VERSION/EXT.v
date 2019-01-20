`timescale 1ns / 1ps

module EXT(imm,extop,extout);
input [15:0]imm;
input [1:0] extop;
output [31:0] extout;

wire [31:0]tmp[3:0];
assign tmp[0]={16'b0,imm};
assign tmp[1]={{16{imm[15]}},imm};
assign tmp[2]={imm,16'b0};
assign extout=tmp[extop];

endmodule
