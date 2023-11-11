module ID_EX(
    input clk,
    input En_ID_EX,
    input reset,
    input [31:0] Instr_ID,
    input [31:0] Pc4_ID,
    input [31:0] Rs_Data_ID,
    input [31:0] Rt_Data_ID,
    input [31:0] Ext_ID,
    output reg [31:0] Instr_EX,
    output reg [31:0] Pc4_EX,
    output reg [31:0] Rs_Data_EX,
    output reg [31:0] Rt_Data_EX,
    output reg [31:0] Ext_EX
);

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            Instr_ID_EX <= 0;
            Pc4_ID_EX <= 0;
            Rs_Data_ID_EX <= 0;
            Rt_Data_ID_EX <= 0;
            Ext_ID_EX <= 0;
        end
        else begin
            if (En_ID_EX == 1'b1) begin
                Instr_EX <= Instr_ID;
                Pc4_EX <= Pc4_ID;
                Rs_Data_EX <= Rs_Data_ID;
                Rt_Data_EX <= Rt_Data_ID;
                Ext_EX <= Ext_ID;
            end
        end
    end
endmodule //ID_EX
