`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000
`define S9 4'b1001

module intcheck(
    input clk,
    input reset,
    input [7:0] in,
    output reg out
);
    reg [3:0] status;
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            status <= `S0;
            out <= 0;
        end
        else begin
            case (status)
                `S0: begin
                    if (in == ";") begin
                        status <= `S0;
                        out <= 0;
                    end
                    else if (in == " " || in == "\t") begin
                        status <= `S0;
                        out <= 0;
                    end
                    else if (in == "i") begin
                        status <= `S1;
                        out <= 0;
                    end
                    else begin
                        out <= 0;
                        status <= `S0;
                    end
                end 
                `S1: begin
                    if (in == "n") begin
                        status <= `S2;
                        out <= 0;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                `S2: begin
                    if (in == "t") begin
                        status <= `S3;
                        out <= 0;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                `S3: begin
                    if (in == " " || in == "\t") begin
                        status <= `S8;
                        out <= 0;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                `S4: begin
                    if (in == ";") begin
                        status <= `S0;
                        out <= 1; // set output as 1
                    end
                    else if ((in <= "Z" && in >= "A") || (in <= "z" && in >= "a") || (in <= "9" && in >= "0") || (in == "_")) begin
                        status <= `S4;
                        out <= 0;
                    end
                    else if (in == " " || in == "\t") begin
                        status <= `S7;
                        out <= 0;
                    end
                    else if (in == ",") begin
                        status <= `S8;
                        out <= 0;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                `S5: begin
                    if (in == "n") begin
                        status <= `S6;
                        out <= 0;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                `S6: begin
                    if (in == "t") begin
                        status <= `S9;
                        out <= 0;
                    end
                    else if ((in <= "Z" && in >= "A") || (in <= "z" && in >= "a") || (in == "_") || (in >= "0" && in <= "9")) begin
                        status <= `S4;
                        out <= 0;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                `S7: begin
                    if (in == " " || in == "\t") begin
                        status <= `S7;
                        out <= 0;
                    end
                    else if (in == ",") begin
                        status <= `S8;
                        out <= 0;
                    end
                    else if (in == ";") begin
                        status <= `S0;
                        out <= 1;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                `S8: begin
                    if (in == "i") begin
                        status <= `S5;
                        out <= 0;
                    end
                    else if (in == " " || in == "\t") begin
                        status <= `S8;
                        out <= 0;
                    end
                    else if ((in <= "Z" && in >= "A") || (in <= "z" && in >= "a" && in != "i") || (in == "_")) begin
                        status <= `S4;
                        out <= 0;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                `S9: begin
                    if (in == " " || in == "\t" || in == "," || in == ";") begin
                        status <= `S0;
                        out <= 0;
                    end
                    else if ((in <= "Z" && in >= "A") || (in <= "z" && in >= "a") || (in == "_") || (in >= "0" && in <= "9")) begin
                        status <= `S4;
                        out <= 0;
                    end
                    else begin
                        status <= `S0;
                        out <= 0;
                    end
                end
                default: begin
                    status <= `S0;
                    out <= 0;
                end
            endcase
        end
    end
endmodule //intcheck
