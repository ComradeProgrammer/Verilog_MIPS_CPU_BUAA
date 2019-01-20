`timescale 1ns / 1ps

module NPC(pc4,extout,instr,rd1,epc,npcop,intreq,npcout);
input [31:0] pc4,extout,instr,rd1,epc;
input [2:0] npcop;
input intreq;
output [31:0] npcout;

wire [31:0]tmp[7:0];
wire [31:0]offset,pc;
assign pc=pc4-4;
assign offset={extout[29:0],2'b00};

assign tmp[0]=pc4+offset;
assign tmp[1]={pc[31:28],instr[25:0],2'b00};
assign tmp[2]=rd1;
assign tmp[3]=32'h00004180;
assign tmp[4]=epc;
assign npcout=(intreq)?tmp[3]:
					tmp[npcop];
endmodule  
