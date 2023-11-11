module EX_MEM(
    input clk,
    input reset,
    input [31:0] Instr_EX,
    input [31:0] Pc4_EX,
    input [31:0] ALUout_EX,
    input [31:0] WriteData_EX,
    output reg [31:0] Instr_MEM,
    output reg [31:0] Pc4_MEM,
    output reg [31:0] ALUout_MEM, 
    output reg [31:0] WriteData_MEM
);
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            Instr_MEM <= 0;
            Pc4_MEM <= 0;
            ALUout_MEM <= 0;
            WriteData_MEM <= 0;
        end
        else begin
            Instr_MEM <= Instr_EX;
            Pc4_MEM <= Pc4_EX;
            ALUout_MEM <= ALUout_EX;
            WriteData_MEM <= WriteData_EX;
        end
    end  
endmodule //EX_ME
