`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:04:04 11/02/2023
// Design Name:   Splitter
// Module Name:   /home/co-eda/ISE_Projects/single_style_MIPS_CPU/Splitter_tb.v
// Project Name:  single_style_MIPS_CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Splitter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Splitter_tb;

	// Inputs
	reg [31:0] Instr;

	// Outputs
	wire [25:0] Addr26;
	wire [15:0] Imm16;
	wire [5:0] func;
	wire [4:0] Rd;
	wire [4:0] Rt;
	wire [4:0] Rs;
	wire [5:0] Op;

	// Instantiate the Unit Under Test (UUT)
	Splitter uut (
		.Instr(Instr), 
		.Addr26(Addr26), 
		.Imm16(Imm16), 
		.func(func), 
		.Rd(Rd), 
		.Rt(Rt), 
		.Rs(Rs), 
		.Op(Op)
	);

	initial begin
		// Initialize Inputs
		Instr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#2 Instr = 32'h3401_3456;
		#2 Instr = 32'h340b_1234;
		#2 Instr = 32'hac85_ffff;
	end
      
endmodule