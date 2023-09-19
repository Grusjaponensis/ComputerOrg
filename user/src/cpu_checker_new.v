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
`define Asterisk 8'b00101010
`define Numsign 8'b00100011
`define Dollar 8'b00100100
`define Zero 8'b00110000
`define Nine 8'b00111001
`define Less 8'b00111100
`define Equal 8'b00111101
`define At 8'b01000000
`define Caret 8'b01011110
`define A 8'b01100001
`define F 8'b01100110
`define Colon 8'b00111010
`define Space 8'b00100000
`define CounterZeroThreeBits 3'b000
`define CounterZeroFourBits 4'b0000

module cpu_checker(
    input clk,
    input char,
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
                    if (char == `Caret) begin
                        status <= `S1;
                    end
                    else begin
                        status <= `S0;
                    end
                end 
                `S1: begin
                    if (char > `Zero && char <= `Nine) begin
                        counter1 <= counter1 + 3'b001;
                        status <= `S1; 
                    end
                    else if (char == `At) begin
                        if (counter1 <= 3'b100 && counter1 >= 3'b001) begin
                            status <= `S2;
                            counter1 <= `CounterZeroThreeBits;
                        end
                        else begin
                            status <= `S0;
                            counter1 <= `CounterZeroThreeBits;
                        end
                    end
                    else begin
                        status <= `S0;
                        counter1 <= `CounterZeroThreeBits;
                    end
                end 
                `S2: begin
                    if ((char >= `Zero && char <= `Nine) || (char >= `A && char <= `F)) begin
                        counter3 <= counter3 + 4'b0001;
                        status <= `S2;
                    end
                    else if (char == `Colon) begin
                        if (counter3 == 4'b0111) begin
                            status <= `S3;
                            counter3 <= `CounterZeroFourBits;
                        end
                        else begin
                            status <= `S0;
                            counter3 <= `CounterZeroFourBits;
                        end
                    end
                    else begin
                        status <= `S0;
                    end
                end 
                `S3: begin
                    if (char == `Space) begin
                        status <= `S3;
                    end
                    else if (char == `Dollar) begin
                        status <= `S4;
                    end
                    else if (char == `Asterisk) begin
                        status <= `S10;
                    end
                    else begin
                        status <= `S0;
                    end
                end 
                `S4: begin
                    if (char > `Zero && char <= `Nine) begin
                        counter2 <= counter2 + 3'b001;
                        status <= `S4;
                    end
                    else if (char == `Space) begin
                        if (counter2 <= 3'b100 && counter2 >= 3'b001) begin
                            status <= `S5;
                        end
                        else begin
                            status <= `S0;
                            counter2 <= `CounterZeroThreeBits;
                        end
                    end
                    else if (char == `Less) begin
                        if (counter2 <= 3'b100 && counter2 >= 3'b001) begin
                            status <= `S6;
                        end
                        else begin
                            status <= `S0;
                            counter2 <= `CounterZeroThreeBits;
                        end
                    end
                    else begin
                        status <= `S0;
                        counter2 <= `CounterZeroThreeBits;
                    end
                end 
                `S5: begin
                    if (char == `Space) begin
                        status <= `S5;
                    end
                    else if (char == `Less) begin
                        status <= `S6;
                    end
                    else begin
                        status <= `S0;
                    end
                end 
                `S6: begin
                    if (char == `Equal) begin
                        status <= `S7;
                    end
                    else begin
                        status <= `S0;
                    end
                end 
                `S7: begin
                    if (char == `Space) begin
                        status <= `S7;
                    end
                    else if ((char >= `Zero && char <= `Nine) || (char >= `A && char <= `F)) begin
                        status <= `S8;
                    end
                    else begin
                        status <= `S0;
                    end
                end 
                `S8: begin
                    if ((char >= `Zero && char <= `Nine) || (char >= `A && char <= `F)) begin
                        counter4 <= counter4 + 4'b0001;
                        status <= `S8;
                    end// continue digits?
                    else if (char == `Numsign) begin
                        if (counter4 == 4'b0110) begin
                            status <= `S9;
                            counter4 <= `CounterZeroFourBits;
                        end
                        else begin
                            status <= `S0;
                            counter4 <= `CounterZeroFourBits;
                        end
                    end
                    else begin
                        status <= `S0;
                        counter4 <= `CounterZeroFourBits;
                    end
                end 
                `S9: begin
                    status <= `S0;
                end 
                `S10: begin
                    if ((char >= `Zero && char <= `Nine) || (char >= `A && char <= `F)) begin
                        counter5 <= counter5 + 4'b0001;
                        status <= `S10;
                    end
                    else if (char == `Space) begin
                        if (counter5 == 4'b0111) begin
                            status <= `S11;
                            counter5 <= `CounterZeroFourBits;
                        end
                        else begin
                            status <= `S0;
                            counter5 <= `CounterZeroFourBits;
                        end
                    end
                    else if (char == `Less) begin
                        if (counter5 == 4'b0111) begin
                            status <= `S12;
                            counter5 <= `CounterZeroFourBits;
                        end
                        else begin
                            status <= `S0;
                            counter5 <= `CounterZeroFourBits;
                        end
                    end
                    else begin
                        status <= `S0;
                        counter5 <= `CounterZeroFourBits;
                    end
                end 
                `S11: begin
                    if (char == `Space) begin
                        status <= `S11;
                    end
                    else if (char == `Less) begin
                        status <= `S12;
                    end
                end 
                `S12: begin
                    if (char == `Equal) begin
                        status <= `S13;
                    end
                    else begin
                        status <= `S0;
                    end
                end 
                `S13: begin
                    if (char ==`Space) begin
                        status <= `S13;
                    end
                    else if ((char >= `Zero && char <= `Nine) || (char >= `A && char <= `F)) begin
                        status <= `S14; // some continuous problem
                    end
                    else begin
                        status <= `S0;
                    end
                end 
                `S14: begin
                    if ((char >= `Zero && char <= `Nine) || (char >= `A && char <= `F)) begin
                        counter6 <= counter6 + 4'b0001;
                        status <= `S14;
                    end
                    else if (char == `Numsign) begin
                        if (counter6 == 4'b0110) begin
                            status <= `S15;
                            counter6 <= `CounterZeroFourBits;
                        end
                        else begin
                            status <= `S0;
                            counter6 <= `CounterZeroFourBits;
                        end
                    end
                    else begin
                        status <= `S0;
                        counter6 <= `CounterZeroFourBits;
                    end
                end 
                `S15: begin
                    status <= `S0;
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
