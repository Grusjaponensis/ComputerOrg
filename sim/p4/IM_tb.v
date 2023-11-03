`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:54:55 11/02/2023
// Design Name:   IM
// Module Name:   /home/co-eda/ISE_Projects/single_style_MIPS_CPU/IM_tb.v
// Project Name:  single_style_MIPS_CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module IM_tb;

	// Inputs
	reg [11:0] InstrAddr;

	// Outputs
	wire [31:0] Instr;

	// Instantiate the Unit Under Test (UUT)
	IM uut (
		.InstrAddr(InstrAddr), 
		.Instr(Instr)
	);

	initial begin
		// Initialize Inputs
		InstrAddr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        #2 InstrAddr = 12'b0000_0000_0000;
		#2 InstrAddr = 12'b0000_0000_0001;
		#2 InstrAddr = 12'b0000_0000_0010;
		#2 InstrAddr = 12'b0000_0000_0011;
		// Add stimulus here

	end
   
endmodule