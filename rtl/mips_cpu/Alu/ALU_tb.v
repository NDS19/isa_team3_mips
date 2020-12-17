module ALU_tb(
);
    // Outputs into ALU_all
    logic[31:0] SrcA, SrcB;
    logic[4:0] ALUControl;
    logic[31:0] instr;

    // Wires we are using to form instr
    logic[31:0] ALUResult;
    logic[5:0] funct;
    logic[4:0] shamt;

    // forming the instr word from the changing values
    assign instr[10:6] = shamt;
    assign instr[5:0] = funct;
    // make the rest of the assignments to form the instruction word


    initial begin

        $dumpfile("ALU_tb.vcd");
        $dumpvars(0,"ALU_tb.vcd");

        //BITWISE AND

        ALUControl = 5'b00000;
        SrcA = 32'b00000000000000000000000000000000;
        SrcB = 32'b10101110101011101010100010101101;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000000000000000000000000000000) else $fatal(1,"ALU_AND1 is Broken");

        #10

        ALUControl = 5'b00000;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b11101011101101100010101010111110;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11101011101101100010101010111110) else $fatal(1,"ALU_AND2 is Broken");

        #10

        ALUControl = 5'b00000;
        SrcA = 32'b10110101000101110101011010011010;
        SrcB = 32'b11101011101101100010101010111110;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b10100001000101100000001010011010) else $fatal(1,"ALU_AND3 is Broken");

        #10


        //BITWISE OR

        ALUControl = 5'b00001;
        SrcA = 32'b00000000000000000000000000000000;
        SrcB = 32'b00000000000000000000000000000000;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000000000000000000000000000000) else $fatal(1,"ALU_OR1 is Broken");

        #10

        ALUControl = 5'b00001;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b11111111111111111111111111111111;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11111111111111111111111111111111) else $fatal(1,"ALU_OR2 is Broken");

        #10

        ALUControl = 5'b00001;
        SrcA = 32'b10101111011101111010111110101101;
        SrcB = 32'b01110101110111110001010101110101;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11111111111111111011111111111101) else $fatal(1,"ALU_OR3 is Broken");

        #10

        //ADDITION

        ALUControl = 5'b00010;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000001;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000000000000000000000000000000) else $fatal(1,"ALU_ADD1 is Broken");

        #10

        ALUControl = 5'b00010;
        SrcA = 32'b10101011101010010110100101101101;
        SrcB = 32'b11110101101011010111010111010101;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b10100001010101101101111101000010) else $fatal(1,"ALU_ADD2 is Broken");

        #10

        ALUControl = 5'b00010;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b11111111111111111111111111111111;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11111111111111111111111111111110) else $fatal(1,"ALU_ADD3 is Broken");

        #10

        //XOR

        ALUControl = 5'b00011;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000000;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11111111111111111111111111111111) else $fatal(1,"ALU_XOR1 is Broken");

        #10

        ALUControl = 5'b00011;
        SrcA = 32'b00000000000000000000000000000000;
        SrcB = 32'b00000000000000000000000000000000;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000000000000000000000000000000) else $fatal(1,"ALU_XOR2 is Broken");

        #10

        ALUControl = 5'b00011;
        SrcA = 32'b10110100010010101010010100101010;
        SrcB = 32'b10111010111111010111010100000010;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00001110101101111101000000101000) else $fatal(1,"ALU_XOR3 is Broken");

        #10

        //SrcB<<SrcA SLL

        ALUControl = 5'b00100;
        shamt = 5'b00001;
        SrcB = 32'b11111111111111111111111111111111;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11111111111111111111111111111110) else $fatal(1,"ALU_SLL1 is Broken");

        #10

        ALUControl = 5'b00100;
        shamt = 5'b00000;
        SrcB = 32'b01100110101111001110011010111111;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b01100110101111001110011010111111) else $fatal(1,"ALU_SLL2 is Broken");

        #10

        ALUControl = 5'b00100;
        shamt = 5'b10000;
        SrcB = 32'b00100001011001110010100000000111;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00101000000001110000000000000000) else $fatal(1,"ALU_SLL3 is Broken");

        #10

        //SrcB>>SrcA SRL

        ALUControl = 5'b00101;
        shamt = 5'b00001;
        SrcB = 32'b11111111111111111111111111111111;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b01111111111111111111111111111111) else $fatal(1,"ALU_SRL1 is Broken");

        #10

        ALUControl = 5'b00101;
        shamt = 5'b11111;
        SrcB = 32'b10001000000000000011100000001001;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000000000000000000000000000001) else $fatal(1,"ALU_SRL2 is Broken");

        #10

        ALUControl = 5'b00101;
        shamt = 5'b00110;
        SrcB = 32'b00111001111000111010101111100000;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000000111001111000111010101111) else $fatal(1,"ALU_SRL3 is Broken");

        #10

        //SrcA-SrcB SUB UNSIGNED

        ALUControl = 5'b00110;
        SrcA = 32'b01111111111111111111111111111111;
        SrcB = 32'b11111111111111111111111111111111;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) else $fatal(1,"ALU_SUBU1 is Broken");

        #10

        ALUControl = 5'b00110;
        SrcA = 32'b00000000000000001000000000000011; //32 771
        SrcB = 32'b00000000000000000000001101101111; //879

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000000000000000111110010010100) else $fatal(1,"ALU_SUBU2 is Broken"); //31892

        #10

        ALUControl = 5'b00110;
        SrcA = 32'b01101010000110001110000000001111;
        SrcB = 32'b00000000000000000000000000000000;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b0110101000011000111000000000111) else $fatal(1,"ALU_SUBU3 is Broken");

        #10

        //SLT

        ALUControl = 5'b00111;
        SrcA = 32'b01111111111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b0) else $fatal(1,"ALU_SLT1 is Broken");

        #10

        ALUControl = 5'b00111;
        SrcA = 32'b00000000000000000010111011101110;
        SrcB = 32'b01011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b1) else $fatal(1,"ALU_SLT2 is Broken");

        #10

        ALUControl = 5'b00111;
        SrcA = 32'b00000000000000000000000000000011;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b0) else $fatal(1,"ALU_SLT3 is Broken");

        #10

        //SRA

        ALUControl = 5'b01000;
        shamt = 5'b00001;
        SrcB = 32'b11111111111111111111111111111111;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11111111111111111111111111111111) else $fatal(1,"ALU_SRA1 is Broken");

        #10

        ALUControl = 5'b01000;
        shamt = 5'b11111;
        SrcB = 32'b10001000000000000011100000001001;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11111111111111111111111111111111) else $fatal(1,"ALU_SRA2 is Broken");

        #10

        ALUControl = 5'b01000;
        shamt = 5'b00110;
        SrcB = 32'b00111001111000111010101111100000;

        $display("shamt = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",shamt,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000000111001111000111010101111) else $fatal(1,"ALU_SRA3 is Broken");

        //SLTU

        ALUControl = 5'b01001;
        SrcA = 32'b11111101111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b0) else $fatal(1,"ALU_SLTU1 is Broken");

        #10

        ALUControl = 5'b01001;
        SrcA = 32'b00000001000001000010111011101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b1) else $fatal(1,"ALU_SLTU2 is Broken");

        #10

        ALUControl = 5'b01001;
        SrcA = 32'b00000001010101010100000000000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b0) else $fatal(1,"ALU_SLTU3 is Broken");

        #10

    //IS ZERO

        ALUControl = 5'b01010;
        SrcA = 32'b11111101111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b0) else $fatal(1,"ALU_ZERO1 is Broken");

        #10

        ALUControl = 5'b01010;
        SrcA = 32'b00000001000001000010111011101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b0) else $fatal(1,"ALU_ZERO2 is Broken");

        #10

        ALUControl = 5'b01010;
        SrcA = 32'b00000001010101010100000000000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b1) else $fatal(1,"ALU_ZERO3 is Broken");

        #10

    //COMPARE SRCA TO 0

        ALUControl = 5'b01100;
        SrcA = 32'b11111101111111100010101111111111;
        SrcB = 32'b00000000000001010111110111000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b1) else $fatal(1,"ALU_CompareZero1 is Broken");

        #10

        ALUControl = 5'b01100;
        SrcA = 32'b00000001000001000010111101101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b0) else $fatal(1,"ALU_CompareZero2 is Broken");

        #10

        ALUControl = 5'b01100;
        SrcA = 32'b10000001010101010100000101000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b1) else $fatal(1,"ALU_CompareZero3 is Broken");

        #10

    //JUMP ADDITION

        ALUControl = 5'b01101;
        SrcA = 32'b01110101110111100010101111111111;
        SrcB = 32'b00000000000001010111110111000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b01110101111000111010100111000110) else $fatal(1,"ALU_JADD1 is Broken");

        #10

        ALUControl = 5'b01101;
        SrcA = 32'b00000001000001000010111101101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11100000011000011001100100101101) else $fatal(1,"ALU_JADD2 is Broken");

        #10

        ALUControl = 5'b01101;
        SrcA = 32'b00000001010101010100000101000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000010101010101000000101001010) else $fatal(1,"ALU_JADD3 is Broken");

        #10

    //PASS THROUGH

        ALUControl = 5'b01110;
        SrcA = 32'b11111101111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b11111101111111111111111111111111) else $fatal(1,"ALU_PASSTHRU1 is Broken");

        #10

        ALUControl = 4'b1110;
        SrcA = 32'b00000001000001000010111011101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000001000001000010111011101110) else $fatal(1,"ALU_PASSTHRU2 is Broken");

        #10

        ALUControl = 5'b01110;
        SrcA = 32'b00000001010101010100000000000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b",SrcA,SrcB,ALUControl,ALUResult);

        assert(ALUResult==32'b00000001010101010100000000000011) else $fatal(1,"ALU_PASSTHRU3 is Broken");

    end

    ALU dut(.ALUControl(ALUControl),
            .SrcA(SrcA),
            .SrcB(SrcB),
            .ALUResult(ALUResult)
    );

endmodule
