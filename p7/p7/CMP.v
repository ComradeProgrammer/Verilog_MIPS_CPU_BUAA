`timescale 1ns / 1ps

module CMP(a,b,cmpout,lez,ltz,gtz,gez);
input [31:0]a,b;
output [31:0] cmpout;
output lez,ltz,gtz,gez;
assign cmpout=(a==b)?32'h1:32'h0;
assign lez=$signed(a)<=0;
assign ltz=$signed(a)<0;
assign gtz=$signed(a)>0;
assign gez=$signed(a)>=0;
endmodule
