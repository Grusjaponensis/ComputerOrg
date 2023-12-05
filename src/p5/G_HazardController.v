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

`define Op 31:26
`define Rs 25:21
`define Rt 20:16
`define Rd 15:11
`define func 5:0
`define Imm16 15:0
`define Addr26 25:0

module G_HazardController(
    input [31:0] Instr_ID,
    input [31:0] Instr_EX,
    input [31:0] Instr_MEM,
    input [31:0] Instr_WB,

    input [4:0] E_WriteReg,
    input [4:0] M_WriteReg,
    input [4:0] W_WriteReg,
    
    output PC_En,
    output IF_ID_En,
    output ID_EX_clr,

    output [2:0] Forward_RS_D,
    output [2:0] Forward_RT_D,
    output [2:0] Forward_PC_D,
    output [2:0] Forward_RS_E,
    output [2:0] Forward_RT_E,
    output [2:0] Forward_RT_M
);

    wire [4:0] D_Rs = Instr_ID[`Rs];
    wire [4:0] D_Rt = Instr_ID[`Rt];
    wire [4:0] D_Rd = Instr_ID[`Rd];    

    wire [4:0] E_Rs = Instr_EX[`Rs];
    wire [4:0] E_Rt = Instr_EX[`Rt];
    wire [4:0] E_Rd = Instr_EX[`Rd];

    wire [4:0] M_Rs = Instr_MEM[`Rs];
    wire [4:0] M_Rt = Instr_MEM[`Rt];
    wire [4:0] M_Rd = Instr_MEM[`Rd];

    wire [4:0] W_Rs = Instr_WB[`Rs];
    wire [4:0] W_Rt = Instr_WB[`Rt];
    wire [4:0] W_Rd = Instr_WB[`Rd];
    
    //////////////// stage_D //////////////////
    wire D_load, D_store, D_cal_r, D_cal_i, D_branch, D_j_r;
   
    G_ClassifyUnit D_Instr(
        .Instr(Instr_ID),
        .load(D_load),
        .store(D_store),
        .cal_r(D_cal_r),
        .cal_i(D_cal_i),
        .branch(D_branch),
        .j_r(D_j_r)
    );
    
    // ---------- stall_R/stall_i, D_T_use(Rs/Rt) = 1 ---------- //
    wire stall_cal_r = D_cal_r && E_load && (D_Rs == E_Rt || D_Rt == E_Rt) && E_Rt != 5'b0;
    wire stall_cal_i = D_cal_i && E_load && (D_Rs == E_Rt) && E_Rt != 5'b0;

    // ---------- stall_load, D_T_use(Rs) = 1 ---------- //
    wire stall_load = D_load && E_load && (D_Rs == E_Rt) && E_Rt != 5'b0;

    // ---------- stall_store, D_T_use(Rs) = 1 ---------- //
    wire stall_store = D_store && E_load && (D_Rs == E_Rt) && E_Rt != 5'b0;

    // ---------- stall_branch, D_T_use(Rs/Rt) = 0 ---------- //
    wire stall_branch = D_branch && ((E_load && (D_Rs == E_Rt || D_Rt == E_Rt) && E_Rt != 5'b0) || 
                                    (M_load && (D_Rs == M_Rt || D_Rt == M_Rt) && M_Rt != 5'b0) || 
                                    (E_cal_r && (D_Rs == E_Rd || D_Rt == E_Rd) && E_Rd != 5'b0) ||
                                    (E_cal_i && (D_Rs == E_Rt || D_Rt == E_Rt) && E_Rt != 5'b0));

    // ---------- stall_j_r, D_T_use(Rs/Rt) = 0 ---------- //
    wire stall_j_r = D_j_r && ((E_load && (D_Rs == E_Rt) && E_Rt != 5'b0) ||
                              (M_load && (D_Rs == M_Rt) && M_Rt != 5'b0) ||
                              (E_cal_r && (D_Rs == E_Rd) && E_Rd != 5'b0) ||
                              (E_cal_i && (D_Rs == E_Rt) && E_Rt != 5'b0));

    wire stall = stall_cal_r | stall_cal_i | stall_load | stall_store | stall_branch | stall_j_r;
    assign PC_En = !stall;
    assign IF_ID_En = !stall;
    assign ID_EX_clr = stall;

    //////////////// stage_E //////////////////
    wire E_load, E_store, E_cal_r, E_cal_i, E_lui, E_j_addr;
    wire E_RegWriteEN;

    G_ClassifyUnit E_Instr(
        .Instr(Instr_EX),
        .load(E_load),
        .store(E_store),
        .cal_r(E_cal_r),
        .cal_i(E_cal_i),
        .lui(E_lui),
        .j_addr(E_j_addr)
    );

    G_GeneralController E_Signal(
        .op(Instr_EX[`Op]),
        .func(Instr_EX[`func]),
        .RegWriteEN(E_RegWriteEN)
    );

    //////////////// stage_M //////////////////
    wire M_load, M_store, M_cal_r, M_cal_i, M_lui, M_j_addr;
    wire M_RegWriteEN;

    G_ClassifyUnit M_Instr(
        .Instr(Instr_MEM),
        .load(M_load),
        .store(M_store),
        .cal_r(M_cal_r),
        .cal_i(M_cal_i),
        .lui(M_lui),
        .j_addr(M_j_addr)
    );

    G_GeneralController M_Signal(
        .op(Instr_MEM[`Op]),
        .func(Instr_MEM[`func]),
        .RegWriteEN(M_RegWriteEN)
    );

    //////////////// stage_W //////////////////
    wire W_load, W_store, W_cal_r, W_cal_i, W_lui, W_j_addr;
    wire W_RegWriteEN;

    G_ClassifyUnit W_Instr(
        .Instr(Instr_WB),
        .load(W_load),
        .store(W_store),
        .cal_r(W_cal_r),
        .cal_i(W_cal_i),
        .lui(W_lui),
        .j_addr(W_j_addr)
    );

    G_GeneralController W_Signal(
        .op(Instr_WB[`Op]),
        .func(Instr_WB[`func]),
        .RegWriteEN(W_RegWriteEN)
    );

    assign Forward_RS_D = (D_Rs == M_WriteReg && M_WriteReg != 5'b0 && M_RegWriteEN) ? 3'b001 :
                          (D_Rs == W_WriteReg && W_WriteReg != 5'b0 && W_RegWriteEN) ? 3'b010 :
                          3'b000;

    assign Forward_RT_D = (D_Rt == M_WriteReg && M_WriteReg != 5'b0 && M_RegWriteEN) ? 3'b001 :
                          (D_Rt == M_WriteReg && M_WriteReg != 5'b0 && M_RegWriteEN) ? 3'b010 :
                          3'b000;

    assign Forward_PC_D = (D_Rs == M_WriteReg && M_WriteReg != 5'b0 && M_RegWriteEN) ? 3'b001 : 
                          3'b000;

    assign Forward_RS_E = (E_Rs == M_WriteReg && M_WriteReg != 5'b0 && M_RegWriteEN) ? 3'b001 :
                          (E_Rs == W_WriteReg && W_WriteReg != 5'b0 && W_RegWriteEN) ? 3'b010 :
                          3'b000;
    assign Forward_RT_E = (E_Rt == M_WriteReg && M_WriteReg != 5'b0 && M_RegWriteEN) ? 3'b001 :
                          (E_Rt == W_WriteReg && W_WriteReg != 5'b0 && W_RegWriteEN) ? 3'b010 :
                          3'b000;

    assign Forward_RT_M = (M_Rt == W_WriteReg && W_WriteReg != 5'b0 && W_RegWriteEN) ? 3'b001 :
                          3'b000;
endmodule //HazardController
