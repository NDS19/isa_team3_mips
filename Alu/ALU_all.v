module ALU_all(
    input logic[3:0] ALU_Control,
    input logic[5:0] funct,
    input logic[4:0] shamt,
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
            .SrcB(SrcB_to_ALU),
            .ALUResult(ALUResult),
            .Zero(Zero)
    );


    //shamt field for shift instructions
    logic[31:0] SrcB_to_ALU;



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
        if(ALU_Control[3] == 0)begin
            ALUControl = ALU_Control[2:0];
            validIn_mul = 0;
            validIn_div = 0;
            Hi_en = 0;
            Lo_en = 0;

            //shamt not required for non R-type instructions
            SrcB_to_ALU = SrcB;
        end
        else if(ALU_Control == 4'b1111) begin

            case(funct) /* R-type */
            6'b000000: begin
                ALUControl = 4'b0100; /* SLL */
            end
            6'b000010: begin
                ALUControl = 4'b0101; /* SRL */
            end
            6'b000011: begin
                ALUControl = 4'b1000; /* SRA */  
            end        
            6'b000100: begin
                ALUControl = 4'b0100; /* SLLV */
            end
            6'b000110: begin
                ALUControl = 4'b0101; /* SRLV */
            end
            6'b000111: begin
                ALUControl = 4'b1000; /* SRAV */
            end
            //6'b001000: ALUControl <= 4'b00110; /* JR */
            //6'b001001: ALUControl <= 4'b00111; /* JALR */
            6'b010001: begin
                ALUControl = 4'bxxxx; /* MTHI */
                //TO DO 
                Hi_next = SrcA;
            end
            6'b010011: begin
                ALUControl = 4'bxxxx; /* MTLO */
                //TO DO
                Lo_next = SrcA;
            end
            6'b011000: begin     /* MULT */
                ALUControl = 4'bxxxx; /* MULTU */
                Mult_sign = 1;
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
                ALUControl = 4'bxxxx; /* MULTU */
                Mult_sign = 0;
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
                Div_sign = 1;
                ALUControl = 4'bxxxx; /* DIVU */               
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
                Div_sign = 0;
                ALUControl = 4'bxxxx; /* DIVU */               
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
                ALUControl = 4'b0010; /* ADDU */
            end 
            6'b100011: begin
                ALUControl = 4'b0110; /* SUBU */
            end
            6'b100100: begin
                ALUControl = 4'b0000; /* AND*/
            end
            6'b100101: begin
                ALUControl = 4'b0001; /* OR */
            end
            6'b100110: begin
                ALUControl = 4'b0011; /* XOR */
            end
            6'b101010: begin
                ALUControl = 4'b0111; /* SLT */
            end
            6'b101011: begin
                ALUControl <= 4'b1001; /* SLTU */
            end
            default: ALUControl <= 4'bxxxx;
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

            //shamt field for functions that require it
            //          SLL,                SRL,                SRA,
            if(funct == 000000 || funct == 000010 || funct == 000010)begin
                SrcB_to_ALU = { 3'b000, 24'h000000, shamt}
            end else begin
                SrcB_to_ALU = SrcB
            end
              


        end
    end
    
    always_ff  @(posedge clk) begin
        Hi <= Hi_en==1?Hi_next:Hi;
        Lo <= Lo_en==1?Lo_next:Lo;
    end

endmodule