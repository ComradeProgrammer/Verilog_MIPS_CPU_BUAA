`timescale 1ns / 1ps

module ALU(a,b,aluop,aluout);
input [31:0]a,b;
input [1:0] aluop;
output [31:0] aluout;

wire [31:0] tmp[3:0];
assign tmp[1]=a+b;
assign tmp[2]=a-b;
assign tmp[3]=a|b;
assign aluout=tmp[aluop];

endmodule
