`timescale 1ns / 1ps
module ID_EX(
    input clk,
    input clr,
    input reset,
    input [31:0] Instr_ID,
    input [31:0] Pc4_ID,
    input [31:0] Rs_Data_ID,
    input [31:0] Rt_Data_ID,
    input [31:0] Ext_ID,
    input [4:0] Rs_ID,
    input [4:0] Rt_ID,
    input [4:0] Rd_ID,
    output reg [31:0] Instr_EX,
    output reg [31:0] Pc4_EX,
    output reg [31:0] Rs_Data_EX,
    output reg [31:0] Rt_Data_EX,
    output reg [31:0] Ext_EX,
    output reg [4:0] Rs_EX,
    output reg [4:0] Rt_EX,
    output reg [4:0] Rd_EX
);

    always @(posedge clk) begin
        if (reset == 1'b1 || clr == 1'b1) begin
            Instr_EX <= 0;
            Pc4_EX <= 0;
            Rs_Data_EX <= 0;
            Rt_Data_EX <= 0;
            Ext_EX <= 0;
            Rs_EX <= 0;
            Rt_EX <= 0;
            Rd_EX <= 0;
        end
        else begin
            Instr_EX <= Instr_ID;
            Pc4_EX <= Pc4_ID;
            Rs_Data_EX <= Rs_Data_ID;
            Rt_Data_EX <= Rt_Data_ID;
            Ext_EX <= Ext_ID;
            Rs_EX <= Rs_ID;
            Rt_EX <= Rt_ID;
            Rd_EX <= Rd_ID;
        end
    end
endmodule //ID_EX
