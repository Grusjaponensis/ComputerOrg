module ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [1:0] ALUop,
    output Zero, 
    output [31:0] Result
);
    assign Result = (ALUop == 2'b00) ? srcA + srcB :
                    (ALUop == 2'b01) ? srcA - srcB :
                    (ALUop == 2'b10) ? srcA & srcB :
                    (ALUop == 2'b11) ? srcA | srcB :
                    32'h0000_0000;
    assign Zero = (Result == 32'h0000_0000) ? 1 : 0;
endmodule //ALU
