`timescale 1ns / 1ps
`define Op 31:26
`define Rs 25:21
`define Rt 20:16
`define Rd 15:11
`define func 5:0
`define Imm16 15:0
`define Addr26 25:0
module D_Splitter(
    input [31:0] Instr,
    output [25:0] Addr26,
    output [15:0] Imm16,
    output [5:0] func,
    output [4:0] Rd,
    output [4:0] Rt,
    output [4:0] Rs,
    output [5:0] Op
);
    assign Addr26 = Instr[`Addr26];
    assign Imm16 = Instr[`Imm16];
    assign func = Instr[`func];
    assign Rd = Instr[`Rd];
    assign Rt = Instr[`Rt];
    assign Rs = Instr[`Rs];
    assign Op = Instr[`Op];
endmodule //Splitter
