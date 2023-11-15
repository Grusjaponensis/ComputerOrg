`timescale 1ns / 1ps
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_and 4'b0010
`define ALU_or 4'b0011
`define ALU_lui 4'b0100

module E_ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [3:0] ALUop,
    output [31:0] Result
);
    assign Result = (ALUop == `ALU_add) ? srcA + srcB :
                    (ALUop == `ALU_sub) ? srcA - srcB :
                    (ALUop == `ALU_and) ? srcA & srcB :
                    (ALUop == `ALU_or) ? srcA | srcB :
                    (ALUop == `ALU_lui) ? srcB << 16 :      // lui
                    32'h0000_0000;
endmodule //ALU
