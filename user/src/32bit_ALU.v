module ALU_32bits(
    input [31:0] input_a,
    input [31:0] input_b,
    input [1:0] op,
    input en,
    input clk,
    output reg [31:0] result
);
    
    wire [31:0] temp_result;    
    
    assign temp_result = (op == 2'b00) ? (input_a + input_b) :
                         (op == 2'b01) ? (input_a - input_b) :
                         (op == 2'b10) ? (input_a & input_b) :
                                         (input_a | input_b);
    
    always @(posedge clk) begin
        if (en) begin
            result <= temp_resultl;
        end    
        else begin
            result <= result;
        end
    end
endmodule //32bit_ALU
