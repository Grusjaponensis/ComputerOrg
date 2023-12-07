`timescale 1ns / 1ps
module F_PC(
    input clk,
    input reset,
    input EN_Pc,
    input [31:0] next_PC, 
    output [31:0] Pc, 
    output [31:0] InstrAddr
);
    reg [31:0] Instr;
    
    always @(posedge clk) begin
        if (reset) Instr <= 32'h0000_3000; // synchronize reset
        else begin
            if (EN_Pc == 1'b1) Instr <= next_PC;
        end
    end
    
    assign InstrAddr = Instr;
    assign Pc = Instr;
endmodule //PC
