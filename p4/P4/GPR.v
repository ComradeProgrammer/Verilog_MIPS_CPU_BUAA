`timescale 1ns / 1ps

module GPR(clk,clr,we,a1,a2,a3,wd,rd1,rd2);
input clk,clr,we;
input [31:0] wd;
input [4:0] a1,a2,a3;
output [31:0] rd1,rd2;
reg[31:0] regmem[31:0];

integer i;
initial begin
	for(i=0;i<32;i=i+1)
		regmem[i]<=0;
end

always@(posedge clk)
	begin
		if(clr)
			begin
				for(i=0;i<31;i=i+1)
					regmem[i]<=0;
			end
		else
			begin
				if(we==1&&a3!=0)
					begin
						regmem[a3]<=wd;
						$display("@%h: $%d <= %h", im.pc,a3,wd);//output display,xian fang zhe li
					end
			end
	end

assign rd1=regmem[a1];
assign rd2=regmem[a2];

endmodule
