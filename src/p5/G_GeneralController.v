`timescale 1ns / 1ps
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

//////////// ALUop //////////
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_and 4'b0010
`define ALU_or 4'b0011
`define ALU_lui 4'b0100
`define ALU_jal 4'b0101

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

/////////// SelRegWD ////////
`define DM_Data 4'b0000
`define ALU_Data 4'b0001
`define PC_Data 4'b0010

//////////// SelPCsrc ///////////
`define No_Branch 3'b000
`define Beq_Branch 3'b001
`define Jal_Jump 3'b010
`define Jr_Jump 3'b011

/////////// CMPop //////////////
`define BEQ_cmp 3'b000

module G_GeneralController(
    input [5:0] op,
    input [5:0] func,
    output RegWriteEN,
    output SelExtRes,       // choose Extend result
    output SelALUsrc,
    output [3:0] ALUop,
    output [2:0] SelRegDst,
    output DMWriteEN,
    output DMReadEN,
    output [2:0] SelPCsrc,  // control jump
    output [3:0] SelRegWD,  // choose data from DM to RF
    output [2:0] CMPop
);

    wire add = (op == `R & func == `ADD);
    wire sub = (op == `R & func == `SUB);
    wire ori = (op == `ORI);
    wire lui = (op == `LUI);
    wire lw = (op == `LW);
    wire sw = (op == `SW);
    wire beq = (op == `BEQ);
    wire jal = (op == `JAL);
    wire jr = (op == `R & func == `JR);
    wire nop = (op == `R & func == `NOP);

    assign RegWriteEN = (add | sub | ori | lui | lw | jal);

    assign SelExtRes = ori ? `EXT_zero : `EXT_sign;

    assign SelPCsrc = beq ? `Beq_Branch :
                      jal ? `Jal_Jump :
                      jr ? `Jr_Jump :
                      `No_Branch;

    assign CMPop = beq ? `BEQ_cmp : 3'b000;
    
    //////////////// E ///////////////
    assign SelALUsrc = (ori | lw | sw | lui) ? `Ext_Data : `Rt_Data;

    assign ALUop = (add | jr | nop | lw | sw) ? `ALU_add :
                   sub ? `ALU_sub : // beq需要前移
                   lui ? `ALU_lui :
                   jal ? `ALU_jal :
                   `ALU_or; // ori
    
    //////////////// M ////////////////
    assign DMWriteEN = sw ? 1'b1 : 1'b0;

    assign DMReadEN = lw ? 1'b1 : 1'b0;

    //////////////// W ////////////////
    assign SelRegDst = (add | sub) ? `RF_rd :
                       (lui | ori | lw) ? `RF_rt :
                       jal ? `RF_ra :
                       `RF_rt;

    assign SelRegWD = lw ? `DM_Data :
                      (add | sub | lui | ori | nop) ? `ALU_Data :
                      jal ? `PC_Data :
                      `DM_Data;

endmodule //GeneralController