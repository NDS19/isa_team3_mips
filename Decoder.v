module Decoder(
    input logic clk,
    input logic[31:0] Instr,
    output logic IrSel,
    output logic IrWrite,
    output logic IorD,
    output logic AluSrcA,
    output logic[1:0] AluSrcB,
    output logic ALUOp,
    output logic ALUsel,
    output logic IrWrite,
    output logic PCWrite,
    output logic RegWrite,
    output logic MemtoReg,
);

    


    /* Using an enum to define constants */
    typedef enum logic[3:0] {
        R_TYPE = 6'b000000;
        LW = 6'b100011;
        SW = 6'b101011;
        ADDIU = 6'b001001; 
        ANDI = 6'001100;      
    } opcode_t;

   /* Another enum to define CPU states. */
    typedef enum logic[2:0] {
        FETCH = 3'b000,
        DECODE = 3'b001,
        EXEC_1  = 3'b010,
        EXEC_2  = 3'b011,
        EXEC_3 = 3'b100,
        HALTED = 3'b101
    } state_t;

    /*enum for R-Type*/
    /* Using an enum to define constants */
    typedef enum logic[5:0] {
        ADDU = 6'b100001;
        AND = 6'b100100;
        OR =  6'b100101;        
    } rtype_t;



    opcode_t instr_opcode;
    state_t state;
    rtype_t Funct;    
    logic Extra;
    

    // Break-down the instruction into fields
    // these are just wires for our convenience
    assign instr_opcode = instr[31:26];
    assign Funct = instr[5:0];
    
    //skip instruction register 
    assign IrSel = (instr_opcode == DECODE) ? 0 : 1;


    /* We are targetting an FPGA, which means we can specify the power-on value of the
        circuit. So here we set the initial state to 0, and set the output value to
        indicate the CPU is not running.
    */
    initial begin
        state = HALTED;
    end
    
    //State machine
    always_ff @(posedge clk) begin
       case (state)
           FETCH: state <= DECODE;
           DECODE: state <= EXEC_1;
           EXEC_1: state <= Extra ? EXEC_2 : FETCH;
           EXEC_2: state <= Extra ? EXEC_3 : FETCH;
           EXEC_3: state <= FETCH;
           default: HALTED;
       endcase      
    end


    
    //Implement here your instructions! beware of the Extra signal. set Extra to 0 if you don't need a new state
    //Decode logic
    always_comb begin
        if (instr_opcode == FETCH)begin
            IorD = 0;
            AluSrcA = 0;
            AluSrcB = 01;
            ALUOp = 00;
            ALUsel = 0;
            PCWrite = 1;
            Extra = 0; 
        end
        else if (state == DECODE) begin           
            AluSrcA = 0;
            AluSrcB = 11;
            ALUOp = 00;                   
        end
        else begin      
            case (instr_opcode)

                R_TYPE: case (state)
                    EXEC_1: begin
                        ALUSrcA = 1;
                        ALUSrcB = 00;
                        ALUOp = 10;
                        Extra = 1;
                    end
                    EXEC_2: begin
                        RegDst = 1;
                        MemtoReg = 0;
                        RegWrite = 1;
                    end
                endcase
                
                LW: case (state)                   
                    EXEC_1: begin
                        ALUSrcA = 1;
                        AluSrcB = 10;
                        ALUOp = 00;
                        Extra = 1;
                    end
                    EXEC_2: begin
                        IorD = 1;
                        Extra = 1;
                    end
                    EXEC_3: begin
                        RegDst = 0;
                        MemtoReg = 1;
                        RegWrite = 1;
                    end
                endcase 

                SW: case (state)
                    EXEC_1: begin
                        ALUSrcA = 1;
                        AluSrcB = 10;
                        ALUOp = 00;
                        Extra = 1;
                    end 
                    EXEC_2: begin
                        IorD = 1;
                    end
                endcase
            endcase
        end
    end


endmodule



            IorD <= 0;
            AluSrcA <= 0;
            AluSrcB <= 01;
            ALUOp <= 00;
            ALUsel <= 0;
            PCWrite <= 1;