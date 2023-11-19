`timescale 1ns / 1ps

`define Op 31:26
`define Rs 25:21
`define Rt 20:16
`define Rd 15:11
`define func 5:0
`define Imm16 15:0
`define Addr26 25:0

`define R 6'b000000
`define ADD 6'b100000
`define SUB 6'b100010
`define JR 6'b001000
`define NOP 6'b000000

`define ORI 6'b001101
`define LW 6'b100011
`define SW 6'b101011
`define BEQ 6'b000100
`define LUI 6'b001111
`define JAL 6'b000011

module G_ClassifyUnit(
    input [31:0] Instr,
    output load,
    output store,
    output cal_r,
    output cal_i,
    output branch,  // beq
    output lui,
    output j_r,     // jr,  
    output j_addr   // jal
);
    wire [5:0] op = Instr[`Op];
    wire [5:0] func = Instr[`func];

    /// cal_r
    wire add = (op == `R && func == `ADD);
    wire sub = (op == `R && func == `SUB);

    /// cal_i
    wire ori = (op == `ORI);

    /// lui
    assign lui = (op == `LUI);

    /// load
    wire lw = (op == `LW);

    /// store
    wire sw = (op == `SW);

    /// branch
    wire beq = (op == `BEQ);

    /// j_r
    wire jr = (op == `R && func == `JR);

    /// j_addr
    wire jal = (op == `JAL);


    assign cal_r = add | sub;
    assign cal_i = ori;
    assign load = lw;
    assign store = sw;
    assign branch = beq;
    assign j_r = jr;
    assign j_addr = jal;

endmodule //ClassifyUnit
