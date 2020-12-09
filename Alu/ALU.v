module ALU(  
    input logic[3:0] ALUControl,
    input logic[31:0] SrcA,
    input logic[31:0] SrcB,
    
    output logic[31:0] ALUResult,
    output logic Zero
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
                // STL
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
                //SLTU
                if(SrcA < SrcB) begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end
            end
            default: begin
                //$display("Unknown alu operand");
                ALUResult = 32'hxxxxxxxx;
            end
        endcase
        if(ALUResult == 0)begin
            Zero = 1;
        end else begin
            Zero = 0;
        end
    end
endmodule