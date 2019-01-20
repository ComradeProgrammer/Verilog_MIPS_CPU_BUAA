`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:35:36 12/01/2018
// Design Name:   CPU
// Module Name:   E:/workspaces/ISE/formalp5/tb.v
// Project Name:  formalp5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg clk;
	reg clr;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.clk(clk), 
		.clr(clr)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		clr = 0;

		// Wait 100 ns for global reset to finish

        
		// Add stimulus here

	end
   always #5 clk=~clk;
endmodule

