`timescale 1ns / 1ps

module gray(
    input Clk,
    input Reset,
    input En, 
    output [2:0] Output,
    output reg Overflow
);
    reg [2:0] counter;
    reg status;
    
    always @(posedge Clk) begin
        if (Reset == 1'b1) begin
            Overflow <= 1'b0;
            counter <= 3'b0;
            status <= 1'b0;
        end    
        else begin
            if (En == 1'b1) begin
                counter <= counter + 1;
                if (counter == 3'b111) status <= 1'b1;
                else status <= status;
                if (counter == 3'b000 && status == 1'b1) Overflow <= 1'b1;
                else Overflow <= Overflow;
            end
            else begin
                counter <= counter;
                status <= status;
            end
        end
    end

    assign Output = (counter == 3'b000) ? 3'b000 :
                    (counter == 3'b001) ? 3'b001 :
                    (counter == 3'b010) ? 3'b011 :
                    (counter == 3'b011) ? 3'b010 :
                    (counter == 3'b100) ? 3'b110 :
                    (counter == 3'b101) ? 3'b111 :
                    (counter == 3'b110) ? 3'b101 :
                                          3'b100 ;
endmodule //gray

