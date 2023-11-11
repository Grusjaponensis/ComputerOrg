`define EXT_sign 1'b0
`define EXT_zero 1'b1
module Extender(
    input [15:0] Imm16,
    input SelExtRes,
    output [31:0] ExtResult
);
    wire [31:0] ExtResult_Zero_ext = {16'b0, Imm16}; // any time declare a wire must declare its width!!!
    wire [31:0] ExtResult_Sign_ext = {{16{Imm16[15]}}, Imm16};
    assign ExtResult = (SelExtRes == `EXT_zero) ? ExtResult_Zero_ext : ExtResult_Sign_ext;
endmodule //Extender
