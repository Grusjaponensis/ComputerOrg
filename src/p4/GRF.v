module GRF(
    input clk,
    input reset,
    input RegWrite,
    input [31:0] pC, 
    input [31:0] WD,
    input [4:0] A1, 
    input [4:0] A2,
    input [4:0] WA, // writeAddr
    output [31:0] RD1,
    output [31:0] RD2
);
    integer i;
    reg [31:0] Register [0:31];
    
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            Register[i] = 32'h0000_0000;
        end
    end
    
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            for (i = 0; i < 32; i = i + 1) begin
                Register[i] <= 32'h0000_0000;
            end
        end
        else begin
            if (RegWrite == 1'b1) begin 
                if (WA != 5'b0) begin
                    Register[WA] <= WD;
                    $display("@%08h: $%d <= %08h", pC, WA, WD);
                end
                else begin
                    Register[0] <= 32'h0000_0000;
                end
            end
            else begin
                Register[0] <= 32'h0000_0000;
            end
        end
    end
    assign RD1 = Register[A1];
    assign RD2 = Register[A2];
endmodule //GRF
