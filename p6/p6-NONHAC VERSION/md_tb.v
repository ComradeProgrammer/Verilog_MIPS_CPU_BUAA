`timescale 1ns / 1ps



module md_tb;

	// Inputs
	reg clk;
	reg clr;
	reg [31:0] a;
	reg [31:0] b;
	reg a1;
	reg start;
	reg [1:0] mode;
	reg we;

	// Outputs
	wire busy;
	wire [31:0] hi;
	wire [31:0] lo;

	// Instantiate the Unit Under Test (UUT)
	multdiv uut (
		.clk(clk), 
		.clr(clr), 
		.a(a), 
		.b(b), 
		.a1(a1), 
		.start(start), 
		.mode(mode), 
		.we(we), 
		.busy(busy), 
		.hi(hi), 
		.lo(lo)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		clr = 0;
		a = 0;
		b = 0;
		a1 = 0;
		start = 0;
		mode = 3;
		we = 0;
		#20 a=3;
			b=2;
			start=1;
		#10 start=0;
			a=0;
			b=0;
		#10 we=1;
		a=15;
		#10 we=0;a=0;
		#50 we=1;
		a=15;
		#100 $finish;

	end
   always #5 clk=~clk;  
endmodule

