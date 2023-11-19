`timescale 1ns / 1ps
`define Op 31:26
`define Rs 25:21
`define Rt 20:16
`define Rd 15:11
`define func 5:0
`define Imm16 15:0
`define Addr26 25:0

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

/*  
    ///////////////////////////////////////////////////////
    //  命名规则: 凡本级模块生成的信号统一使用 D_... / E_...   //
    //  凡流水线寄存器生成的信号统一命名为ID_ / IF_ / EX_等    //
    ///////////////////////////////////////////////////////
*/

module mips(
    input clk,
    input reset
);

    //////////////////   F   /////////////////////

    /* ----- PC -----*/
    wire [31:0] F_Pc;
    wire [11:0] F_InstrAddr;

    /* ----- IM -----*/
    wire [31:0] F_Instr;

    /* ----- IF_ID -----*/
    wire [31:0] F_Pc4 = F_Pc + 32'h0000_0004;
    wire [31:0] ID_Instr;
    wire [31:0] ID_Pc4;

    //////////////////   D   /////////////////////

    /* ----- Splitter -----*/
    wire [25:0] D_Addr26;
    wire [15:0] D_Imm16;
    wire [5:0] D_func;
    wire [4:0] D_Rd, D_Rt, D_Rs;
    wire [5:0] D_Op;

    /* ----- GRF -----*/
    wire [31:0] Concurrent_Pc = WB_Pc4 - 32'h0000_0004;
    wire [31:0] D_RF_RD1_original, D_RF_RD2_original;
    wire [31:0] D_RF_RD1 = (D_Rs == WB_WriteReg && D_Rs != 5'b0 && W_RegWriteEN) ? WB_Result : D_RF_RD1_original;   // forward inside
    wire [31:0] D_RF_RD2 = (D_Rt == WB_WriteReg && D_Rt != 5'b0 && W_RegWriteEN) ? WB_Result : D_RF_RD2_original;

    /* ----- Extender -----*/
    wire [31:0] D_ExtResult;

    /* ----- CMP -----*/
    wire D_CmpResult;
    wire [31:0] D_CMP_srcA = (Forward_RS_D == 3'b001) ? MEM_ALUout :
                             (Forward_RS_D == 3'b010) ? WB_Result :
                             D_RF_RD1;
    wire [31:0] D_CMP_srcB = (Forward_RT_D == 3'b001) ? MEM_ALUout :
                             (Forward_RT_D == 3'b010) ? WB_Result :
                             D_RF_RD2;

    /* ----- NPC -----*/
    wire [31:0] D_next_PC;
    wire [31:0] D_NPC_ra = (Forward_PC_D == 3'b001) ? MEM_ALUout : D_RF_RD1;
    /* ----- ID_EX -----*/
    wire [31:0] EX_Instr, EX_Pc4, EX_Rs_Data, EX_Rt_Data, EX_Ext;
    wire [4:0] EX_Rs, EX_Rt, EX_Rd;

    /* ----- GeneralController -----*/
    wire D_SelExtRes;
    wire [2:0] D_SelPCsrc;
    wire [2:0] D_CMPop;

    //////////////////   E   /////////////////////

    /* ----- ALU -----*/
    wire [31:0] E_ALU_srcA_FWD = (Forward_RS_E == 3'b001) ? MEM_ALUout :
                                 (Forward_RS_E == 3'b010) ? WB_Result :
                                 EX_Rs_Data;
    wire [31:0] E_ALU_srcB_FWD = (Forward_RT_E == 3'b001) ? MEM_ALUout :
                                 (Forward_RT_E == 3'b010) ? WB_Result :
                                 EX_Rt_Data;
    wire [31:0] E_ALU_srcB = (E_SelALUsrc == `Rt_Data) ? E_ALU_srcB_FWD : EX_Ext;
    
    wire [31:0] E_ALU_Result;

    /* ----- EX_MEM -----*/
    wire [4:0] E_WriteReg = (E_SelRegDst == `RF_rt) ? EX_Rt :
                             (E_SelRegDst == `RF_rd) ? EX_Rd :
                             5'h1f;                             // jal
    wire [31:0] MEM_Instr, MEM_Pc4, MEM_ALUout, MEM_WriteData;
    wire [4:0] MEM_WriteReg;

    /* ----- E_GeneralCtrl -----*/
    wire E_SelALUsrc;
    wire [3:0] E_ALUop;
    wire [2:0] E_SelRegDst;

    //////////////////   M   /////////////////////

    /* ----- DM -----*/
    wire [31:0] M_DM_WriteData_FWD = (Forward_RT_M == 3'b001) ? WB_Result :
                                     MEM_WriteData;
    wire [31:0] M_Pc = MEM_Pc4 - 32'h0000_0004;
    wire [31:0] M_DM_ReadData;

    /* ----- MEM_WB -----*/
    wire [31:0] WB_Instr, WB_Pc4, WB_ALUout, WB_DM_ReadData;
    wire [4:0] WB_WriteReg;

    /* ----- M_GeneralCtrl -----*/
    wire M_DMWriteEN, M_DMReadEN;

    //////////////////   W   /////////////////////
    
    /* ----- RF -----*/
    wire [31:0] WB_Pc_with_DelaySlot = WB_Pc4 + 32'h0000_0004;
    wire [31:0] WB_Result = (W_SelRegWD == `DM_Data) ? WB_DM_ReadData :
                            (W_SelRegWD == `ALU_Data) ? WB_ALUout :
                            WB_Pc_with_DelaySlot;                       // jal: PC + 8 -> $31

    /* ----- W_GeneralCtrl -----*/
    wire W_RegWriteEN;
    wire [3:0] W_SelRegWD;

    /* ----- HazardController -----*/
    wire PC_En, IF_ID_En, ID_EX_clr;        // stall
    wire [2:0] Forward_RS_D, Forward_RT_D, Forward_PC_D, Forward_RS_E, Forward_RT_E, Forward_RT_M; // forward ctrl

    //////////////////   F   /////////////////////

    F_PC PC(
        .clk(clk),
        .reset(reset),
        .EN_Pc(PC_En),
        .next_PC(D_next_PC),        // D_NPC ->
        .Pc(F_Pc),
        .InstrAddr(F_InstrAddr)
    );

    F_IM IM(
        .InstrAddr(F_InstrAddr),
        .Instr(F_Instr)
    );
    
    _IF_ID IF_ID(
        .clk(clk),
        .En_IF_ID(IF_ID_En),
        .reset(reset),
        .Instr_IF(F_Instr),
        .Pc4_IF(F_Pc4),
        .Instr_ID(ID_Instr),
        .Pc4_ID(ID_Pc4)
    );

    //////////////////   D   /////////////////////

    D_Splitter Splitter(
        .Instr(ID_Instr),
        .Addr26(D_Addr26),
        .Imm16(D_Imm16),
        .func(D_func),
        .Rd(D_Rd),
        .Rt(D_Rt),
        .Rs(D_Rs),
        .Op(D_Op)
    );

    D_GRF GRF(
        .clk(clk),
        .reset(reset),
        .RegWrite(W_RegWriteEN),
        .Pc(Concurrent_Pc),
        .RF_WD(WB_Result),
        .A1(D_Rs),
        .A2(D_Rt),
        .RF_WA(WB_WriteReg),
        .RD1(D_RF_RD1_original),
        .RD2(D_RF_RD2_original)
    );

    D_Extender Extender(
        .Imm16(D_Imm16),
        .SelExtRes(D_SelExtRes),
        .ExtResult(D_ExtResult)
    );

    D_CMP CMP(
        .Data1(D_CMP_srcA), // fwd
        .Data2(D_CMP_srcB), // fwd
        .CMPop(D_CMPop),
        .CmpResult(D_CmpResult)
    );

    D_NPC NPC(
        .Pc4_F(F_Pc4),
        .Pc4(ID_Pc4),
        .Addr26(D_Addr26),
        .sign_ext_offset(D_ExtResult),
        .RF_RD1(D_NPC_ra),
        .SelPCsrc(D_SelPCsrc),
        .CmpResult(D_CmpResult),
        .next_PC(D_next_PC)
    );

    _ID_EX ID_EX(
        .clk(clk),
        .clr(ID_EX_clr),
        .reset(reset),
        .Instr_ID(ID_Instr),
        .Pc4_ID(ID_Pc4),
        .Rs_Data_ID(D_RF_RD1),
        .Rt_Data_ID(D_RF_RD2),
        .Ext_ID(D_ExtResult),
        .Rs_ID(D_Rs),
        .Rt_ID(D_Rt),
        .Rd_ID(D_Rd),
        .Instr_EX(EX_Instr),
        .Pc4_EX(EX_Pc4),
        .Rs_Data_EX(EX_Rs_Data),
        .Rt_Data_EX(EX_Rt_Data),
        .Ext_EX(EX_Ext),
        .Rs_EX(EX_Rs),
        .Rt_EX(EX_Rt),
        .Rd_EX(EX_Rd)
    );

    G_GeneralController D_GeneralCtrl(
        .op(D_Op),
        .func(D_func),
        .SelExtRes(D_SelExtRes),
        .SelPCsrc(D_SelPCsrc),
        .CMPop(D_CMPop),
        .RegWriteEN(), .SelALUsrc(), .ALUop(), .SelRegDst(), .DMWriteEN(), .DMReadEN(), .SelRegWD()
    );

    //////////////////   E   /////////////////////

    E_ALU ALU(
        .srcA(E_ALU_srcA_FWD), // need fwd
        .srcB(E_ALU_srcB), // need fwd
        .pc4(EX_Pc4),
        .ALUop(E_ALUop),
        .Result(E_ALU_Result)
    );

    _EX_MEM EX_MEM(
        .clk(clk),
        .reset(reset),
        .Instr_EX(EX_Instr),
        .Pc4_EX(EX_Pc4),
        .ALUout_EX(E_ALU_Result),
        .WriteData_EX(E_ALU_srcB_FWD), // need fwd
        .WriteReg_EX(E_WriteReg),
        .Instr_MEM(MEM_Instr),
        .Pc4_MEM(MEM_Pc4),
        .ALUout_MEM(MEM_ALUout),
        .WriteData_MEM(MEM_WriteData),
        .WriteReg_MEM(MEM_WriteReg)
    );

    G_GeneralController E_GeneralCtrl(
        .op(EX_Instr[`Op]),
        .func(EX_Instr[`func]),
        .SelALUsrc(E_SelALUsrc),
        .ALUop(E_ALUop),
        .SelRegDst(E_SelRegDst),
        .SelExtRes(), .SelPCsrc(), .RegWriteEN(), .DMWriteEN(), .DMReadEN(), .SelRegWD(), .CMPop()
    );

    //////////////////   M   /////////////////////

    M_DM DM(
        .clk(clk),
        .reset(reset),
        .DMWriteEN(M_DMWriteEN),
        .DMReadEN(M_DMReadEN),
        .Addr(MEM_ALUout),
        .DM_WD(M_DM_WriteData_FWD),
        .Pc(M_Pc),
        .DM_RD(M_DM_ReadData)
    );

    _MEM_WB MEM_WB(
        .clk(clk),
        .reset(reset),
        .Instr_MEM(MEM_Instr),
        .Pc4_MEM(MEM_Pc4),
        .ALUout_MEM(MEM_ALUout),
        .DM_Data_MEM(M_DM_ReadData),
        .WriteReg_MEM(MEM_WriteReg),
        .Instr_WB(WB_Instr),
        .Pc4_WB(WB_Pc4),
        .ALUout_WB(WB_ALUout),
        .DM_Data_WB(WB_DM_ReadData),
        .WriteReg_WB(WB_WriteReg)
    );

    G_GeneralController M_GeneralCtrl(
        .op(MEM_Instr[`Op]),
        .func(MEM_Instr[`func]),
        .DMWriteEN(M_DMWriteEN), 
        .DMReadEN(M_DMReadEN),
        .SelALUsrc(), .ALUop(), .SelRegDst(), .SelExtRes(), .SelPCsrc(), .RegWriteEN(), .SelRegWD(), .CMPop()
    );
    
    //////////////////   W   /////////////////////
    
    G_GeneralController W_GeneralCtrl(
        .op(WB_Instr[`Op]),
        .func(WB_Instr[`func]),
        .RegWriteEN(W_RegWriteEN),
        .SelRegWD(W_SelRegWD),
        .DMWriteEN(), .DMReadEN(), .SelALUsrc(), .ALUop(), .SelRegDst(), .SelExtRes(), .SelPCsrc(), .CMPop()
    );

    G_HazardController HazardController(
        .Instr_ID(ID_Instr),
        .Instr_EX(EX_Instr),
        .Instr_MEM(MEM_Instr),
        .Instr_WB(WB_Instr),

        .E_WriteReg(E_WriteReg),
        .M_WriteReg(MEM_WriteReg),
        .W_WriteReg(WB_WriteReg),
        
        .PC_En(PC_En),
        .IF_ID_En(IF_ID_En),
        .ID_EX_clr(ID_EX_clr),

        .Forward_RS_D(Forward_RS_D),
        .Forward_RT_D(Forward_RT_D),
        .Forward_PC_D(Forward_PC_D),
        .Forward_RS_E(Forward_RS_E),
        .Forward_RT_E(Forward_RT_E),
        .Forward_RT_M(Forward_RT_M)
    );
endmodule //mips