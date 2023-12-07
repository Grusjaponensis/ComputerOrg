`timescale 1ns / 1ps
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

//////////// ALUop //////////
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_and 4'b0010
`define ALU_or 4'b0011
`define ALU_lui 4'b0100
`define ALU_jal 4'b0101
`define ALU_slt 4'b0110
`define ALU_sltu 4'b0111

//////////// HILORegWriteEN //////////
`define HL_NoWrite 4'b0000
`define HL_Mult 4'b0001
`define HL_Multu 4'b0010
`define HL_Div 4'b0011
`define HL_Divu 4'b0100
`define HL_Mthi 4'b0101
`define HL_Mtlo 4'b0110
`define HL_Mfhi 4'b0111
`define HL_Mflo 4'b1000

//////////// SelALUResult //////////
`define HL_Result 1'b1
`define ALU_Result 1'b0

/////////// SelExtRes //////////
`define EXT_sign 1'b0
`define EXT_zero 1'b1

/////////// SelALUsrc //////////
`define Rt_Data 1'b0
`define Ext_Data 1'b1

//////////// SelRegDst /////////
`define RF_rt 3'b000
`define RF_rd 3'b001
`define RF_ra 3'b010

//////////// DMReadEN /////////
`define DM_lw 3'b001
`define DM_lh 3'b010
`define DM_lb 3'b011

//////////// DMWriteEN /////////
`define DM_sw 3'b001
`define DM_sh 3'b010
`define DM_sb 3'b011

/////////// SelRegWD ////////
`define DM_Data 4'b0000
`define ALU_Data 4'b0001
`define PC_Data 4'b0010
`define MULT_Data 4'b0011

//////////// SelPCsrc ///////////
`define No_Branch 3'b000
`define Beq_Branch 3'b001
`define Jal_Jump 3'b010
`define Jr_Jump 3'b011
`define Bne_Branch 3'b100

/////////// CMPop //////////////
`define BEQ_cmp 3'b000
`define BNE_cmp 3'b001

module G_GeneralController(
    input [5:0] op,
    input [5:0] func,
    output RegWriteEN,
    output SelExtRes,       // choose Extend result
    output SelALUsrc,
    output [3:0] ALUop,
    output [3:0] HL_Op, // new
    output SelALUResult,
    output [2:0] SelRegDst,
    output [2:0] DMWriteEN,
    output [2:0] DMReadEN,
    output [2:0] SelPCsrc,  // control jump
    output [3:0] SelRegWD,  // choose data from DM to RF
    output [2:0] CMPop
);
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
    wire ori = (op == `ORI);
    wire andi = (op == `ANDI);
    wire addi = (op == `ADDI);
    wire lui = (op == `LUI);
    wire lw = (op == `LW);
    wire lb = (op == `LB);
    wire lh = (op == `LH);
    wire sw = (op == `SW);
    wire sb = (op == `SB);
    wire sh = (op == `SH);
    wire beq = (op == `BEQ);
    wire bne = (op == `BNE);
    wire jr = (op == `R && func == `JR);
    wire jal = (op == `JAL);
    wire nop = (op == `R && func == `NOP);

    assign RegWriteEN = (add | sub | _and | _or
                        | andi | ori | lui | addi
                        | lw | lh | lb | jal | slt | sltu
                        | mfhi | mflo);

    assign SelExtRes = (andi | ori) ? `EXT_zero : `EXT_sign;

    assign SelPCsrc = (beq | bne) ? `Beq_Branch :
                      jal ? `Jal_Jump :
                      jr ? `Jr_Jump :
                      `No_Branch;

    assign CMPop = beq ? `BEQ_cmp : 
                   bne ? `BNE_cmp :
                   3'b000;
    
    //////////////// E ///////////////
    assign SelALUsrc = (addi | andi | ori | lui | lw | lh | lb | sw | sh | sb) ? `Ext_Data : `Rt_Data;

    assign ALUop = (add | addi | jr | nop | lw | lh | lb | sw | sh | sb) ? `ALU_add :
                   sub ? `ALU_sub :
                   lui ? `ALU_lui :
                   jal ? `ALU_jal :
                   (_and | andi) ? `ALU_and :
                   (_or | ori) ? `ALU_or :
                   slt ? `ALU_slt :
                   sltu ? `ALU_sltu :
                   `ALU_add;
    
    assign HL_Op = mult ? `HL_Mult :
                   multu ? `HL_Multu :
                   div ? `HL_Div :
                   divu ? `HL_Divu :
                   mthi ? `HL_Mthi :
                   mtlo ? `HL_Mtlo :
                   mfhi ? `HL_Mfhi :
                   mflo ? `HL_Mflo :
                   `HL_NoWrite;

    assign SelALUResult = (mfhi | mflo) ? `HL_Result : `ALU_Result;
    
    //////////////// M ////////////////
    assign DMWriteEN = sw ? `DM_sw :
                       sh ? `DM_sh :
                       sb ? `DM_sb :
                       3'b000;

    assign DMReadEN = lw ? `DM_lw :
                      lh ? `DM_lh :
                      lb ? `DM_lb :
                      3'b000;

    //////////////// W ////////////////
    assign SelRegDst = (add | sub | _and | _or | slt | sltu | mfhi | mflo) ? `RF_rd :
                       (addi | andi | lui | ori | lw | lh | lb) ? `RF_rt :
                       jal ? `RF_ra :
                       `RF_rt;

    assign SelRegWD = (lw | lh | lb) ? `DM_Data :
                      (add | sub | _and | _or | addi | slt | sltu | lui | andi | ori | nop | mfhi | mflo) ? `ALU_Data :
                      jal ? `PC_Data :
                      `DM_Data;

endmodule //GeneralController