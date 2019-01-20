`timescale 1ns / 1ps



module dmtb;

	// Inputs
	reg clk;
	reg clr;
	reg [3:0] be;
	reg we;
	reg [31:0] addr;
	reg [31:0] wd;

	// Outputs
	wire [31:0] dr;

	// Instantiate the Unit Under Test (UUT)
	DM uut (
		.clk(clk), 
		.clr(clr), 
		.be(be), 
		.we(we), 
		.addr(addr), 
		.wd(wd), 
		.dr(dr)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		clr = 0;
		be = 4'b1000;
		we = 1;
		addr = 11;
		wd = 32'habcd1234;
		#20 
		be = 0;
		we = 0;
		addr = 0;
		wd = 32'habcd1234;

        
		// Add stimulus here

	end
  always #5 clk=~clk;  
endmodule

