module Splitter(
    input [31:0] Instr,
    output [25:0] Addr26,
    output [15:0] Imm16,
    output [5:0] func,
    output [4:0] Rd,
    output [4:0] Rt,
    output [4:0] Rs,
    output [5:0] Op
);
    assign Addr26 = Instr[25:0];
    assign Imm16 = Instr[15:0];
    assign func = Instr[5:0];
    assign Rd = Instr[15:11];
    assign Rt = Instr[20:16];
    assign Rs = Instr[25:21];
    assign Op = Instr[31:26];
endmodule //Splitter
