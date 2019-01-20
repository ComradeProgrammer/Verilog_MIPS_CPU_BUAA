`timescale 1ns / 1ps

module NPC(pc4,extout,instr,rd1,npcop,npcout);
input [31:0] pc4,extout,instr,rd1;
input [1:0] npcop;
output [31:0] npcout;

wire [31:0]tmp[3:0];
wire [31:0]offset;
assign offset={extout[29:0],2'b00};
assign tmp[0]=pc4+offset;
assign tmp[1]={pc4[31:28],instr[25:0],2'b00};
assign tmp[2]=rd1;
assign npcout=tmp[npcop];
endmodule
