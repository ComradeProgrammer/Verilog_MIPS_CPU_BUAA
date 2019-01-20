`timescale 1ns / 1ps
module IFU (clk,clk2,clr,stall,branch,intreq,npcout,instr,pc8);
input clk,clk2,clr,stall,branch,intreq;
input [31:0] npcout;
output [31:0] instr,pc8;

reg [31:0]pc;
wire [31:0] add=pc-32'h00003000;
DM4K dm4k (
  .clka(clk2), // input clka
   .wea(4'b0000),// input [3 : 0] wea
  .addra(add[14:2]), // input [12 : 0] addra
   .dina(32'h00000000),// input [31 : 0] dina
  .douta(instr) // output [31 : 0] douta
);

always @(posedge clk)
begin
	if (clr)
		pc<=32'h00003000;
	else if (intreq)
		pc<=npcout;
	else if(stall)
		pc<=pc;
	else if(branch)
		pc<=npcout;

	else
		pc<=pc+4;
end


assign pc8=pc+8;
endmodule 