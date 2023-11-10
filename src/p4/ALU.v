module ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [2:0] ALUop,
    output Zero, 
    output [31:0] Result
);
    assign Result = (ALUop == 3'b000) ? srcA + srcB :
                    (ALUop == 3'b001) ? srcA - srcB :
                    (ALUop == 3'b010) ? srcA & srcB :
                    (ALUop == 3'b011) ? srcA | srcB :
                    32'h0000_0000;
    assign Zero = (Result == 32'h0000_0000) ? 1 : 0;
endmodule //ALU
