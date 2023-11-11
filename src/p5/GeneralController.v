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

//////////// SelRegDst /////////
`define RF_rd 3'b000
`define RF_rt 3'b001
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

/////////// SelExtRes //////////
`define EXT_sign 1'b0
`define EXT_zero 1'b1

/////////// CMPop //////////////
`define BEQ_cmp 3'b000

module GeneralController(
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

    assign RegWriteEN = (op == `R && (func == `ADD) || (func == `SUB));

    assign SelExtRes = (op == `ORI) ? `EXT_zero : `EXT_sign;

    assign SelALUsrc = (op == `ORI || op == `LW || op == `SW);

    assign ALUop = ((op == `R && (func == `ADD || func == `JR || func == `NOP)) || op == `LW || op == `SW || op == `JAL) ? `ALU_add :
                   ((op == `R && (func == `SUB))) ? `ALU_sub : // beq需要前移
                   (op == `LUI) ? `ALU_lui :
                   `ALU_or; // ori

    assign SelRegDst = (op == `R && (func == `ADD || func == `SUB)) ? `RF_rd :
                       (op == `LUI || op == `LW || op == `LUI) ? `RF_rt :
                       (op == `JAL) ? `RF_rd :
                       `RF_rt;

    assign DMWriteEN = (op == `SW) ? 1'b1 : 1'b0;

    assign DMReadEN = (op == `LW) ? 1'b1 : 1'b0;

    assign SelPCsrc = (op == `BEQ) ? `Beq_Branch :
                      (op == `JAL) ? `Jal_Jump :
                      (op == `R && func == `JR) ? `Jr_Jump :
                      `No_Branch;

    assign SelRegWD = (op == `LW) ? `DM_Data :
                      ((op == `R && (func == `ADD || func == `SUB)) || op == `LUI || op == `ORI || op == `NOP) ? `ALU_Data :
                      (op == `JAL) ? `PC_data :
                      `DM_data;
    
    assign CMPop = (op == `BEQ) ? `BEQ_cmp : 3'b000;
endmodule //GeneralController