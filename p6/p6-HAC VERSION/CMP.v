`timescale 1ns / 1ps

module CMP(a,b,cmpout);
input [31:0]a,b;
output [31:0] cmpout;
assign cmpout=(a==b)?32'h1:32'h0;

endmodule
