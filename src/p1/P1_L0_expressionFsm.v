module expr(
    input clk,
    input clr,
    input [7:0] in,
    output out
);
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;


    reg [2:0] status;

    always @(posedge clk or posedge clr) begin
        if (clr == 1'b1) begin
            status <= S0;
        end
        else begin
            case (status)
                S0: begin
                    if (in >= "0" && in <= "9") 
                        status <= S1;
                    else status <= S4;
                end
                S1: begin
                    if (in == "+") status <= S2;
                    else if (in == "*") status <= S3;
                    else status <= S4;
                end
                S2: begin
                    if (in >= "0" && in <= "9") status <= S1;
                    else status <= S0;
                end
                S3: begin
                    if (in >= "0" && in <= "9") status <= S1;
                    else status <= S0;
                end
                S4: begin
                    status <= S4;
                end
                default: status <= S4;
            endcase
        end
    end
    assign out = status == S1 ? 1'b1 :
                 1'b0;
endmodule //expr
