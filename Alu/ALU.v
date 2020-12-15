module ALU(
    input logic[3:0] ALUControl,
    input logic[31:0] SrcA,
    input logic[31:0] SrcB,

    output logic[31:0] ALUResult
);

    //it is assumed that sign extension happens outside the ALU. Thus for ADDI we sign extend the
    //immediate field before it reaches the ALU input and for ADDU we use ALUControl = 010.
    //This ALU does not handle exceptions.

    //varible to store subtraction result for SLT
    logic[31:0] SLT_sub;

    always_comb begin
        case (ALUControl)
            4'b0000  :   begin
                // logical AND
                ALUResult = SrcA & SrcB;
            end
            4'b0001  :   begin
                // logical OR
                ALUResult = SrcA | SrcB;
            end
            4'b0010  :   begin
                // Addition
                ALUResult = SrcA + SrcB;
            end
            4'b0011  :   begin
                // logical XOR
                ALUResult = SrcA ^ SrcB;
            end
            4'b0100  :   begin
                // shift left logical
                ALUResult = SrcB << SrcA;
            end
            4'b0101  :   begin
                // shift right logical
                ALUResult = SrcB >> SrcA;
            end
            4'b0110  :   begin
                // Subtraction
                ALUResult = SrcA - SrcB;
            end
            4'b0111  :   begin
                // SLT (Comparison signed)
                SLT_sub = SrcA - SrcB;
                if((SLT_sub >> 31) == 1)begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end
            end
            4'b1000 :   begin
                //SRA
                ALUResult = SrcB >>> SrcA;
            end
            4'b1001 : begin
                // SLTU (Comparison unsigned)
                if(SrcA < SrcB) begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end
            end
            4'b1010 : begin
                // is zero
                SLT_sub = SrcA - SrcB;
                if( SLT_sub == 0) begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end
            end
            4'b1011 : begin
                // increment PC for branch
                ALUResult = SrcA + 8;
            end
            4'b1100 : begin
                // compare SrcA to 0
                SLT_sub = SrcA - 0;
                if((SLT_sub >> 31) == 1)begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end
            end
            4'b1101 : begin
                // needed for jumps
                ALUResult = SrcA + SrcB + 4;
            end
            4'b1110 : begin
                //pass through SrcA
                ALUResult = SrcA;
            end
            default: begin
                //$display("Unknown alu operand");
                ALUResult = 32'hxxxxxxxx;
            end
        endcase
    end
endmodule
