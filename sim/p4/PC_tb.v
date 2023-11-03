`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:41:49 11/02/2023
// Design Name:   PC
// Module Name:   /home/co-eda/ISE_Projects/single_style_MIPS_CPU/PC_tb.v
// Project Name:  single_style_MIPS_CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PC_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] next_PC;

	// Outputs
	wire [31:0] PC;
	wire [11:0] InstrAddr;

	// Instantiate the Unit Under Test (UUT)
	PC uut (
		.clk(clk), 
		.reset(reset), 
		.next_PC(next_PC), 
		.PC(PC), 
		.InstrAddr(InstrAddr)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		next_PC = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#2 next_PC = 32'h0000_3000;
		#2 next_PC = 32'h0000_3004;
		#2 reset = 1'b1;
		#2 next_PC = 32'h0000_3008;
		#2 reset = 1'b0;
		#2 next_PC = 32'h0000_300c;
	end
    always #1 clk = ~clk;
endmodule