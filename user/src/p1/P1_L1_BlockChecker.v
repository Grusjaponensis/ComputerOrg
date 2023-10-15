`timescale 1ns / 1ps
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
`define S10 4'b1010
`define isAlpha ((in >= "a" && in <= "z") || (in >= "A" && in <= "Z"))
`define isNotB (in != "b" && in != "B")
`define isNotE (in != "e" && in != "E")
`define isB (in == "b" || in == "B")
`define isE (in == "e" || in == "E")

module BlockChecker(
    input clk, 
    input reset,
    input [7:0] in,
    output reg result
);
    reg [3:0] status;
    reg [31:0] begin_counter;

    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            status <= `S0;
            result <= 1'b0;
            begin_counter <= 32'b0;
        end
        else begin
            case (status)
                `S0: begin
                    if (in == " ") status <= `S0;
                    else if (`isAlpha && `isNotB && `isNotE) status <= `S1;
                    else if (`isB) status <= `S3;
                    else if (`isE) status <= `S8;
                    else status <= `S0;
                    result <= 1'b0;
                end 
                `S1: begin
                    if (in == " ") begin
                        status <= `S2;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha) begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        result <= 1'b0;
                        status <= `S0;
                    end
                end
                `S2: begin
                    if (in == " ") begin
                        status <= `S2;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha && `isNotB && `isNotE) begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isB) begin
                        status <= `S3;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isE) begin
                        status <= `S8;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        status <= `S0;
                        result <= 1'b0;
                    end
                end
                `S3: begin
                    if (`isE) begin
                        status <= `S4;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha && `isNotE) begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (in == " ") begin
                        status <= `S2;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        status <= `S0;
                        result <= 1'b0;
                    end
                end
                `S4: begin
                    if (in == "g" || in == "G") begin
                        status <= `S5;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha && (in != "g" || in != "G")) begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (in == " ") begin
                        status <= `S2;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        status <= `S0;
                        result <= 1'b0;
                    end
                end
                `S5: begin
                    if (`isAlpha && in != "i" && in != "I") begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (in == "i" || in == "I") begin
                        status <= `S6;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (in == " ") begin
                        status <= `S2;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        status <= `S0;
                        result <= 1'b0;
                    end
                end
                `S6: begin
                    if (in == " ") begin
                        status <= `S2;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (in == "n" || in == "N") begin
                        status <= `S7;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha && in != "n" && in != "N") begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        status <= `S0;
                        result <= 1'b0;
                    end
                end
                `S7: begin
                    if (in == " ") begin
                        status <= `S2;
                        begin_counter <= begin_counter + 1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha) begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                end
                `S8: begin
                    if (in == " ") begin
                        status <= `S2;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (in == "n" || in == "N") begin
                        status <= `S9;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha && in != "n" && in != "N") begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        status <= `S0;
                        result <= 1'b0;
                    end
                end
                `S9: begin
                    if (in == " ") begin
                        status <= `S2;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (in == "d" || in == "D") begin
                        status <= `S10;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha && in != "d" && in != "D") begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        status <= `S0;
                        result <= 1'b0;
                    end
                end
                `S10: begin
                    if (in == " ") begin
                        status <= `S2;
                        begin_counter <= begin_counter - 1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else if (`isAlpha) begin
                        status <= `S1;
                        if (begin_counter == 32'b0) result <= 1'b1;
                        else result <= 1'b0;
                    end
                    else begin
                        status <= `S0;
                        result <= 1'b0;
                    end
                end
                default: begin
                    status <= `S0;
                    result <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        case (status)
            `S0: begin
                result = 1'b0;
            end 
            `S1: begin
                if (begin_counter == 32'b0) result = 1'b1;
                else result = 1'b0;
            end
            `S2: begin
                if (begin_counter == 32'b0) result = 1'b1;
                else result = 1'b0;
            end
            `S3: begin
                if (begin_counter == 32'b0) result = 1'b1;
                else result = 1'b0;
            end
            `S4: begin
                if (begin_counter == 32'b0) result = 1'b1;
                else result = 1'b0;
            end
            `S5: begin
                if (begin_counter == 32'b0) result = 1'b1;
                else result = 1'b0;
            end
            `S6: begin
                if (in == "n" || in == "N") begin
                    result = 1'b0;
                end
                else begin
                    if (begin_counter == 32'b0) result = 1'b1;
                    else result = 1'b0;
                end
            end
            default: 
        endcase
    end
endmodule //BlockChecker

