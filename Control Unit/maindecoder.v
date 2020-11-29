module maindec( input [5:0]op,
								input [4:0]rt,
								output memtoreg, memwrite,
								output branch, alusrcA,
								output [2:0] alusrcB,
								output regdst, regwrite,
								output jump,
								output [1:0] aluop);
 
/* separate alusrc into srcA and srcB and define directly
what signal to send for which instruction
*/

reg[11:0] controls;

assign {regwrite, regdst, alusrcA, alusrcB, branch, memwrite,
				memtoreg, jump, aluop} = controls;

always_ff @(posedge clk) begin
case(op)
	6'b000000: controls <= 12'b111000000010; /* R-type, SPECIAL */
	6'b000001: case(rt) /* REGIMM Branch stuff - Perhaps implement a separate block for branch instructions? */
							5'b00000: controls <= 9'b /* BLTZ */
							5'b00001: controls <= 9'b /* BGEZ */
							5'b10000: controls <= 9'b /* BLTZAL */
							5'b10001: controls <= 9'b /* BGEZAL */
							endcase
	6'b000010: controls <= 9'b000000100 /* J */
	6'b000011: controls <= 9'b /* JAL */
	6'b000100: controls <= 9'b000100001 /* BEQ */
	6'b000101: controls <= 9'b /* BNE */
	6'b000110: controls <= 9'b /* BLEZ */
	6'b000111: controls <= 9'b /* BGTZ */
	6'b001001: controls <= 9'b /* ADDIU */
	6'b001010: controls <= 9'b /* SLTI */
	6'b001011: controls <= 9'b /* SLTIU */
	6'b001100: controls <= 9'b /* ANDI */
	6'b001101: controls <= 9'b /* ORI */
	6'b001110: controls <= 9'b /* XORI */
	6'b001111: controls <= 9'b /* LUI */
	6'b100000: controls <= 9'b10 /* LB */
	6'b100001: controls <= 9'b /* LH */
	6'b100010: controls <= 9'b /* LWL */
	6'b100011: controls <= 9'b101001000 /* LW */
	6'b100100: controls <= 9'b /* LBU */
	6'b100101: controls <= 9'b /* LHU */
	6'b100110: controls <= 9'b /* LWR */
	6'b101000: controls <= 9'b /* SB */
	6'b101001: controls <= 9'b /* SH */
	6'b101011: controls <= 9'b001010000; /* SW */
	default: controls <= 9'bxxxxxxxxx; /* ??? */
	endcase
	end
	endmodule
