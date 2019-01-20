`timescale 1ns / 1ps

module DM(clk,clr,be,we,addr,wd,dr);
input clk,clr,we;
input [31:0] addr,wd;
input [3:0] be;
output [31:0]dr;

reg [31:0] dmmem[4095:0];
integer i;
wire [31:0] word;
reg [31:0] newword;
assign word=dmmem[addr[11:2]];
always@(*)
begin
	if(be==4'b1111)
		newword<=wd;
	else if(be==4'b0011)
		begin
			newword[31:16]<=word[31:16];
			newword[15:0]<=wd[15:0];
		end
	else if(be==4'b1100)
		begin
			newword[31:16]<=wd[15:0];
			newword[15:0]<=word[15:0];
		end
	else if(be==4'b0001)
		begin
			newword=word;
			newword[7:0]<=wd[7:0];
		end
	else if(be==4'b0010)
		begin
			newword=word;
			newword[15:8]<=wd[7:0];
		end
	else if(be==4'b0100)
		begin
			newword=word;
			newword[23:16]<=wd[7:0];
		end
	else if(be==4'b1000)
		begin
			newword=word;
			newword[31:24]<=wd[7:0];
		end
end

initial begin
	for(i=0;i<1024;i=i+1)
		dmmem[i]<=0;
end

always@(posedge clk)
	begin
		if(clr)
			begin
				for(i=0;i<1024;i=i+1)
					dmmem[i]<=0;
			end
		else
			begin
				if(we)
					begin
						dmmem[addr[11:2]]<=newword;
						$display("%d@%h: *%h <= %h",$time,datapath.pc8_m-8, {addr[31:2],2'b0},newword);//xian fang zheli
					end
			end
	end

assign dr=dmmem[addr[11:2]];
endmodule
