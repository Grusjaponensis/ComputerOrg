`define S0 5'b00001
`define S1 5'b00010
`define S2 5'b00100
`define S3 5'b01000
`define S4 5'b10000

module FloatType(
    input [31:0] num,
    output [4:0] float_type
);
    reg [7:0] stage;
    reg [22:0] trailing;
    reg [4:0] state;

    always @(*) begin
        stage = num[30:23];
        trailing = num[22:0];
        if (stage == 8'b00000000 && trailing == 23'b00000000000000000000000) begin
            state = `S0;
        end
        else if (stage != 8'b00000000 && stage != 8'b11111111) begin
            state = `S1;
        end
        else if (stage == 8'b00000000 && trailing != 23'b00000000000000000000000) begin
            state = `S2;
        end
        else if (stage == 8'b11111111 && trailing == 23'b00000000000000000000000) begin
            state = `S3;
        end
        else if (stage == 8'b11111111 && trailing != 23'b00000000000000000000000) begin
            state = `S4;
        end
    end
    assign float_type = state == `S0 ? `S0 :
                        state == `S1 ? `S1 :
                        state == `S2 ? `S2 :
                        state == `S3 ? `S3 :
                        state == `S4 ? `S4 :
                        5'b00000; 
endmodule //FloatType

