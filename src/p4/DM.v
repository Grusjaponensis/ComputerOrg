module DM(
    input clk,
    input reset, 
    input WriteData,
    input ReadData,
    input [31:0] Addr,
    input [31:0] WD,
    input [31:0] pC,
    output [31:0] RD
);
    reg [31:0] RAM [0:3071];
    integer i;
    initial begin
        for (i = 0; i < 3072; i = i + 1) begin
            RAM[i] = 32'h0000_0000;
        end
    end
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            for (i = 0; i < 3072; i = i + 1) begin
                RAM[i] <= 32'h0000_0000;  // ?
            end
        end
        else begin
            if (WriteData == 1'b1) begin
                RAM[Addr[13:2]] <= WD;
                $display("@%08h: *%08h <= %08h", pC, Addr, WD);
            end
            else begin

            end
        end
    end
    assign RD = (ReadData == 1'b1) ? RAM[Addr[13:2]] : 32'h0000_0000;
endmodule //DM
