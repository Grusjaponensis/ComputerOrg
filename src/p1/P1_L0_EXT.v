module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output [31:0] ext
);
    wire [31:0] temp1;
    wire [31:0] temp2;
    wire [31:0] temp3;
    wire [31:0] temp4;

    assign temp1 = imm[15] == 1 ? {16'b1111_1111_1111_1111, imm} : {16'b0000_0000_0000_0000, imm};
    assign temp2 = {16'b0000_0000_0000_0000, imm};
    assign temp3 = {imm, 16'b0000_0000_0000_0000};
    
    assign ext = EOp == 2'b00 ? temp1 :
                 EOp == 2'b01 ? temp2 :
                 EOp == 2'b10 ? temp3 :
                 temp1 << 2;

endmodule //ext
