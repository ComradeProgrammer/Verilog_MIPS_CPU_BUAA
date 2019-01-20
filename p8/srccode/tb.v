`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:47:03 12/25/2018
// Design Name:   mips
// Module Name:   E:/workspaces/ISE/p8_znameni/tb.v
// Project Name:  p8_znameni
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
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
	reg reset;
	reg rx;
	reg [7:0] dip_switch0;
	reg [7:0] dip_switch1;
	reg [7:0] dip_switch2;
	reg [7:0] dip_switch3;
	reg [7:0] dip_switch4;
	reg [7:0] dip_switch5;
	reg [7:0] dip_switch6;
	reg [7:0] dip_switch7;
	reg [7:0] user_key;

	// Outputs
	wire tx;
	wire [31:0] led_light;
	wire [7:0] digital_tube0;
	wire [7:0] digital_tube1;
	wire [7:0] digital_tube2;
	wire [3:0] sel0;
	wire [3:0] sel1;
	wire sel2;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk_in(clk), 
		.reset(reset), 
		.rx(tx), 
		.tx(tx), 
		.dip_switch0(dip_switch0), 
		.dip_switch1(dip_switch1), 
		.dip_switch2(dip_switch2), 
		.dip_switch3(dip_switch3), 
		.dip_switch4(dip_switch4), 
		.dip_switch5(dip_switch5), 
		.dip_switch6(dip_switch6), 
		.dip_switch7(dip_switch7), 
		.user_key(user_key), 
		.led_light(led_light), 
		.digital_tube0(digital_tube0), 
		.digital_tube1(digital_tube1), 
		.digital_tube2(digital_tube2), 
		.sel0(sel0), 
		.sel1(sel1), 
		.sel2(sel2)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		rx = 0;
		dip_switch0 = 8'hff;
		dip_switch1 = 8'hff;
		dip_switch2 = 8'hff;
		dip_switch3 = 8'hff;
		dip_switch4 = 8'hff;
		dip_switch5 = 8'hff;
		dip_switch6 = 8'hff;
		dip_switch7 = 8'hff;
		user_key = 0;

		// Wait 100 ns for global reset to finish
			#600 reset=0;
		dip_switch0 = ~(8'h04);
		
		
			
	end
	
	always #20 clk=~clk;
      
endmodule

