`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11
module counting(
        input [1:0] num,
        input clk,
        output ans
    );
    reg [1:0] status;

    initial begin
        status <= `S0;
    end

    always @(posedge clk) begin
        case (status)
            `S0: begin
                if (num == `S1) begin
                    status <= `S1;
                end
                else begin
                    status <= `S0;
                end
            end
            `S1: begin
                if (num == `S1) begin
                    status <= `S1;
                end
                else if (num == `S2) begin
                    status <= `S2;
                end
                else begin
                    status <= `S0;
                end
            end
            `S2: begin
                if (num == `S3) begin
                    status <= `S3;
                end
                else if (num == `S1) begin
                    status <= `S1;
                end
                else if (num == `S2) begin
                    status <= `S2;
                end
                else begin
                    status <= `S0;
                end
            end
            `S3: begin
                if (num == `S1) begin
                    status <= `S1;
                end
                else if (num == `S3) begin
                    status <= `S3;
                end
                else begin
                    status <= `S0;
                end
            end
        endcase
    end
    assign ans = status == `S3 ? 1'b1 : 1'b0;
endmodule //counting
