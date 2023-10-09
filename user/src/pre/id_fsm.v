`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11

module id_fsm (
    input [7:0] char,
    input clk,
    output out
);
    
    reg [1:0] status;

    always @(posedge clk) begin
        case (status)
            `S0: begin
                if ((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010)) begin
                    status <= `S1;
                end // characters a-z A-Z
                else if (char >= 8'b00110000 && char <= 8'b00111001) begin
                    status <= `S2;
                end // digits 0-9
                else begin
                    status <= `S0;
                end
            end 
            `S1: begin
                if ((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010)) begin
                    status <= `S1;
                end
                else if (char >= 8'b00110000 && char <= 8'b00111001) begin
                    status <= `S3;
                end
                else begin
                    status <= `S0;
                end
            end
            `S2: begin
                if ((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010)) begin
                    status <= `S1;
                end
                else if (char >= 8'b00110000 && char <= 8'b00111001) begin
                    status <= `S2;
                end
                else begin
                    status <= `S0;
                end
            end
            `S3: begin
                if ((char >= 8'b00110000 && char <= 8'b00111001)) begin
                    status <= `S3;
                end
                else if ((char >= 8'b01100001 && char <= 8'b01111010) || (char >= 8'b01000001 && char <= 8'b01011010)) begin
                    status <= `S1;
                end
                else begin
                    status <= `S0;
                end
            end
            default: begin
                status <= `S0;
            end
        endcase
    end
    assign out = status == `S3 ? 1'b1 : 1'b0;
endmodule