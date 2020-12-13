module Decoder(
    input logic clk,
    input logic[31:0] Instr,
    input logic stall,
    input logic OutLSB,
    input logic Rst,
    output logic IrSel,
    output logic IrWrite,
    output logic IorD,
    output logic AluSrcA,
    output logic[1:0] AluSrcB,
    output logic[3:0] ALUControl,
    output logic ALUSel,
    output logic IrWrite,
    output logic PCWrite,
    output logic RegWrite,
    output logic MemtoReg,
    output logic PcSrc,
    output logic RegDst,
    output logic MemWrite
);


  logic is_branch_delay, is_branch_delay_next;
  /* Using an enum to define constants */
  typedef enum logic[5:0] {
        R_TYPE = 6'b000000;
        BLT_TYPE = 6'b000001;
        LW = 6'b100011;
        SW = 6'b101011;
        ADDIU = 6'b001001;
        ANDI = 6'001100;
        J = 6'b000010;
        LB = 6'b100000;
        ORI = 6'b001101;
        SLTI = 6'b001010;
        BGTZ = 6'b000111;
        BLEZ = 6'b000110;
        J = 6'b000010;
        SLTIU = 6'b101000;
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
      MTHI = 6'b010001;
      MTLO = 6'b010011;
      JALR = 6'b000001;
      JR = 6'b001000;
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
  assign PCWrite = (instr_opcode == FETCH) ? 1 : 0;

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
          EXEC_1: state <= stall ? EXEC_1 : Extra ? EXEC_2 : FETCH;
          EXEC_2: state <= Extra ? EXEC_3 : FETCH;
          EXEC_3: state <= FETCH;
          HALTED: state <= Rst ? FETCH : HALTED;
          default: HALTED;
      endcase
      //is_branch_delay <= write_branch_delay == 1 ? is_branch_delay_next : is_branch_delay;
      is_branch_delay <= is_branch_delay_next;
  end



  //Implement here your instructions! beware of the Extra signal. set Extra to 0 if you don't need a new state
  //Decode logic
  always_comb begin
      if (Rst == 1) begin
        is_branch_delay_next = 1;
      end
      if (instr_opcode == FETCH)begin
        if (is_branch_delay == 1) begin
          PCSrc = 1;
          IorD = 0;
          Extra = 0;
        end
        else begin
          PCSrc = 0;
          IorD = 0;
          AluSrcA = 0;
          AluSrcB = 01;
          ALUControl = 0010;
          ALUSel = 0;
          Extra = 0;
        end
      end
      else if (state == DECODE) begin
          AluSrcA = 0;
          AluSrcB = 11;
          ALUControl = 0010;
      end
      else begin
          case (instr_opcode)

              R_TYPE: if (Funct == MTHI || Funct == MTLO) begin
                  case (state) 
                    EXEC_1: begin
                      extra = 0;
                    end
                  endcase
                end
                else if (Funct == JALR ) begin
                  case (state)
                    EXEC_1: begin
                      ALUSrcA = 0; //Send the PC to the ALU, the ALU needs to add 8 to it
                      ALUControl = 1111;
                      Extra = 1;
                    end
                    EXEC_2: begin
                      ALUsel = 1;
                      RegDst = 1;
                      MemtoReg = 1;
                      RegWrite = 1;
                      Extra = 1;
                    end
                    EXEC_3: begin
                      ALUSrcA = 1; 
                      ALUControl = 1110; //Pass through opcode, output of ALU should be SrcA
                      is_branch_delay_next = 1;
                    end
                  endcase
                end
                else if (Funct == JR ) begin
                  case (state)
                    EXEC_1: begin
                      ALUSrcA = 1;
                      ALUControl = 1110;
                      is_branch_delay_next = 1;
                      Extra = 0;
                    end
                  endcase
                end
                else begin
                  case (state)
                    EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 00;
                      ALUControl = 1111;
                      Extra = 1;
                    end
                    EXEC_2: begin
                      ALUsel = 1;
                      RegDst = 1;
                      MemtoReg = 1;
                      RegWrite = 1;
                      Extra = 0;
                    end
                  endcase
                end

              LW: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      AluSrcB = 10;
                      ALUControl = 0010;
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

              SW: case(state)
                  EXEC_1: begin
                    ALUSrcA= 1;
                    ALUSrcB= 10;
                    ALUControl = 0010;
                    Extra=1;
                  end
                  EXEC_2: begin
                    IorD=1;
                    MemWrite=1;
                  end
              endcase

              /*J: case(state)
                EXEC_1: begin
                  PCSrc=1;
                  PCWrite=1;
                end
              endcase*/

              ORI: case(state)
                EXEC_1: begin
                  ALUSrcA=1;
                  ALUSrcB=10;
                  ALUControl= 0001;
                  Extra=1;
                end
                EXEC_2: begin
                  RegDst=0;
                  MemtoReg=0;
                  RegWrite=1;
                  Extra=0;
                end
              endcase

              ANDI: case(state)
                EXEC_1: begin
                  ALUSrcA=1;
                  ALUSrcB=10;
                  ExtSel=0; 
                  ALUControl= 0000;
                  Extra=1;
                end
                EXEC_2: begin
                  RegDst=0;
                  MemtoReg=1;
                  RegWrite=1;
                  ALUsel=1;
                  Extra=0;
                end
              endcase

              LB: case(state)
                EXEC_1: begin
                  ALUSrcA = 1;
                  AluSrcB = 10;
                  ALUControl = 0010;
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

              SLTI: case(state)
                EXEC_1: begin
                  ALUSrcA=1;
                  ALUSrcB=10;
                  ALUControl=0111;
                  Extra=1;
                end
                EXEC_2: begin
                  RegDst=0;
                  MemtoReg=0;
                  RegWrite=1;
                  Extra=0;
                end
              endcase


              BGTZ: case(state)
                EXEC_1:begin
                  ALUSrcA=1;
                  ALUSrcB=00;
                  ALUControl=0111;
                  PCSrc=1;//this should not be set other than in fetch 
                  Branch=1;//this isnt an output 
                end
              endcase

              BLEZ: case(state) //done
                EXEC_1: begin
                  ALUSrcA = 1;
                  ALUControl = 1100;
                  is_branch_delay_next=(OutLSB == 1)?1:0;
                  Extra = 0;
                  ALUsel = 1;
                end
              endcase

              J: case(state)  //Done
                EXEC_1: begin
                  is_branch_delay_next = 1;
                  Extra = 0;
                  ALUsel = 1;
                end
              endcase

              SLTIU: case(state)  //Done
                EXEC_1: begin
                  is_branch_delay_next=1;
                  ALUSrcA = 1;
                  ALUSrcB = 10;
                  ExtSel = 1
                  ALUControl= 1001;
                  Extra = 1;
                  ALUsel= 0;
                end
                EXEC_2:begin
                  ALUSel = 1;
                  MemtoReg = 1;
                  RegDst = 1;
                  Extra = 0;
                  RegWrite = 1; 
                  is_branch_delay_next = 0;
                end
              endcase

              ADDIU: case (state)
                EXEC_1: begin
                  ExtSel = 1;
                  ALUSrcB = 10;
                  ALUSrcA = 1;
                  ALUControl = 0010;
                  Extra = 1;
                end
                EXEC_2: begin
                  AluSel = 1;
                  MemtoReg = 1;
                  RegDst = 1;
                  is_branch_delay_next = 0;
                  RegWrite = 1;
                  Extra = 0;
                end
              endcase
          endcase
      end
  end
endmodule

