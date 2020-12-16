module ALU_tb(
);
    //Inputs
    logic[31:0] SrcA, SrcB;
    logic[3:0] ALUControl;

    //Outputs
    logic[31:0] ALUResult;
    

    ALU dut(.ALUControl(ALUControl), 
            .SrcA(SrcA), 
            .SrcB(SrcB),
            .ALUResult(ALUResult),
    );

    initial begin

        $dumpfile("ALU_tb.vcd");
        $dumpvars(0,"ALU_tb.vcd");

        //BITWISE AND

        ALUControl = 4'b0000;
        SrcA = 32'b00000000000000000000000000000000;
        SrcB = 32'b10101110101011101010100010101101;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b00000000000000000000000000000000) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0000;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b11101011101101100010101010111110;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b11101011101101100010101010111110) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0000;
        SrcA = 32'b10110101000101110101011010011010;
        SrcB = 32'b11101011101101100010101010111110;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b10100001000101100000001010011010) else $fatal(1,"ALU is Broken");

        #10


        //BITWISE OR 

        ALUControl = 4'b0001;
        SrcA = 32'b00000000000000000000000000000000;
        SrcB = 32'b00000000000000000000000000000000;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b00000000000000000000000000000000) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0001;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b11111111111111111111111111111111;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b11111111111111111111111111111111) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0001;
        SrcA = 32'b10101111011101111010111110101101;
        SrcB = 32'b01110101110111110001010101110101;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b11111111111111111011111111111101) else $fatal(1,"ALU is Broken");

        #10

        //ADDITION

        ALUControl = 4'b0010;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000001;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b00000000000000000000000000000000) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0010;
        SrcA = 32'b10101011101010010110100101101101;
        SrcB = 32'b11110101101011010111010111010101;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b10100001010101101101111101000010) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0010;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b11111111111111111111111111111111;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b11111111111111111111111111111110) else $fatal(1,"ALU is Broken");

        #10

        //XOR

        ALUControl = 4'b0011;
        SrcA = 32'b11111111111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000000;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b11111111111111111111111111111111) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0011;
        SrcA = 32'b00000000000000000000000000000000;
        SrcB = 32'b00000000000000000000000000000000;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b00000000000000000000000000000000) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0011;
        SrcA = 32'b10110100010010101010010100101010;
        SrcB = 32'b10111010111111010111010100000010;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b00001110101101111101000000101000) else $fatal(1,"ALU is Broken");

        #10

        //SLT

        ALUControl = 4'b0111;
        SrcA = 32'b01111111111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b0) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0111;
        SrcA = 32'b00000000000000000010111011101110;
        SrcB = 32'b01011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b1) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b0111;
        SrcA = 32'b00000000000000000000000000000011;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b0) else $fatal(1,"ALU is Broken");

        #10

        //SLTU

        ALUControl = 4'b1001;
        SrcA = 32'b11111101111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b0) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1001;
        SrcA = 32'b00000001000001000010111011101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b1) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1001;
        SrcA = 32'b00000001010101010100000000000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b0) else $fatal(1,"ALU is Broken");

        #10

    end

    //IS ZERO

        ALUControl = 4'b1010;
        SrcA = 32'b11111101111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b0) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1010;
        SrcA = 32'b00000001000001000010111011101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b0) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1010;
        SrcA = 32'b00000001010101010100000000000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b1) else $fatal(1,"ALU is Broken");

        #10

    end

    //COMPARE SRCA TO 0

        ALUControl = 4'b1100;
        SrcA = 32'b11111101111111100010101111111111;
        SrcB = 32'b00000000000001010111110111000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b1) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1100;
        SrcA = 32'b00000001000001000010111101101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b0) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1100;
        SrcA = 32'b10000001010101010100000101000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b1) else $fatal(1,"ALU is Broken");

        #10

    end

    //JUMP ADDITION

        ALUControl = 4'b1101;
        SrcA = 32'b01110101110111100010101111111111;
        SrcB = 32'b00000000000001010111110111000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b01110101111000111010100111000110) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1101;
        SrcA = 32'b00000001000001000010111101101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b11100000011000011001100100101101) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1101;
        SrcA = 32'b00000001010101010100000101000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b00000010101010101000000101001010) else $fatal(1,"ALU is Broken");

        #10

    end

    //PASS THROUGH

        ALUControl = 4'b1110;
        SrcA = 32'b11111101111111111111111111111111;
        SrcB = 32'b00000000000000000000000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b11111101111111111111111111111111) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1110;
        SrcA = 32'b00000001000001000010111011101110;
        SrcB = 32'b11011111010111010110100110111011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b00000001000001000010111011101110) else $fatal(1,"ALU is Broken");

        #10

        ALUControl = 4'b1110;
        SrcA = 32'b00000001010101010100000000000011;
        SrcB = 32'b00000001010101010100000000000011;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        assert(ALUResult==32'b00000001010101010100000000000011) else $fatal(1,"ALU is Broken");

        #10

        //DUD OPCODE

        ALUControl = 4'b1111;
        SrcA = 32'b00000000000000000000000000000000;
        SrcB = 32'b00000000000000000000000000000000;

        $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);

        #10

    end


endmodule
