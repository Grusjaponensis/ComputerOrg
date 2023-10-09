module code (
    input Clk,
    input Reset,
    input Slt,
    input En,
    output reg [63:0] Output0,
    output reg [63:0] Output1
);
    reg [1:0] count_1;
    
    always @(posedge Clk) begin
        if (Reset == 1'b0) begin
                if (En == 1'b1) begin
                    if (Slt == 1'b0) begin
                        Output0 <= Output0 + 64'b0000_0001;
                        Output1 <= Output1;
                        count_1 <= count_1;
                    end
                    else if (Slt == 1'b1) begin
                        count_1 <= count_1 + 2'b01;
                        if (count_1 == 2'b11) begin
                            Output1 <= Output1 + 64'b0000_0001;
                            Output0 <= Output0;
                        end
                        else begin
                            Output0 <= Output0;
                            Output1 <= Output1;
                        end
                    end
                end
                else begin
                    Output0 <= Output0;
                    Output1 <= Output1;
                    count_1 <= count_1;
                end
            end
        else if (Reset == 1'b1) begin
                Output0 <= 64'b0000_0000;
                Output1 <= 64'b0000_0000;
                count_1 <= 2'b00;
        end
    end
endmodule