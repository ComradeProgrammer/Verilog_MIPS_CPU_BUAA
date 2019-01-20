`timescale 1ns / 1ps

module ALU(a,b,aluop,ao);
input [31:0] a,b;
input [2:0] aluop;
output [31:0] ao;//เปฃก

wire [31:0] tmp[3:0];
assign tmp[0]=b;
assign tmp[1]=a+b;
assign tmp[2]=a-b;
assign tmp[3]=a|b;
assign ao=tmp[aluop]; 

endmodule
