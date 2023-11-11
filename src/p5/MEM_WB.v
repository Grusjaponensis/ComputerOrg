module MEM_WB(
    input clk,
    input reset,
    input [31:0] Instr_MEM,
    input [31:0] Pc4_MEM,
    input [31:0] ALUout_MEM,
    input [31:0] DM_Data_MEM,
    output reg [31:0] Instr_WB,
    output reg [31:0] Pc4_WB, 
    output reg [31:0] ALUout_WB,
    output reg [31:0] DM_Data_WB
);
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            Instr_WB <= 0;
            Pc4_WB <= 0;
            ALUout_WB <= 0;
            DM_Data_WB <= 0;
        end
        else begin
            Instr_WB <= Instr_MEM;
            Pc4_WB <= Pc4_MEM;
            ALUout_WB <= ALUout_MEM;
            DM_Data_WB <= DM_Data_MEM;
        end
    end
endmodule //MEM_WB
