

module ALU_tb(
);
    //Inputs
    logic[31:0] SrcA, SrcB;
    logic[2:0] ALUControl;

    //Outputs
    logic[31:0] ALUResult;
    logic Zero;
    

    ALU dut(.ALUControl(ALUControl), 
            .SrcA(SrcA), 
            .SrcB(SrcB),
            .ALUResult(ALUResult),
            .Zero(Zero)
    );

    integer i;

    initial begin
        SrcA = 32'h0000000F;
        SrcB = 32'h00000003;
        ALUControl = 3'b000;  

        for(i = 0; i < 8; i= i+1) begin
            ALUControl =  i;
            #10
            $display("SrcA = %b, SrcB = %b, ALUControl = %b, ALUResult = %b , Zero = %b",SrcA,SrcB,ALUControl,ALUResult,Zero);
        end
    end


endmodule