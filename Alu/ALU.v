module ALU(  
    input logic[4:0] ALUControl,
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
            5'b00000  :   begin
                // logical AND 
                ALUResult = SrcA & SrcB;
            end   
            5'b00001  :   begin
                // logical OR
                ALUResult = SrcA | SrcB;
            end   
            5'b00010  :   begin
                // Addition
                ALUResult = SrcA + SrcB;
            end
            5'b00011  :   begin
                // logical XOR
                ALUResult = SrcA ^ SrcB;
            end      
            5'b00100  :   begin
                // shift left logical
                ALUResult = SrcB << SrcA;
            end   
            5'b00101  :   begin
                // shift right logical
                ALUResult = SrcB >> SrcA;
            end   
            5'b00110  :   begin
                // Subtraction
                ALUResult = SrcA - SrcB;
            end  
            5'b00111  :   begin
                // SLT (Comparison signed)
                SLT_sub = SrcA - SrcB;
                if((SLT_sub >> 31) == 1)begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end
            end
            5'b01000 :   begin
                //SRA
                ALUResult = SrcB >>> SrcA;
            end    
            5'b01001 : begin
                // SLTU (Comparison unsigned)
                if(SrcA < SrcB) begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end
            end
            5'b01010 : begin
                // is less than 0
                SLT_sub = SrcA - SrcB;
                if( SLT_sub == 0) begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end                
            end
            5'b01011 : begin
                // increment PC for branch
                ALUResult = SrcA + 8;
            end
            5'b01100 : begin
                // is SrcA < 0 
                SLT_sub = SrcA - 0;
                if((SLT_sub >> 31) == 1)begin
                    ALUResult = 1;
                end else begin
                    ALUResult = 0;
                end
            end
            5'b01101 : begin
                // needed for jumps
                ALUResult = SrcA + SrcB + 4;
            end
            5'b01110 : begin
                //pass through SrcA
                ALUResult = SrcA;
            end

            //5'b01111 /*R-type*/
            
            5'b10000 : begin
                //is SrcA <= 0
                SLT_sub = SrcA - 1;
                if((SLT_sub >> 31) == 1)begin
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
    end
endmodule