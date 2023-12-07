`timescale 1ns / 1ps
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_and 4'b0010
`define ALU_or 4'b0011
`define ALU_lui 4'b0100
`define ALU_jal 4'b0101
`define ALU_slt 4'b0110
`define ALU_sltu 4'b0111

module E_ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [31:0] pc4,
    input [3:0] ALUop,
    output [31:0] Result
);
    reg [31:0] slt_temp, sltu_temp;
    reg temp;
    always @(*) begin
        if (ALUop == `ALU_slt) begin
            temp = $signed(srcA) < $signed(srcB);
            slt_temp = {31'b0, temp};
        end
        else if (ALUop == `ALU_sltu) begin
            temp = srcA < srcB;
            sltu_temp = {31'b0, temp};
        end
    end

    assign Result = (ALUop == `ALU_add) ? srcA + srcB :
                    (ALUop == `ALU_sub) ? srcA - srcB :
                    (ALUop == `ALU_and) ? srcA & srcB :
                    (ALUop == `ALU_or) ? srcA | srcB :
                    (ALUop == `ALU_lui) ? srcB << 16 :                  // lui
                    (ALUop == `ALU_jal) ? pc4 + 32'h0000_0004 :         // jal
                    (ALUop == `ALU_slt) ? slt_temp :
                    (ALUop == `ALU_sltu) ? sltu_temp :
                    32'h0000_0000;
endmodule //ALU
