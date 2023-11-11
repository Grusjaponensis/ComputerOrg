`define BEQ_cmp 3'b000
module CMP(
    input [31:0] Data1,
    input [31:0] Data2,
    input [2:0] CMPop,
    output CmpResult
);
    assign CmpResult = ((CMPop == `BEQ_cmp) && (Data1 == Data2)) ? 1'b1 :
                       1'b0;
endmodule //CMP
