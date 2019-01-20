`timescale 1ns / 1ps
module userkeydriver(clk,clr,user_key,userkey_rd,userkey_int);
input [7:0] user_key;
input clk,clr;
output[31:0] userkey_rd;
output reg userkey_int;

assign userkey_rd={24'b0,~user_key};
reg [7:0] keyold;
always @(posedge clk)
	begin
		if(clr)
			begin
				userkey_int<=0;
				keyold<=0;
			end
		else 
			begin
				keyold<=user_key;
				if (keyold==user_key)
					userkey_int<=0;
				else
			     userkey_int<=1;
			end
	end


endmodule
