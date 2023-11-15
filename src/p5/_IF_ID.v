`timescale 1ns / 1ps
module IF_ID(
    input clk,
    input En_IF_ID,
    input reset,
    input [31:0] Instr_IF,                  // IM ->
    input [31:0] Pc4_IF,                    // Add4 ->
    output reg [31:0] Instr_ID,             // -> ID/EX
    output reg [31:0] Pc4_ID                // -> ID/EX
);
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            Instr_ID <= 32'h0000_0000;
            Pc4_ID <= 32'h0000_0000;
        end
        else begin
            if (En_IF_ID == 1'b1) begin
                Instr_ID <= Instr_IF;
                Pc4_ID <= Pc4_IF;
            end
        end
    end
endmodule //IF_ID
