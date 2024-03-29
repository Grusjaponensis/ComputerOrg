`timescale 1ns / 1ps
`define No_Branch 3'b000
`define Beq_Branch 3'b001
`define Jal_Jump 3'b010
`define Jr_Jump 3'b011

module D_NPC(
    input [31:0] Pc4_F,
    input [31:0] Pc4,
    input [25:0] Addr26,
    input [31:0] sign_ext_offset,       // beq
    input [31:0] RF_RD1,
    input [2:0] SelPCsrc,
    input CmpResult,
    output [31:0] next_PC
);
    assign next_PC = (SelPCsrc == `No_Branch) ? Pc4_F :
                     (SelPCsrc == `Beq_Branch && CmpResult == 1'b1) ? (Pc4 + (sign_ext_offset << 2)) :
                     (SelPCsrc == `Jal_Jump) ? {Pc4[31:28], Addr26, {2{1'b0}}} :
                     (SelPCsrc == `Jr_Jump) ? RF_RD1 :
                     Pc4_F;
endmodule //NPC
