`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:08:59 11/02/2023
// Design Name:   Extender
// Module Name:   /home/co-eda/ISE_Projects/single_style_MIPS_CPU/Extender_tb.v
// Project Name:  single_style_MIPS_CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Extender
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Extender_tb;

	// Inputs
	reg [15:0] Imm16;
	reg ExtRes;

	// Outputs
	wire [31:0] ExtResult;

	// Instantiate the Unit Under Test (UUT)
	Extender uut (
		.Imm16(Imm16), 
		.ExtRes(ExtRes), 
		.ExtResult(ExtResult)
	);

	initial begin
		// Initialize Inputs
		Imm16 = 0;
		ExtRes = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#2 ExtRes = 1'b0;
		#2 Imm16 = 16'h1234;
		#2 Imm16 = 16'h3456;
		#2 Imm16 = 16'hffff;
		#2 ExtRes = 1'b1;
		#2 Imm16 = 16'hffff;
	end
      
endmodule