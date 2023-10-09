`define S0 5'b00000
`define S1 5'b00001
`define S2 5'b00010
`define S3 5'b00011
`define S4 5'b00100
`define S5 5'b00101
`define S6 5'b00110
`define S7 5'b00111
`define S8 5'b01000
`define S9 5'b01001
`define S10 5'b01010
`define S11 5'b01011
`define S12 5'b01100
`define S13 5'b01101
`define S14 5'b01110
`define S15 5'b01111
`define S16 5'b10000
`define S17 5'b10001
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
    input reset,
    input char,
    output [1:0] format_type
);

    reg [4:0] status;
    reg [2:0] counter1;
    reg [2:0] counter2;
    reg [3:0] counter3;
    reg [3:0] counter4;
    reg [3:0] counter5;
    reg [3:0] counter6;


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
                    if (char == `Caret) begin // ^
                        status <= `S1;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S1: begin
                    if (char > `Zero && char <= `Nine) begin
                        status <= `S3;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S3: begin
                    if (char >= `Zero && char <= `Nine) begin
                        counter1 <= counter1 + 3'b001;
                        status <= `S3;
                    end
                    else if (char == `At) begin  // @
                        if (counter1 <= 3'b010) begin
                            counter1 <= `CounterZeroThreeBits;
                            status <= `S4;
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
                `S4: begin
                    if ((char <= `Nine && char >= `Zero) || (char <= `F && char >= `A)) begin
                        counter3 <= counter3 + 4'b0001;
                        status <= `S4;
                    end
                    else if (char == `Colon) begin // :
                        if (counter3 == 4'b0111) begin
                            counter3 <= `CounterZeroFourBits;
                            status <= `S5;
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
                `S5: begin
                    if (char == `Space) begin
                        status <= `S5;
                    end
                    else if (char == `Asterisk) begin
                        status <= `S6;
                    end
                    else if (char == `Dollar) begin
                        status <= `S9;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S6: begin
                    if ((char <= `Nine && char >= `Zero) || (char <= `F && char >= `A)) begin
                        counter4 <= counter4 + 4'b0001;
                        status <= `S6;
                    end
                    else if (char == `Less) begin
                        if (counter4 == 4'b0111) begin
                            counter4 <= `CounterZeroFourBits;
                            status <= `S7;
                        end
                        else begin
                            counter4 <= `CounterZeroFourBits;
                            status <= `S0;
                        end
                    end
                    else if (char == `Space) begin
                        if (counter4 == 4'b0111) begin
                            counter4 <= `CounterZeroFourBits;
                            status <= `S8;
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
                `S7: begin
                    if (char == `Equal) begin
                        status <= `S15;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S8: begin
                    if (char == `Space) begin
                        status <= `S8;
                    end
                    else if (char == `Less) begin
                        status <= `S7;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S9: begin
                    if ((char <= `Nine && char > `Zero)) begin
                        counter2 <= counter2 + 3'b001;
                        status <= `S9;
                    end
                    else if (char == `Space) begin
                        if (counter2 <= 3'b011) begin
                            counter2 <= `CounterZeroThreeBits;
                            status <= `S10;
                        end
                        else begin
                            counter2 <= `CounterZeroThreeBits;
                            status <= `S0;
                        end
                    end
                    else if (char == `Less) begin
                        if (counter2 <= 3'b011) begin
                            counter2 <= `CounterZeroThreeBits;
                            status <= `S11;
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
                `S10: begin
                    if (char == `Space) begin
                        status <= `S10;
                    end
                    else if (char == `Less) begin
                        status <= `S11;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S11: begin
                    if (char == `Equal) begin
                        status <= `S12;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S12: begin
                    if (char == `Space) begin
                        status <= `S12;
                    end
                    else if ((char <= `Nine && char >= `Zero) || (char <= `F && char >= `A)) begin
                        status <= `S13;
                    end
                    else begin
                        status <= `S0;
                    end
                end
                `S13: begin
                    if ((char <= `Nine && char >= `Zero) || (char <= `F && char >= `A)) begin
                        counter6 <= counter6 + 4'b0001;
                        status <= `S13;
                    end
                    else if (char == `Numsign) begin
                        if (counter6 == 4'b0110) begin
                            counter6 <= `CounterZeroFourBits;
                            status <= `S14;
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
                `S14: begin
                    status <= `S0;
                end
                `S15: begin
                    if (char == `Space) begin
                        status <= `S15;
                    end
                    else if ((char <= `Nine && char >= `Zero) || (char <= `F && char >= `A)) begin
                        status <= `S16;
                    end
                end
                `S16: begin
                    if ((char <= `Nine && char >= `Zero) || (char <= `F && char >= `A)) begin
                        counter5 <= counter5 + 4'b0001;
                        status <= `S16;
                    end
                    else if (char == `Numsign) begin
                        if (counter5 == 4'b0110) begin
                            status <= `S17;
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
                `S17: begin
                    status <= `S0;
                end
                default: begin
                    status <= `S0;
                end
            endcase
        end
    end
    
    assign format_type = status == `S14 ? 2'b01 :
                         status == `S17 ? 2'b10 :
                         2'b00; 
endmodule //cpu_checker
