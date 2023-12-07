`timescale 1ns / 1ps

`define HL_NoWrite 4'b0000
`define HL_Mult 4'b0001
`define HL_Multu 4'b0010
`define HL_Div 4'b0011
`define HL_Divu 4'b0100
`define HL_Mthi 4'b0101
`define HL_Mtlo 4'b0110
`define HL_Mfhi 4'b0111
`define HL_Mflo 4'b1000

module E_MultDivUnit(
    input clk,
    input reset,
    input [31:0] rs,
    input [31:0] rt,
    input [3:0] HL_Op,
    output [31:0] HL_out,
    output HL_busy
);
    reg [31:0] HI, LO;
    reg [31:0] temp_hi, temp_lo, busy;
    integer counter;

    initial begin
        HI <= 0;
        LO <= 0;
        counter <= 0;
        busy <= 0;
    end

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            busy <= 0;
            counter <= 0;
            HI <= 0;
            LO <= 0;
        end
        else begin
            if (counter == 0) begin
                case (HL_Op)
                    `HL_Mult: begin
                        {temp_hi, temp_lo} <= $signed(rs) * $signed(rt);
                        counter <= 5;
                        busy <= 1;
                    end
                    `HL_Multu: begin
                        {temp_hi, temp_lo} <= rs * rt;
                        counter <= 5;
                        busy <= 1;
                    end
                    `HL_Div: begin
                        temp_lo <= $signed(rs) / $signed(rt);
                        temp_hi <= $signed(rs) % $signed(rt);
                        counter <= 10;
                        busy <= 1;
                    end
                    `HL_Divu: begin
                        temp_lo <= rs / rt;
                        temp_hi <= rs % rt;
                        counter <= 10;
                        busy <= 1;
                    end
                    `HL_Mthi: HI <= rs;
                    `HL_Mtlo: LO <= rs;
                endcase
            end
            else if (counter == 1) begin
                counter <= 0;
                busy <= 0;
                HI <= temp_hi;
                LO <= temp_lo;
            end
            else counter <= counter - 1;
        end
    end

    wire start = (HL_Op == `HL_Mult || HL_Op == `HL_Multu || HL_Op == `HL_Div || HL_Op == `HL_Divu);
    assign HL_busy = start | busy;
    assign HL_out = (HL_Op == `HL_Mfhi) ? HI :
                    (HL_Op == `HL_Mflo) ? LO :
                    32'b0;
endmodule //E_MultDivUnit