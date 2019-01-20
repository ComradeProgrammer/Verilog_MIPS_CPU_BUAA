`timescale 1ns / 1ps
`define ip cause[15:10]
`define exccode cause[6:2]
`define bd cause[31]
`define im sr[15:10]
`define exl sr[1]
`define ie sr[0]

module CP0(clk,clr,a1,a2,wdbus,pc8_m,bdin,hwint,exccodein,we,exlclr,cp0_rd,cp0_epc,intreq);
input [4:0] a1,a2,exccodein;
input [31:0] wdbus,pc8_m;
input clk,clr, bdin,we,exlclr;
input [5:0] hwint; 
output [31:0] cp0_rd,cp0_epc;
output intreq;

reg [31:0] cause,sr,epc,prid;
wire hwreq;
assign hwreq=(|(`im&hwint))&`ie&(~`exl);
assign intreq=hwreq|(exccodein!=0&&`exl==0);
assign cp0_rd=(a1==12)?sr:
					(a1==13)?cause:
					(a1==14)?epc:
					(a1==15)?prid:
					32'h17230001;
assign cp0_epc=epc;
/*initial begin
	epc=0; cause=0;prid=32'h17231181;sr=0;
	`im=6'b000000; `ie=0;`exl=0;
end
*/
wire [31:0] pc8_mc;
assign pc8_mc={pc8_m[31:2],2'b0};
always@(posedge clk)
	begin
		if(clr)
			begin
				epc<=0; cause<=0;prid<=32'h17231181;
				//`im<=6'b111111; `ie<=1;
				sr<={16'b0,6'b000011,8'b0,2'b01};
			end
		else if(hwreq)
			begin
				`exl<=1; `bd<=bdin; `ip<=hwint;`exccode<=0;
				epc<=(bdin==1)?pc8_mc-12:pc8_mc-8;
			end
		else if(exccodein!=0&&`exl==0)
			begin
				`exl<=1; `bd<=bdin; `ip<=hwint; `exccode<=exccodein;
				epc<=(bdin==1)?pc8_mc-12:pc8_mc-8;
			end
		else if(exlclr)
			begin
				`ip<=hwint;`exl<=0;
			end
		else if(we)
			begin
				`ip<=hwint;
				if(a2==12)
					sr<=wdbus;
				else if(a2==14)
					epc<=wdbus;
				else if(a2==15)
					prid<=wdbus;
			end
		else if(`exl==0)
			`ip<=hwint;
		else
			begin
				cause<=cause;
				epc<=epc;
				sr<=sr;
			end
	end

endmodule
