`timescale 1ns / 1ps
module shift(rd2,rd1,shamt,issll,issrl,issra,v,shiftout);
input [31:0] rd2,rd1;
input [4:0] shamt;
input issra,issrl,issll,v;
output [31:0] shiftout;

wire [31:0]tmp[2:0];
wire [31:0]tmpv[2:0];
wire [4:0]shiftbit;
wire [31:0] out,outv;
assign shiftbit=rd1[4:0];

assign tmp[0]=rd2<<$unsigned(shamt);//sll
assign tmp[1]=$signed(rd2)>>$unsigned(shamt);//srl
assign tmp[2]=$signed(rd2)>>>$unsigned(shamt);//sra
assign out=(issll)?tmp[0]:
						(issrl)?tmp[1]:
						(issra)?tmp[2]:
						32'bz;
assign tmpv[0]=rd2<<$unsigned(shiftbit);
assign tmpv[1]=$signed(rd2)>>$unsigned(shiftbit);
assign tmpv[2]=$signed(rd2)>>>$unsigned(shiftbit);
assign outv=(issll)?tmpv[0]:
						(issrl)?tmpv[1]:
						(issra)?tmpv[2]:
						32'bz;
assign shiftout=v?outv:out;

endmodule
