module ALU_all(
    input logic[4:0] ALU_Control,
    input logic[31:0] instr,
    //input logic[5:0] funct,
    //input logic[4:0] shamt,
    input logic clk,

    input logic[31:0] SrcA,
    input logic[31:0] SrcB,

    //LWL and LWR
    input logic[31:0] ramdata,

    output logic[31:0] Out,
    output logic stall
);
    logic[5:0] funct;
    logic[4:0] shamt;
    logic[5:0] opcode;

    assign opcode = instr[31:26];
    //ALU block
    logic[4:0] ALU_OPCODE;
    logic[31:0] ALUResult;

    assign shamt = instr[10:6];
    assign funct = instr[5:0];

    ALU alu_(.ALUControl(ALU_OPCODE),
            .SrcA(SrcA_to_ALU),
            .SrcB(SrcB_to_ALU),
            .ALUResult(ALUResult)
    );

    //shamt field for shift instructions
    logic[31:0] SrcB_to_ALU;
    logic[31:0] SrcA_to_ALU;



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

   // logic stall;

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


    assign stall = (ALU_Control == 5'b01111)&((funct == 6'b011000) || (funct == 6'b011001) || (funct == 6'b011010) || (funct == 6'b011011)) & (validOut_mul == 0);
    //ALU operation specified by ALU_OPCODE
    always_comb begin
        if(ALU_Control != 5'b01111)begin
            ALU_OPCODE = ALU_Control;
            validIn_mul = 0;
            validIn_div = 0;
            Hi_en = 0;
            Lo_en = 0;
            if ((ALU_Control == 5'b10010) || (ALU_Control == 5'b10011)) begin
                SrcB_to_ALU = SrcB;
                SrcA_to_ALU = ramdata;
                //Out = ALUResult;
            end else begin
                //shamt not required for non R-type instructions
                SrcB_to_ALU = SrcB;
                SrcA_to_ALU = (ALU_Control == 5'b10001)?instr:SrcA;
                //Out = ALUResult;
                //Out is always ALUResult for non R-type instructions
            end
            Out = ALUResult;
        end
        else if(ALU_Control == 5'b01111) begin

            case(funct) /* R-type */
            6'b000000: begin
                ALU_OPCODE = 5'b00100; /* SLL */
                Out = ALUResult;
            end
            6'b000010: begin
                ALU_OPCODE = 5'b00101; /* SRL */
                Out = ALUResult;
            end
            6'b000011: begin
                ALU_OPCODE = 5'b01000; /* SRA */
                Out = ALUResult;
            end
            6'b000100: begin
                ALU_OPCODE = 5'b00100; /* SLLV */
                Out = ALUResult;
            end
            6'b000110: begin
                ALU_OPCODE = 5'b00101; /* SRLV */
                Out = ALUResult;
            end
            6'b000111: begin
                ALU_OPCODE = 5'b01000; /* SRAV */
                Out = ALUResult;
            end
            //6'b001000: ALU_OPCODE  <= 5'b000110; /* JR */
            //6'b001001: ALU_OPCODE  <= 5'b000111; /* JALR */
            6'b010001: begin
                ALU_OPCODE = 5'bxxxxx; /* MTHI */
                //TO DO
                Hi_next = SrcA;
            end
            6'b010011: begin
                ALU_OPCODE = 5'bxxxxx; /* MTLO */
                //TO DO
                Lo_next = SrcA;
            end
            6'b010000: begin
                ALU_OPCODE = 5'bxxxxx; /* MFHI */
                //implemented in assign statement on line 23
            end
            6'b010010: begin
                ALU_OPCODE = 5'bxxxxx; /* MFLO */
                //implemented in assign statement on line 23
            end
            6'b011000: begin     /* MULT */
                ALU_OPCODE  = 5'bxxxxx;
                Mult_sign = 1;
                if (validOut_mul == 0) begin
                    validIn_mul = 1;
                    //stall = 1;
                end
                else if (validOut_mul == 1) begin
                    //stall = 0;
                    validIn_mul = 0;
                    Hi_next = Mult_Hi;
                    Lo_next = Mult_Lo;
                end
            end

            6'b011001: begin
                ALU_OPCODE = 5'bxxxxx; /* MULTU */
                Mult_sign = 0;
                if (validOut_mul == 0) begin
                    validIn_mul = 1;
                    //stall = 1;
                end
                else if (validOut_mul == 1) begin
                    //stall = 0;
                    validIn_mul = 0;
                    Hi_next = Mult_Hi;
                    Lo_next = Mult_Lo;
                end
            end
            6'b011010: begin  /* DIV */
                Div_sign = 1;
                ALU_OPCODE = 5'bxxxxx;
                if (validOut_div == 0) begin
                    //stall = 1;
                    validIn_div = 1;
                end
                else if (validOut_div == 1) begin
                    //stall = 0;
                    validIn_div = 0;
                    Hi_next = Mult_Hi;
                    Lo_next = Mult_Lo;
                end
            end
            6'b011011: begin
                Div_sign = 0;
                ALU_OPCODE = 5'bxxxxx; /* DIVU */
                if (validOut_div == 0) begin
                    //stall = 1;
                    validIn_div = 1;
                end
                else if (validOut_div == 1) begin
                    //stall = 0;
                    validIn_div = 0;
                    Hi_next = Mult_Hi;
                    Lo_next = Mult_Lo;
                end
            end
            6'b100001:begin
                ALU_OPCODE = 5'b00010; /* ADDU */
                Out = ALUResult;
            end
            6'b100011: begin
                ALU_OPCODE= 5'b00110; /* SUBU */
                Out = ALUResult;
            end
            6'b100100: begin
                ALU_OPCODE = 5'b00000; /* AND*/
                Out = ALUResult;
            end
            6'b100101: begin
                ALU_OPCODE= 5'b00001; /* OR */
                Out = ALUResult;
            end
            6'b100110: begin
                ALU_OPCODE= 5'b00011; /* XOR */
                Out = ALUResult;
            end
            6'b101010: begin
                ALU_OPCODE= 5'b00111; /* SLT */
                Out = ALUResult;
            end
            6'b101011: begin
                ALU_OPCODE = 5'b01001; /* SLTU */
                Out = ALUResult;
            end
            default: ALU_OPCODE = 5'bxxxxx;
            endcase

            //TO DO mulu,divu,mthi,mtlo
            if (funct != 6'b011001) begin //MULTU
                validIn_mul = 0;
            end
            if (funct != 6'b011011) begin //DIVU
                validIn_div = 0;
            end
            if (funct != 6'b011001 || funct != 6'b011011 || funct != 6'b010001) begin
                Hi_en = 0;
            end
            if (funct != 6'b011001 || funct != 6'b011011 || funct != 6'b010011) begin
                Lo_en = 0;
            end

            //shamt field for functions that require it
            //          SLL,                SRL,                SRA,
            if(funct == 6'b000000 || funct == 6'b000010 || funct == 6'b000011)begin
                SrcA_to_ALU = { 27'b000000000000000000000000000, shamt};
                SrcB_to_ALU= SrcB;
            end else begin
                SrcB_to_ALU = SrcB;
                SrcA_to_ALU = SrcA;
            end

            //implementation of MFHI and MFLO, assiging Out to right input
            //           MFHI
            if (funct == 6'b010000 ) begin
                Out = Hi;
            //                    MFLO
            end else if (funct == 6'b010010) begin
                Out = Lo;
            end else begin
                Out = ALUResult;
            end

        end
    end

    always_ff  @(posedge clk) begin
        Hi <= Hi_en==1?Hi_next:Hi;
        Lo <= Lo_en==1?Lo_next:Lo;
    end

endmodule
