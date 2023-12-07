`timescale 1ns / 1ps
`define DM_lw 3'b001
`define DM_lh 3'b010
`define DM_lb 3'b011

module M_DM_EXT(
    input [31:0] Addr,
    input [31:0] DM_RD_raw,
    input [2:0] DMReadEN,
    output [31:0] DM_RD
);
    reg [31:0] temp;
    always @(*) begin
        if (DMReadEN == `DM_lw)    temp = DM_RD_raw;
        
        else if (DMReadEN == `DM_lh) begin
            if (Addr[1] == 1'b1)    temp = {{16{DM_RD_raw[31]}}, DM_RD_raw[31:16]};
            else                    temp = {{16{DM_RD_raw[15]}}, DM_RD_raw[15:0]};
        end
        
        else if (DMReadEN == `DM_lb) begin
            if (Addr[1:0] == 2'b11)         temp = {{24{DM_RD_raw[31]}}, DM_RD_raw[31:24]};
            else if (Addr[1:0] == 2'b10)    temp = {{24{DM_RD_raw[23]}}, DM_RD_raw[23:16]};
            else if (Addr[1:0] == 2'b01)    temp = {{24{DM_RD_raw[15]}}, DM_RD_raw[15:8]};
            else                            temp = {{24{DM_RD_raw[7]}}, DM_RD_raw[7:0]};
        end
        
        else   temp = 32'b0;
    end

    assign DM_RD = temp;

endmodule //DM_EXT
