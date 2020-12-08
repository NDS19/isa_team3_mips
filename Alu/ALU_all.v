module ALU_all(
    input logic[3:0] ALU_opcode,
    input logic[5:0] funct,
    input logic clk,

    input logic[31:0] SrcA,
    input logic[31:0] SrcB,

    output logic[31:0] Out,
    output logic stall
);

    //ALU block
    logic[2:0] ALUControl;
    logic[31:0] ALUResult;

    ALU alu_(.ALUControl(ALUControl), 
            .SrcA(SrcA), 
            .SrcB(SrcB),
            .ALUResult(ALUResult),
            .Zero(Zero)
    );


    //multiply and divide
    logic[31:0] Hi, Hi_next;
    logic[31:0] Lo, Lo_next;
    //Enable write of the Hi and Lo registers
    logic Hi_en;
    logic Lo_en;


    logic validIn_mul;
    logic validOut_mul;
    logic validIn_div;
    logic validOut_div;

    logic stall;
    
    logic[31:0] Mult_Hi;
    logic[31:0] Mult_Lo;
    logic[31:0] Div_Hi;
    logic[31:0] Div_Lo;

    logic Mult_sign;
    logic Div_sign;

    Mult mult_(
            .clk(clk),
            .validIn(validIn_mul),
            .sign(Mult_sign),
            .validOut(validOut_mul),
            .SrcA(SrcA), 
            .SrcB(SrcB),
            .Hi(Mult_Hi),
            .Lo(Mult_Lo)
    );

    Div div(
            .clk(clk),
            .validIn(validIn_div),
            .sign(Div_sign),
            .validOut(validOut_div),
            .SrcA(SrcA), 
            .SrcB(SrcB),
            .Hi(Div_Hi),
            .Lo(Div_Lo)
    );



    //ALU operation specified by ALUControl
    always_comb begin
        if(ALU_opcode[3] == 0)begin
            ALUControl = ALU_opcode[2:0];
            validIn_mul = 0;
            validIn_div = 0;
            Hi_en = 0;
            Lo_en = 0;
        end
        else if(ALU_opcode == 4'b1111) begin

            case(funct) /* R-type */
            6'b000000: begin
                ALUControl = 3'b100; /* SLL */
            end
            6'b000010: begin
                ALUControl = 3'b101; /* SRL */
            end
            //6'b000011: ALUControl <= 3'b101; /* SRA */          
            6'b000100: begin
                ALUControl = 3'b100; /* SLLV */
            end
            6'b000110: begin
                ALUControl = 3'b101; /* SRLV */
            end
            //6'b000111: ALUControl <= 3'b00101; /* SRAV */
            //6'b001000: ALUControl <= 3'b00110; /* JR */
            //6'b001001: ALUControl <= 3'b00111; /* JALR */
            6'b010001: begin
                ALUControl = 3'bxxx; /* MTHI */
                //TO DO 
                Hi_next = SrcA;
            end
            6'b010011: begin
                ALUControl = 3'bxxx; /* MTLO */
                //TO DO
                Lo_next = SrcA;
            end
            6'b011000: begin     /* MULT */
                ALUControl = 3'bxxx; /* MULTU */
                if (validOut_mul == 0) begin
                    validIn_mul = 1;
                    stall = 1;
                end 
                else if (validOut_mul == 1) begin
                    stall = 0;
                    validIn_mul = 0;
                    Hi_next = Mult_Hi;
                    Lo_next = Mult_Lo;
                end             
            end               
            6'b011001: begin
                ALUControl = 3'bxxx; /* MULTU */
                if (validOut_mul == 0) begin
                    validIn_mul = 1;
                    stall = 1;
                end 
                else if (validOut_mul == 1) begin
                    stall = 0;
                    validIn_mul = 0;
                    Hi_next = Mult_Hi;
                    Lo_next = Mult_Lo;
                end
            end
            6'b011010: begin  /* DIV */
                ALUControl = 3'bxxx; /* DIVU */               
                if (validOut_div == 0) begin
                    stall = 1;
                    validIn_div = 1;
                end 
                else if (validOut_div == 1) begin
                    stall = 0;
                    validIn_div = 0;
                    Hi_next = Mult_Hi;
                    Lo_next = Mult_Lo;
                end
            6'b011011: begin
                ALUControl = 3'bxxx; /* DIVU */               
                if (validOut_div == 0) begin
                    stall = 1;
                    validIn_div = 1;
                end 
                else if (validOut_div == 1) begin
                    stall = 0;
                    validIn_div = 0;
                    Hi_next = Mult_Hi;
                    Lo_next = Mult_Lo;
                end
            end
            6'b100001:begin
                ALUControl = 3'b010; /* ADDU */
            end 
            6'b100011: begin
                ALUControl = 3'b110; /* SUBU */
            end
            6'b100100: begin
                ALUControl = 3'b000; /* AND*/
            end
            6'b100101: begin
                ALUControl = 3'b001; /* OR */
            end
            6'b100110: begin
                ALUControl = 3'b011; /* XOR */
            end
            6'b101010: begin
                ALUControl = 3'b111; /* SLT */
            end
            //6'b101011: ALUControl <= 3'b10100; /* SLTU */
            default: ALUControl <= 3'bxxxxx;
            endcase

            //TO DO mulu,divu,mthi,mtlo
            if (funct != 011001) begin //MULTU
                validIn_mul = 0;
            end
            if (funct != 011011) begin //DIVU
                validIn_div = 0;
            end
            if (funct != 011001 || funct != 011011 || funct != 010001) begin
                Hi_en = 0;
            end
            if (funct != 011001 || funct != 011011 || funct != 010011) begin
                Lo_en = 0;
            end
        end
    end
    
    always_ff  @(posedge clk) begin
        Hi <= Hi_en==1?Hi_next:Hi;
        Lo <= Lo_en==1?Lo_next:Lo;
    end

endmodule