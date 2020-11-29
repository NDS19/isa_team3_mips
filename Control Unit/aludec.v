module aludec(
      input[5:0] funct,
      input[1:0] aluop,
      outpu reg [4:0] alucontrol);

always_ff @(posedge clk)begin
  case(aluop)
   2'b00: alucontrol <= 5'b010;
   2'b01: alucontrol <= 5'b110;
   default: case(funct) /* R-type */
            6'b000000: alucontrol <= 5'b00000; /* SLL */
            6'b000010: alucontrol <= 5'b00001; /* SRL */
            6'b000011: alucontrol <= 5'b00010; /* SRA */
            6'b000100: alucontrol <= 5'b00011; /* SLLV */
            6'b000110: alucontrol <= 5'b00100; /* SRLV */
            6'b000111: alucontrol <= 5'b00101; /* SRAV */
            6'b001000: alucontrol <= 5'b00110; /* JR */
            6'b001001: alucontrol <= 5'b00111; /* JALR */
            6'b010001: alucontrol <= 5'b01000; /* MTHI */
            6'b010011: alucontrol <= 5'b01001; /* MTLO */
            6'b011000: alucontrol <= 5'b01010; /* MULT */
            6'b011001: alucontrol <= 5'b01011; /* MULTU */
            6'b011010: alucontrol <= 5'b01100; /* DIV */
            6'b011011: alucontrol <= 5'b01101; /* DIVU */
            6'b100001: alucontrol <= 5'b01110; /* ADDU */
            6'b100011: alucontrol <= 5'b01111; /* SUBU */
            6'b100100: alucontrol <= 5'b10000; /* AND*/
            6'b100101: alucontrol <= 5'b10001; /* OR */
            6'b100110: alucontrol <= 5'b10010; /* XOR */
            6'b101010: alucontrol <= 5'b10011; /* SLT */
            6'b101011: alucontrol <= 5'b10100; /* SLTU */
            default: alucontrol <= 5'bxxxxx;
            endcase
    endcase
    end
    endmodule
