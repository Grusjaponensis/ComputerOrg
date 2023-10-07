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
`define S11 4'b1011
`define S12 4'b1100
`define S13 4'b1101
`define S14 4'b1110
`define S15 4'b1111
`define CounterZeroThreeBits 3'b000
`define CounterZeroFourBits 4'b0000

module cpu_checker(
        input clk,
        input [7:0] char,
        input reset,
        output [1:0] format_type
    );

    reg [2:0] counter1;
    reg [2:0] counter2;
    reg [3:0] counter3;
    reg [3:0] counter4;
    reg [3:0] counter5;
    reg [3:0] counter6;

    reg [3:0] status;

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            status <= `S0;
            counter1 <= `CounterZeroThreeBits;
            counter2 <= `CounterZeroThreeBits;
            counter3 <= `CounterZeroFourBits;
            counter4 <= `CounterZeroFourBits;
            counter5 <= `CounterZeroFourBits;
            counter6 <= `CounterZeroFourBits;
        end
        else begin
            case (status)
                `S0: begin
                    if (char == "^") begin
                        status <= `S1;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S1: begin
                    if (char > "0" && char <= "9") begin
                        counter1 <= counter1 + 3'b001;
                        status <= `S1;
                    end
                    else if (char >= "0" && char <= "9") begin
                        if (counter1 == 3'b001) begin
                            counter1 <= counter1 + 3'b001;
                            status <= `S1;
                        end
                        else begin
                            status <= `S0;
                            counter1 <= `CounterZeroThreeBits;
                        end
                    end
                    else if (char == "@") begin
                        if (counter1 <= 3'b100 && counter1 >= 3'b001) begin
                            counter1 <= `CounterZeroThreeBits;
                            status <= `S2;
                        end
                        else begin
                            counter1 <= `CounterZeroThreeBits;
                            status <= `S0;
                        end
                    end
                    else if (char == "^") begin
                        if (counter1 == 3'b000) begin
                            status <= `S1;
                        end
                        else begin
                            counter1 <= `CounterZeroThreeBits;
                            status <= `S0;
                        end
                    end
                    else begin
                        counter1 <= `CounterZeroThreeBits;
                        status <= `S0;
                    end
                end
                `S2: begin
                    if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                        counter3 <= counter3 + 4'b0001;
                        status <= `S2;
                    end
                    else if (char == ":") begin
                        if (counter3 == 4'b1000) begin
                            counter3 <= `CounterZeroFourBits;
                            status <= `S3;
                        end
                        else begin
                            counter3 <= `CounterZeroFourBits;
                            status <= `S0;
                        end
                    end
                    else begin
                        counter3 <= `CounterZeroFourBits;
                        status <= `S0;
                    end
                end
                `S3: begin
                    if (char == " ") begin
                        status <= `S3;
                    end
                    else if (char == "$") begin
                        status <= `S4;
                    end
                    else if (char == "*") begin
                        status <= `S10;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S4: begin
                    if (char > "0" && char <= "9") begin
                        counter2 <= counter2 + 3'b001;
                        status <= `S4;
                    end
                    // else if ((char >= "0" && char <= "9")) begin
                    //     if (counter2 == 3'b001) begin
                    //         counter2 <= counter2 + 3'b001;
                    //         status <= `S4;
                    //     end
                    //     else begin
                    //         status <= `S0;
                    //         counter2 <= `CounterZeroThreeBits;
                    //     end
                    // end
                    else if (char == " ") begin
                        if (counter2 <= 3'b100 && counter2 >= 3'b001) begin
                            status <= `S5;
                            counter2 <= `CounterZeroThreeBits;
                        end
                        else begin
                            counter2 <= `CounterZeroThreeBits;
                            status <= `S0;
                        end
                    end
                    else if (char == "<") begin
                        if (counter2 <= 3'b011 && counter2 >= 3'b001) begin
                            status <= `S6;
                            counter2 <= `CounterZeroThreeBits;
                        end
                        else begin
                            counter2 <= `CounterZeroThreeBits;
                            status <= `S0;
                        end
                    end
                    else begin
                        counter2 <= `CounterZeroThreeBits;
                        status <= `S0;
                    end
                end
                `S5: begin
                    if (char == " ") begin
                        status <= `S5;
                    end
                    else if (char == "<") begin
                        status <= `S6;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S6: begin
                    if (char == "=") begin
                        status <= `S7;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S7: begin
                    if (char == " ") begin
                        status <= `S7;
                    end
                    else if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                        status <= `S8;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S8: begin
                    if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                        counter4 <= counter4 + 4'b0001;
                        status <= `S8;
                    end
                    else if (char == "#") begin
                        if (counter4 == 4'b0111) begin
                            counter4 <= `CounterZeroFourBits;
                            status <= `S9;
                        end
                        else begin
                            counter4 <= `CounterZeroFourBits;
                            status <= `S0;
                        end
                    end
                    else begin
                        counter4 <= `CounterZeroFourBits;
                        status <= `S0;
                    end
                end
                `S9: begin
                    if (char == "^") begin
                        status <= `S1;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S10: begin
                    if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                        counter5 <= counter5 + 4'b0001;
                        status <= `S10;
                    end
                    else if (char == " ") begin
                        if (counter5 == 4'b1000) begin
                            counter5 <= `CounterZeroFourBits;
                            status <= `S11;
                        end
                        else begin
                            counter5 <= `CounterZeroFourBits;
                            status <= `S0;
                        end
                    end
                    else if (char == "<") begin
                        if (counter5 == 4'b1000) begin
                            counter5 <= `CounterZeroFourBits;
                            status <= `S12;
                        end
                        else begin
                            counter5 <= `CounterZeroFourBits;
                            status <= `S0;
                        end
                    end
                    else begin
                        counter5 <= `CounterZeroFourBits;
                        status <= `S0;
                    end
                end
                `S11: begin
                    if (char == " ") begin
                        status <= `S11;
                    end
                    else if (char == "<") begin
                        status <= `S12;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S12: begin
                    if (char == "=") begin
                        status <= `S13;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S13: begin
                    if (char == " ") begin
                        status <= `S13;
                    end
                    else if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                        status <= `S14; // some continuous problem
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S14: begin
                    if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                        counter6 <= counter6 + 4'b0001;
                        status <= `S14;
                    end
                    else if (char == "#") begin
                        if (counter6 == 4'b0111) begin
                            counter6 <= `CounterZeroFourBits;
                            status <= `S15;
                        end
                        else begin
                            counter6 <= `CounterZeroFourBits;
                            status <= `S0;
                        end
                    end
                    else begin
                        counter6 <= `CounterZeroFourBits;
                        status <= `S0;
                    end
                end
                `S15: begin
                    if (char == "^") begin
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
    end
    assign format_type = (status == `S9) ? 2'b01 :
           (status == `S15) ? 2'b10 :
           2'b00;
endmodule //cpu_chekcer
