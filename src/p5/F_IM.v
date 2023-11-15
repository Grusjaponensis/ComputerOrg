`timescale 1ns / 1ps
module F_IM(
    input [11:0] InstrAddr,
    output [31:0] Instr
);
    reg [31:0] ROM [0:4095];
    integer i;
    
    initial begin
        for (i = 0; i < 4096; i = i + 1) begin
            ROM[i] = 32'h0000_0000;
        end
        $readmemh("code.txt", ROM);
    end
    
    assign Instr = ROM[InstrAddr];
endmodule //IM
