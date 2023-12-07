`timescale 1ns / 1ps

`define Op 31:26
`define func 5:0

`define R 6'b000000
`define ADD 6'b100000
`define SUB 6'b100010
`define AND 6'b100100
`define OR 6'b100101
`define SLT 6'b101010
`define SLTU 6'b101011
`define MULT 6'b011000
`define MULTU 6'b011001
`define DIV 6'b011010
`define DIVU 6'b011011
`define MFHI 6'b010000
`define MFLO 6'b010010
`define MTHI 6'b010001
`define MTLO 6'b010011
`define JR 6'b001000
`define NOP 6'b000000

`define ORI 6'b001101
`define ADDI 6'b001000
`define ANDI 6'b001100
`define LUI 6'b001111
`define LB 6'b100000
`define LH 6'b100001
`define LW 6'b100011
`define SB 6'b101000
`define SH 6'b101001
`define SW 6'b101011
`define BEQ 6'b000100
`define BNE 6'b000101
`define JAL 6'b000011

module G_ClassifyUnit(
    input [31:0] Instr,
    output load,
    output store,
    output cal_r,
    output cal_i,
    output branch,  // beq, bne
    output lui,
    output j_r,     // jr,
    output j_addr,  // jal
    output md,
    output mt,
    output mf
);
    wire [5:0] op = Instr[`Op];
    wire [5:0] func = Instr[`func];

    /// cal_r
    wire add = (op == `R && func == `ADD);
    wire sub = (op == `R && func == `SUB);
    wire _and = (op == `R && func == `AND);
    wire _or = (op == `R && func == `OR);
    wire slt = (op == `R && func == `SLT);
    wire sltu = (op == `R && func == `SLTU);
    wire mult = (op == `R && func == `MULT);
    wire multu = (op == `R && func == `MULTU);
    wire div = (op == `R && func == `DIV);
    wire divu = (op == `R && func == `DIVU);
    wire mfhi = (op == `R && func == `MFHI);
    wire mflo = (op == `R && func == `MFLO);
    wire mthi = (op == `R && func == `MTHI);
    wire mtlo = (op == `R && func == `MTLO);

    /// cal_i
    wire ori = (op == `ORI);
    wire andi = (op == `ANDI);
    wire addi = (op == `ADDI);
    
    /// lui
    assign lui = (op == `LUI);

    /// load
    wire lw = (op == `LW);
    wire lb = (op == `LB);
    wire lh = (op == `LH);

    /// store
    wire sw = (op == `SW);
    wire sb = (op == `SB);
    wire sh = (op == `SH);

    /// branch
    wire beq = (op == `BEQ);
    wire bne = (op == `BNE);

    /// j_r
    wire jr = (op == `R && func == `JR);

    /// j_addr
    wire jal = (op == `JAL);

    assign cal_r = add | sub | _and | _or | slt | sltu;
    assign cal_i = andi | ori | addi | lui;
    assign load = lw | lh | lb;
    assign store = sw | sh | sb;
    assign branch = beq | bne;
    assign j_r = jr;
    assign j_addr = jal;
    assign md = mult | multu | div | divu;
    assign mt = mthi | mtlo;
    assign mf = mfhi | mflo;

endmodule //ClassifyUnit
