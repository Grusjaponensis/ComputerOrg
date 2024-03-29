module mips(
    input clk,
    input reset
);
    // PC
    wire [31:0] 	pC;
    wire [11:0] 	InstrAddr;
    wire [31:0]     next_PC = (Jump == 3'b011 && Zero == 1'b1) ? ((ExtResult << 2) + pC + 32'h0000_0004) :   // beq
                              (Jump == 3'b001) ? RD1 :                                                       // jr
                              (Jump == 3'b010) ? ({pC[31:28], Addr26, {2{1'b0}}}) :                          // jal
                              (pC + 32'h4);

    // IM
    wire [31:0] 	Instr;

    // Splitter
    wire [25:0] 	Addr26;
    wire [15:0] 	Imm16;
    wire [5:0]  	func;
    wire [4:0]  	Rd;
    wire [4:0]  	Rt;
    wire [4:0]  	Rs;
    wire [5:0]  	Op;
    
    // CtrlUnit
    wire       	ReadData;
    wire       	WriteData;
    wire       	MemToReg;
    wire       	RegDst;
    wire       	ALUsrc;
    wire       	ShfToReg;
    wire       	RegWrite;
    wire [2:0] 	ALUop;
    wire       	ExtRes;
    wire [2:0]  Jump;

    // Extender
    wire [31:0] 	ExtResult;

    // GRF
    wire [31:0] 	RD1;
    wire [31:0] 	RD2;
    wire [31:0]     WD = (ShfToReg == 1'b1) ? (ExtResult << 16) :   // lui
                         (MemToReg == 1'b1) ? ALUResult :
                         (Jump == 3'b010) ? pC + 32'h0000_0004 :     // jal ?
                         DM_RD;
    wire [4:0]      A1 = Rs;
    wire [4:0]      A2 = Rt;
    wire [4:0]      WA = (RegDst == 1'b1) ? Rd :
                         (Jump == 3'b010) ? 5'b11111 : // jal
                         Rt;

    // ALU
    wire        	Zero;
    wire [31:0] 	ALUResult;
    wire [31:0]     srcB = (ALUsrc == 1'b1) ? ExtResult : RD2;

    // DM
    wire [31:0] 	DM_RD;

    PC PC(
    	.clk       	( clk        ),
    	.reset     	( reset      ),
    	.next_PC   	( next_PC    ), // MUX(beq/jal/jr) ->
    	.PC        	( pC         ), // -> Adder
    	.InstrAddr 	( InstrAddr  )  // -> IM
    );

    IM IM(
    	.InstrAddr 	( InstrAddr  ), // PC ->
    	.Instr     	( Instr      )  // -> Splitter
    );

    Splitter Splitter(
    	.Instr  	( Instr   ), // IM ->
    	.Addr26 	( Addr26  ), // -> MUX for jump
    	.Imm16  	( Imm16   ), // -> Ext
    	.func   	( func    ), // -> CtrlUnit
    	.Rd     	( Rd      ), // -> GRF
    	.Rt     	( Rt      ), // -> GRF
    	.Rs     	( Rs      ), // -> GRF
    	.Op     	( Op      )  // -> CtrlUnit
    );

    Extender Extender(
    	.Imm16     	( Imm16      ), // Splitter ->
    	.ExtRes    	( ExtRes     ), // CtrlUnit ->
    	.ExtResult 	( ExtResult  )  // -> shifter, ALU
    );

    GRF GRF(
    	.clk      	( clk       ),
    	.reset    	( reset     ),
    	.RegWrite 	( RegWrite  ), // CtrlUnit ->
    	.pC    	    ( pC        ), // PC ->
    	.WD       	( WD        ), // Extender / ALU / pC / DM ->
    	.A1       	( A1        ), // Splitter: Rs ->
    	.A2       	( A2        ), // Splitter: Rt ->
    	.WA       	( WA        ), // Splitter: Rt/Rd / 31 ->
    	.RD1      	( RD1       ), // -> ALU, PC
    	.RD2      	( RD2       )  // -> ALU, DM
    );

    ALU ALU(
    	.srcA   	( RD1       ), // GRF ->
    	.srcB   	( srcB      ), // GRF / Extender ->
    	.ALUop  	( ALUop     ), // CtrlUnit ->
    	.Zero   	( Zero      ), // -> MUX
    	.Result 	( ALUResult )  // -> DM, GRF
    );

    DM DM(
    	.clk       	( clk        ),
    	.reset     	( reset      ),
    	.WriteData 	( WriteData  ), // CtrlUnit ->
    	.ReadData  	( ReadData   ), // CtrlUnit ->
    	.Addr      	( ALUResult  ), // ALU ->
    	.WD        	( RD2        ), // GRF ->
        .pC         ( pC         ), // PC ->
    	.RD        	( DM_RD      )  // -> GRF
    );

    CtrlUnit CtrlUnit(
    	.op        	( Op         ), // Splitter ->
    	.func      	( func       ), // Splitter ->
    	.ReadData  	( ReadData   ), // -> DM
    	.WriteData 	( WriteData  ), // -> DM
    	.MemToReg  	( MemToReg   ), // -> MUX
    	.RegDst    	( RegDst     ), // -> MUX
    	.ALUsrc    	( ALUsrc     ), // -> MUX
    	.ShfToReg  	( ShfToReg   ), // -> MUX
    	.RegWrite  	( RegWrite   ), // -> GRF
    	.ALUop     	( ALUop      ), // -> ALU
    	.ExtRes    	( ExtRes     ), // -> Extender 
        .Jump       ( Jump       )  // -> Mux
    );
endmodule //mips
