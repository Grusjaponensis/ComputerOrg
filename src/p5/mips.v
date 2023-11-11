module mips(
    input clk,
    input reset
);
    //////////////////   F   /////////////////////
    PC PC(
        .clk(clk),
        .reset(reset),
        .next_PC
    )

endmodule //mips
