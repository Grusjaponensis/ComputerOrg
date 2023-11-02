module PC(
    input clk,
    input reset,
    input [31:0] next_PC, 
    output [31:0] PC, 
    output [11:0] InstrAddr
);
    reg [31:0] Instr;
    
    always @(posedge clk) begin
        if (reset) Instr <= 32'h0000_3000; // synchronize reset
        else Instr <= next_PC;
    end
    
    wire [31:0] Instr_temp = Instr - 32'h0000_3000;
    assign InstrAddr = Instr_temp[13:2];
    assign PC = Instr;
endmodule //PC
