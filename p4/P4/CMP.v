`timescale 1ns / 1ps

module CMP(a,b,zero32,gtz32,gez32,ltz32,lez32);
input [31:0]a,b;
output [31:0] zero32,gtz32,gez32,ltz32,lez32;

assign zero32=(a==b)?32'h1:32'h0;

assign gtz32=($signed(a)>$signed(b))?32'b1:32'b0;
assign gez32=($signed(a)>=$signed(b))?32'b1:32'b0;
assign ltz32=($signed(a)<$signed(b))?32'b1:32'b0;
assign lez32=($signed(a)<=$signed(b))?32'b1:32'b0;

endmodule
