`define R 6'b000000
`define ADD 6'b100000
`define SUB 6'b100010
`define JR 6'b001000
`define NOP 6'b000000

`define ORI 6'b001101
`define LW 6'b100011
`define SW 6'b101011
`define BEQ 6'b000100
`define LUI 6'b001111
`define JAL 6'b000011
module CtrlUnit(
    input [5:0] op,
    input [5:0] func,
    output ReadData,
    output WriteData,
    output MemToReg,
    output RegDst, 
    output ALUsrc, 
    output ShfToReg, 
    output RegWrite, 
    output [2:0] ALUop,
    output ExtRes,
    output [2:0] Jump
);
    assign RegDst = (op == `R && (func == `ADD || func == `SUB));
    
    assign ALUsrc = (op == `ORI || op == `LW || op == `SW);
    
    assign ALUop = ((op == `R && (func == `ADD || func == `JR || func == `NOP)) || op == `LW || op == `SW || op == `LUI || op == `JAL) ? 3'b000 :
                   ((op == `R && (func == `SUB)) || op == `BEQ) ? 3'b001 :
                   3'b011; // ori

    assign ReadData = (op == `LW);

    assign WriteData = (op == `SW);

    assign MemToReg = ((op == `R && (func == `ADD || func == `SUB)) || op == `ORI);

    assign ShfToReg = (op == `LUI);

    assign RegWrite = ((op == `R && (func == `ADD || func == `SUB)) || op == `ORI || op == `LW || op == `LUI || op == `JAL);

    assign ExtRes = (op == `ORI);

    assign Jump = (op == `BEQ) ? 3'b011 :
                  (op == `JAL) ? 3'b010 :
                  (op == `R && func == `JR) ? 3'b001 :
                  3'b000;

    // always @(*) begin
    //     if (op == 6'b000000) begin
    //         if (func == 6'b100000) begin        // add
    //             RegDst <= 1'b1;
    //             ALUsrc <= 1'b0;
    //             ALUop <= 2'b00;
    //             PCsrc <= 1'b0;
    //             ReadData <= 1'b0; // x
    //             WriteData <= 1'b0; // x
    //             MemToReg <= 1'b1;
    //             ShfToReg <= 1'b0;
    //             RegWrite <= 1'b1;
    //             ExtRes <= 1'b0; // x
    //             Jump <= 2'b00;
    //         end
    //         else if (func == 6'b100010) begin   // sub
    //             RegDst <= 1'b1;
    //             ALUsrc <= 1'b0;
    //             ALUop <= 2'b01;
    //             PCsrc <= 1'b0;
    //             ReadData <= 1'b0; // x
    //             WriteData <= 1'b0; // x
    //             MemToReg <= 1'b1;
    //             ShfToReg <= 1'b0;
    //             RegWrite <= 1'b1;
    //             ExtRes <= 1'b0; // x
    //             Jump <= 2'b0;
    //         end
    //         else if (func == 6'b001000) begin   // jr (GPR[rs] -> PC)
    //             RegDst <= 1'b0; // x
    //             ALUsrc <= 1'b0; // x
    //             ALUop <= 2'b00; // x
    //             PCsrc <= 1'b0;  // x
    //             ReadData <= 1'b0; // x
    //             WriteData <= 1'b0; // x
    //             MemToReg <= 1'b1; // x
    //             ShfToReg <= 1'b0; // x
    //             RegWrite <= 1'b0;
    //             ExtRes <= 1'b0; // x
    //             Jump <= 2'b01;
    //         end
    //         else begin                          // nop
    //             RegDst <= 1'b0; // x
    //             ALUsrc <= 1'b0; // x
    //             ALUop <= 2'b00; // x
    //             PCsrc <= 1'b0;  // x
    //             ReadData <= 1'b0; // x
    //             WriteData <= 1'b0; // x
    //             MemToReg <= 1'b0; // x
    //             ShfToReg <= 1'b0; // x
    //             RegWrite <= 1'b0; // x
    //             ExtRes <= 1'b0; // x
    //             Jump <= 2'b00; // x
    //         end
    //     end
    //     else if (op == 6'b001101) begin         // ori
    //         RegDst <= 1'b0;
    //         ALUsrc <= 1'b1;
    //         ALUop <= 2'b11;
    //         PCsrc <= 1'b0;
    //         ReadData <= 1'b0; // x
    //         WriteData <= 1'b0; // x
    //         MemToReg <= 1'b1;
    //         ShfToReg <= 1'b0;
    //         RegWrite <= 1'b1;
    //         ExtRes <= 1'b1;
    //         Jump <= 2'b0;
    //     end
    //     else if (op == 6'b100011) begin         // lw
    //         RegDst <= 1'b0;
    //         ALUsrc <= 1'b1;
    //         ALUop <= 2'b00;
    //         PCsrc <= 1'b0;
    //         ReadData <= 1'b1;
    //         WriteData <= 1'b0; // x
    //         MemToReg <= 1'b0;
    //         ShfToReg <= 1'b0;
    //         RegWrite <= 1'b1;
    //         ExtRes <= 1'b0;
    //         Jump <= 2'b0;
    //     end
    //     else if (op == 6'b101011) begin         // sw
    //         RegDst <= 1'b0; // x
    //         ALUsrc <= 1'b1;
    //         ALUop <= 2'b00;
    //         PCsrc <= 1'b0;
    //         ReadData <= 1'b0; // x
    //         WriteData <= 1'b1;
    //         MemToReg <= 1'b1; // x
    //         ShfToReg <= 1'b0;
    //         RegWrite <= 1'b0;
    //         ExtRes <= 1'b0;
    //         Jump <= 2'b0;
    //     end
    //     else if (op == 6'b000100) begin         // beq
    //         RegDst <= 1'b0; // x
    //         ALUsrc <= 1'b0;
    //         ALUop <= 2'b01;
    //         PCsrc <= 1'b1;
    //         ReadData <= 1'b0; // x
    //         WriteData <= 1'b0; // x
    //         MemToReg <= 1'b0; // x
    //         ShfToReg <= 1'b0; // x
    //         RegWrite <= 1'b0;
    //         ExtRes <= 1'b0;
    //         Jump <= 2'b0;
    //     end
    //     else if (op == 6'b001111) begin         // lui
    //         RegDst <= 1'b0;
    //         ALUsrc <= 1'b0; // x
    //         ALUop <= 2'b00; // xx
    //         PCsrc <= 1'b0;
    //         ReadData <= 1'b0; // x
    //         WriteData <= 1'b0; // x
    //         MemToReg <= 1'b0; // x
    //         ShfToReg <= 1'b1;
    //         RegWrite <= 1'b1;
    //         ExtRes <= 1'b0; // x
    //         Jump <= 2'b0;
    //     end
    //     else if (op == 6'b000011) begin         // jal (PC + 8 -> $31, PC <= {PC[31:28], 26addr, 00})
    //         RegDst <= 1'b0; // must be zero!
    //         ALUsrc <= 1'b0;
    //         ALUop <= 2'b00; // x
    //         PCsrc <= 1'b0;
    //         ReadData <= 1'b0; // x
    //         WriteData <= 1'b0; // x
    //         MemToReg <= 1'b0;
    //         ShfToReg <= 1'b0;
    //         RegWrite <= 1'b1;
    //         ExtRes <= 1'b0; // x
    //         Jump <= 2'b10;
    //     end
    //     else begin

    //     end
    // end
endmodule //CtrlUnit
