`timescale 1ns / 1ps

module counter_tb;

	// Inputs
	reg Clk;
	reg Reset;
	reg Slt;
	reg En;

	// Outputs
	wire [63:0] Output0;
	wire [63:0] Output1;

	// Instantiate the Unit Under Test (UUT)
	code uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.Slt(Slt), 
		.En(En), 
		.Output0(Output0), 
		.Output1(Output1)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 0;
		Slt = 0;
		En = 0;

		// Wait 100 ns for global reset to finish
		#5 En = 1'b1;

        #50;

        #5 Slt = 1'b1;

        #50;

        Reset = 1'b1;

        #5;

        Slt = 1'b0;
        
		// Add stimulus here

	end

    always #5 Clk = ~Clk;

endmodule

