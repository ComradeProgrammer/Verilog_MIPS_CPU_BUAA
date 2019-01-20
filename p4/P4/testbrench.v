`timescale 1ns / 1ps



module testbrench;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		#1 reset=1;
		#10
		reset=0;

	end
	always #5 clk=~clk;
      
endmodule

