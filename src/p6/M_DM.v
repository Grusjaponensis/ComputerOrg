`timescale 1ns / 1ps
module M_DM(
    input clk,
    input reset, 
    input DMWriteEN,
    input DMReadEN,
    input [31:0] Addr,
    input [31:0] DM_WD,
    input [31:0] Pc,
    output [31:0] DM_RD
);
    reg [31:0] RAM [0:3071];
    integer i;
    initial begin
        for (i = 0; i < 3072; i = i + 1) begin
            RAM[i] = 32'h0000_0000;
        end
    end
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            for (i = 0; i < 3072; i = i + 1) begin
                RAM[i] <= 32'h0000_0000;
            end
        end
        else begin
            if (DMWriteEN == 1'b1) begin
                RAM[Addr[13:2]] <= DM_WD;
                $display("%d@%08h: *%08h <= %08h",$time, Pc, Addr, DM_WD);
            end
        end
    end
    assign DM_RD = (DMReadEN == 1'b1) ? RAM[Addr[13:2]] : 32'h0000_0000;
endmodule //DM
