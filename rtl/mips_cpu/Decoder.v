module Decoder(
    input logic clk,
    input logic[31:0] Instr,
    input logic stall,
    input logic OutLSB,
    input logic Rst,
    input logic PCIs0,
    input logic waitrequest,
    input logic lessthan,
    output logic stallorpc_sel,
    output logic pc_stall_en,
    output logic ExtSel,
    output logic IrSel,
   // output logic IrWrite,
    output logic IorD,
    output logic ALUSrcA,
    output logic[1:0] ALUSrcB,
    output logic[4:0] ALUControl,
    output logic ALUSel,
    output logic IrWrite,
    output logic PCWrite,
    output logic RegWrite,
    output logic MemtoReg, 
    output logic PCSrc,
    output logic RegDst,
    output logic MemWrite,
    output logic MemRead,
    output logic Active,
    output logic Is_Jump,
    output logic Link,
    output logic[3:0] byteenable,
    output logic[2:0] State,
    output logic BranchDelay,
    output logic Stall,
    output logic[1:0] extendedmem
    
  );


  logic is_branch_delay, is_branch_delay_next;
  /* Using an enum to define constants */
  typedef enum logic[5:0] {
        R_TYPE = 6'b000000,
        BLT_TYPE = 6'b000001,
        LW = 6'b100011,
        SW = 6'b101011,
        ADDIU = 6'b001001,
        ANDI = 6'b001100,
        J = 6'b000010,
        LB = 6'b100000,
        ORI = 6'b001101,
        XORI = 6'b001110,
        SLTI = 6'b001010,
        BGTZ = 6'b000111,
        BLEZ = 6'b000110,
        LBU = 6'b100100,
        LH = 6'b100001,
        LHU = 6'b100101,
        LWL = 6'b100010,
        LWR = 6'b100110,
        LUI = 6'b001111,
        //LB = 6'b100000,
       // J = 6'b000010,
        BEQ = 6'b000100,
        BNE = 6'b000101,
        SLTIU = 6'b001011,
        JAL = 6'b000011,
        SB = 6'b101000,
        SH = 6'b101001
   } opcode_t;

  /* Another enum to define CPU states. */
  typedef enum logic[2:0] {
      FETCH = 3'b000,
      DECODE = 3'b001,
      EXEC_1  = 3'b010,
      EXEC_2  = 3'b011,
      EXEC_3 = 3'b100,
      HALTED = 3'b101,
      STALL = 3'b110
  } state_t;

  /*enum for R-Type*/
  /* Using an enum to define constants */
  typedef enum logic[5:0] {
      ADDU = 6'b100001,
      AND = 6'b100100,
      OR =  6'b100101,
      MTHI = 6'b010001,
      MTLO = 6'b010011,
      MFHI = 6'b010000,
      MFLO = 6'b010010,
      JALR = 6'b001001,
      JR = 6'b001000,
      BRANCH = 6'b000001,
      MULT = 6'b011000,
      MULTU = 6'b011001,
      DIV = 6'b011010,
      DIVU = 6'b011011
  } rtype_t;

  typedef enum logic[4:0] {
      BGEZ = 5'b00001,
      BGEZAL = 5'b10001,
      BLTZ =  5'b00000,
      BLTZAL = 5'b10000
  } branch_lg;



  logic[5:0] instr_opcode;
  logic[2:0] state;
  logic[5:0] Funct;
  logic[4:0] branch_code;
  logic Extra;
  //assign byteenable = 4'b1111;
  assign State = state;
  assign BranchDelay = is_branch_delay; 
  assign Stall = stall;
  // Break-down the instruction into fields
  // these are just wires for our convenience
  logic[31:0] instr = Instr;
  assign instr_opcode = Instr[31:26];
  assign Funct = Instr[5:0];
  assign branch_code = Instr[20:16];

  //skip instruction register
  assign IrSel = (state == DECODE) ? 0 : 1;
  assign IrWrite = (state == DECODE);
  assign PCWrite = (state == FETCH) ? 1 : 0;
  assign Is_Jump = (instr_opcode == J) && (state == EXEC_1)|| (instr_opcode == JAL) && (state == EXEC_2);
  assign Link = ( (instr_opcode == JAL) || ((instr_opcode == BLT_TYPE)&&((branch_code == BLTZAL)||(branch_code == BGEZAL))) ) && (state == EXEC_1); 
  assign MemRead = (instr_opcode == LW || instr_opcode == LB || instr_opcode == LBU|| instr_opcode == LH || instr_opcode == LHU || instr_opcode == LWL|| instr_opcode == LWR) && (state == EXEC_2) || (state == FETCH) || (state == STALL);
  assign MemWrite = ((instr_opcode == SW)||(instr_opcode == SB)||(instr_opcode == SH)) && (state == EXEC_2) ;

  assign stallorpc_sel = (state == STALL);
  assign pc_stall_en = (state == FETCH);

  assign Active = state != HALTED;
  /* We are targetting an FPGA, which means we can specify the power-on value of the
      circuit. So here we set the initial state to 0, and set the output value to
      indicate the CPU is not running.
  */
  initial begin
      state = HALTED;
      is_branch_delay_next = 0;
  end

  logic halt, halt_next;

  //State machine
  always @(posedge clk) begin
      //$display("State = %b, Rst = %b, Active = %b, Instr = %b, IorD = %b",state,Rst,Active,Instr,IorD);
      //$display("MemRead = %b",MemRead);
      halt <= halt_next;
      case (state)
          // FETCH: state <= PCIs0 ? HALTED :waitrequest?STALL:DECODE;
          // STALL: state <= PCIs0 ? HALTED :waitrequest?STALL:DECODE;
          // DECODE: state <= PCIs0 ? HALTED :EXEC_1;
          // EXEC_1: state <= PCIs0 ? HALTED :stall ? EXEC_1 : Extra ? EXEC_2 : FETCH;
          // EXEC_2: state <= PCIs0 ? HALTED :waitrequest? EXEC_2 : Extra ? EXEC_3 : FETCH;
          // EXEC_3: state <= PCIs0 ? HALTED :FETCH;
          // HALTED: state <= Rst ? FETCH : HALTED;
          // default: state <= HALTED;
          FETCH: state <= waitrequest?STALL:DECODE;
          STALL: state <= waitrequest?STALL:DECODE;
          DECODE: state <= EXEC_1;
          EXEC_1: state <= (halt&&!Extra) ? HALTED :stall ? EXEC_1 : Extra ? EXEC_2 : FETCH;
          EXEC_2: state <= (halt&&!Extra) ? HALTED :waitrequest? EXEC_2 : Extra ? EXEC_3 : FETCH;
          EXEC_3: state <= halt ? HALTED :FETCH;
          HALTED: state <= Rst ? FETCH : HALTED;
          default: state <= HALTED;
      endcase
      //is_branch_delay <= write_branch_delay == 1 ? is_branch_delay_next : is_branch_delay;
      is_branch_delay <= is_branch_delay_next;
  end



  //Implement here your instructions! beware of the Extra signal. set Extra to 0 if you don't need a new state
  //Decode logic
  always_comb begin
      if (state == FETCH) begin
        halt_next = PCIs0;
      end
      else begin
        halt_next = halt;
      end


      if (Rst == 1) begin
        is_branch_delay_next = 0;
      end
      //if (instr_opcode == STALL) begin
      //  MemRead = 1;
      //end
      if (state == HALTED)begin
        byteenable = 4'b1111;
        RegWrite = 0;
      end
      if (state == STALL)begin
        RegWrite = 0;
      end
      if (state == FETCH)begin
        byteenable = 4'b1111;
        RegWrite = 0;
        //MemRead = 1;
        if (is_branch_delay == 1) begin
          PCSrc = 1;
          IorD = 0;
          Extra = 0;
        end
        else begin
          PCSrc = 0;
          IorD = 0;
          ALUSrcA = 0;
          ALUSrcB = 5'b01;
          ALUControl = 5'b00010;
          ALUSel = 0;
          //ExtSel = 0;
          Extra = 0;
        end
      end
      else if (state == DECODE) begin
        if(instr_opcode != J  && instr_opcode != JAL) begin  
          ALUSrcA = 0;
          ALUSrcB = 2'b11;
          RegWrite = 0;
          ExtSel = 0;
          ALUControl = 5'b01101;
        end
        else begin
          //ALUSrcA = 0;
          ALUSrcB = 2'b11;
          ExtSel = 1;
          ALUControl = 5'b01011; //this needs to be pass through for B
        end
      end
      else begin
          case (instr_opcode)

              R_TYPE: begin
                if (Funct == MTHI || Funct == MTLO) begin
                  case (state) 
                    EXEC_1: begin
                      ALUControl = 5'b01111;
                      Extra = 0;
                      is_branch_delay_next = 0;
                      RegWrite = 0;
                    end
                  endcase
                end
                if (Funct == MFLO || Funct == MFHI) begin
                  case (state) 
                    EXEC_1: begin
                      ALUControl = 5'b01111;
                      Extra = 0;
                      MemtoReg = 1;
                      RegDst = 1;
                      is_branch_delay_next = 0;
                      RegWrite = 1;
                    end
                  endcase
                end
                else if (Funct == JALR ) begin
                  case (state)
                    EXEC_1: begin
                      ALUSrcA = 0; //Send the PC to the ALU, the ALU needs to add 4 to it
                      ALUSrcB = 2'b01;
                      ALUControl = 5'b00010;//add opcode
                      ALUSel = 0;
                      RegDst = 1;
                      MemtoReg = 1;
                      RegWrite = 1;//write to memory the return address
                      Extra = 1;
                    end
                    EXEC_2: begin
                      ALUSrcA = 1; 
                      ALUControl = 5'b01110; //Pass through opcode, output of ALU should be SrcA
                      ALUSel = 0; //skip the ALU register
                      is_branch_delay_next = 1;
                      RegWrite = 0;
                      Extra = 0;
                      
                    end
                  endcase
                end
                else if (Funct == JR ) begin
                  case (state)
                    EXEC_1: begin
                      ALUSrcA = 1;
                      ALUControl = 5'b01110;
                      ALUSel = 0; //skip the ALU register
                      is_branch_delay_next = 1;
                      RegWrite = 0;
                      Extra = 0;
                    end
                  endcase
                end
                else if (Funct == MULT ||  Funct == DIV || Funct == DIVU || Funct == MULTU) begin
                  case (state)
                    EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b00;
                      ALUControl = 5'b01111;
                      RegWrite = 0;
                      Extra = 1;
                    end
                    EXEC_2: begin
                      RegWrite = 0;
                      Extra = 0;
                      is_branch_delay_next = 0;
                    end
                  endcase
                end
                else begin
                  case (state)
                    EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b00;
                      ALUControl = 5'b01111;
                      RegWrite = 0;
                      Extra = 1;
                    end
                    EXEC_2: begin
                      ALUSel = 1;
                      RegDst = 1;
                      MemtoReg = 1;
                      RegWrite = 1;
                      Extra = 0;
                      is_branch_delay_next = 0;
                    end
                  endcase
                end
              end
              LW: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b10;
                      ALUControl = 5'b00010;
                      RegWrite = 0;
                      ExtSel = 0;
                      Extra = 1;
                      extendedmem = 2'b00;
                  end
                  EXEC_2: begin
                      IorD = 1;
                      Extra = 1;
                      ALUSel = 1;
                      RegWrite = 0;
                      //MemRead = 1;
                      byteenable = 4'b1111;
                      extendedmem = 2'b00;
                  end
                  EXEC_3: begin
                      RegDst = 0;
                      MemtoReg = 0;
                      RegWrite = 1;
                      is_branch_delay_next = 0;
                  end
              endcase

              LUI: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b10;
                      ALUControl = 5'b10100;
                      RegWrite = 0;
                      ExtSel = 0;
                      Extra = 1;
                  end
                  EXEC_2: begin
                      IorD = 1;
                      Extra = 1;
                      ALUSel = 1;
                      RegWrite = 1;
                      RegDst = 0;
                      MemtoReg = 1;
                      Extra = 0;
                  end
              endcase

              LWL: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b10;
                      ALUControl = 5'b00010;
                      RegWrite = 0;
                      ExtSel = 0;
                      Extra = 1;
                  end
                  EXEC_2: begin
                      IorD = 1;
                      Extra = 1;
                      ALUSel = 1;
                      RegWrite = 0;
                      //MemRead = 1;
                      byteenable = 4'b1111;
                      extendedmem = 2'b00;
                  end
                  EXEC_3: begin
                      RegDst = 0;
                      MemtoReg = 1;
                      RegWrite = 1;
                      ALUSrcB = 00;
                      is_branch_delay_next = 0;
                      extendedmem = 2'b00;
                      ALUControl = 5'b10011;
                      ALUSel = 0;
                  end
              endcase

              LWR: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b10;
                      ALUControl = 5'b00010;
                      RegWrite = 0;
                      ExtSel = 0;
                      ALUSel = 0;
                      Extra = 1;
                      extendedmem = 2'b00;
                  end
                  EXEC_2: begin
                      IorD = 1;
                      Extra = 1;
                      ALUSel = 1;
                      RegWrite = 0;
                      //MemRead = 1;
                      byteenable = 4'b1111;
                      extendedmem = 2'b00;
                  end
                  EXEC_3: begin
                      ALUControl = 5'b10010;
                      RegDst = 0;
                      ALUSrcB = 00;
                      MemtoReg = 1;
                      RegWrite = 1;
                      ALUSel = 0;
                      is_branch_delay_next = 0;
                      extendedmem = 2'b00;
                  end
              endcase

              LH: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b10;
                      ALUControl = 5'b00010;
                      RegWrite = 0;
                      ExtSel = 0;
                      Extra = 1;
                  end
                  EXEC_2: begin
                      IorD = 1;
                      Extra = 1;
                      ALUSel = 1;
                      RegWrite = 0;
                      byteenable = 4'b0011;
                      extendedmem = 2'b11;
                     // MemRead = 1;
                  end
                  EXEC_3: begin
                      RegDst = 0;
                      MemtoReg = 0;
                      RegWrite = 1;
                      is_branch_delay_next = 0;
                      extendedmem = 2'b11;
                  end
              endcase

              LHU: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b10;
                      ALUControl = 5'b00010;
                      RegWrite = 0;
                      ExtSel = 0;
                      Extra = 1;
                  end
                  EXEC_2: begin
                      IorD = 1;
                      Extra = 1;
                      ALUSel = 1;
                      RegWrite = 0;
                      byteenable = 4'b0011;
                      extendedmem = 2'b00;
                     // MemRead = 1;
                  end
                  EXEC_3: begin
                      RegDst = 0;
                      MemtoReg = 0;
                      RegWrite = 1;
                      is_branch_delay_next = 0;
                      extendedmem = 2'b00;
                  end
              endcase

              LB: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b10;
                      ALUControl = 5'b00010;
                      RegWrite = 0;
                      ExtSel = 0;
                      Extra = 1;
                  end
                  EXEC_2: begin
                      IorD = 1;
                      Extra = 1;
                      ALUSel = 1;
                      RegWrite = 0;
                      byteenable = 4'b0001;
                      extendedmem = 2'b10;
                     // MemRead = 1;
                  end
                  EXEC_3: begin
                      RegDst = 0;
                      MemtoReg = 0;
                      RegWrite = 1;
                      is_branch_delay_next = 0;
                      extendedmem = 2'b10;
                  end
              endcase

              LBU: case (state)
                  EXEC_1: begin
                      ALUSrcA = 1;
                      ALUSrcB = 2'b10;
                      ALUControl = 5'b00010;
                      RegWrite = 0;
                      ExtSel = 0;
                      Extra = 1;
                  end
                  EXEC_2: begin
                      IorD = 1;
                      Extra = 1;
                      ALUSel = 1;
                      RegWrite = 0;
                      byteenable = 4'b0001;
                      extendedmem = 2'b00;
                     // MemRead = 1;
                  end
                  EXEC_3: begin
                      RegDst = 0;
                      MemtoReg = 0;
                      RegWrite = 1;
                      is_branch_delay_next = 0;
                      extendedmem = 2'b00;
                  end
              endcase

              SW: case(state)
                  EXEC_1: begin
                    ALUSrcA= 1;
                    ALUSrcB= 2'b10;
                    ALUControl = 5'b00010;
                    ExtSel = 0;
                    RegWrite = 0;
                    Extra=1;
                  end
                  EXEC_2: begin
                    IorD=1;
                    byteenable = 4'b1111;
                    //MemWrite=1;
                    is_branch_delay_next = 0;
                    RegWrite = 0;
                  end
              endcase

              SB: case(state)
                  EXEC_1: begin
                    ALUSrcA= 1;
                    ALUSrcB= 2'b10;
                    ExtSel = 0;
                    ALUControl = 5'b00010;
                    RegWrite = 0;
                    Extra=1;
                  end
                  EXEC_2: begin
                    IorD=1;
                    byteenable = 4'b0001;
                    //MemWrite=1;
                    is_branch_delay_next = 0;
                    RegWrite = 0;
                  end
              endcase

              SH: case(state)
                  EXEC_1: begin
                    ALUSrcA= 1;
                    ALUSrcB= 2'b10;
                    ExtSel = 0;
                    ALUControl = 5'b00010;
                    RegWrite = 0;
                    Extra=1;
                  end
                  EXEC_2: begin
                    IorD=1;
                    byteenable = 4'b0011;
                    //MemWrite=1;
                    is_branch_delay_next = 0;
                    RegWrite = 0;
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
                  ALUSrcA = 1;
                  ALUSrcB = 2'b10;
                  ALUControl = 5'b00001;
                  RegWrite = 0;
                  ExtSel = 1;
                  Extra = 1;
                end
                EXEC_2: begin
                  RegDst = 0;
                  MemtoReg = 1;
                  RegWrite = 1;
                  ALUSel = 1;
                  is_branch_delay_next = 0;
                  Extra= 0;
                end
              endcase

              ANDI: case(state)
                EXEC_1: begin
                  ALUSrcA = 1;
                  ALUSrcB = 2'b10;
                  ExtSel = 1; 
                  ALUControl = 5'b00000;
                  RegWrite = 0;
                  Extra = 1;
                end
                EXEC_2: begin
                  RegDst = 0;
                  MemtoReg = 1;
                  RegWrite = 1;
                  ALUSel=1;
                  is_branch_delay_next = 0;
                  Extra = 0;
                end
              endcase

              XORI: case(state)
                EXEC_1: begin
                  ALUSrcA = 1;
                  ALUSrcB = 2'b10;
                  ExtSel = 1; 
                  ALUControl = 5'b00011;
                  RegWrite = 0;
                  Extra = 1;
                end
                EXEC_2: begin
                  RegDst = 0;
                  MemtoReg = 1;
                  RegWrite = 1;
                  ALUSel=1;
                  is_branch_delay_next = 0;
                  Extra = 0;
                end
              endcase

             /* LB: case(state)
                EXEC_1: begin
                  ALUSrcA = 1;
                  ALUSrcB = 2'b10;
                  ALUControl = 5'b00010;
                  RegWrite = 0;
                  Extra = 1;
                end
                EXEC_2: begin
                  IorD = 1;
                  Extra = 1;
                  RegWrite = 0;
                end
                EXEC_3: begin
                  RegDst = 0;
                  MemtoReg = 1;
                  RegWrite = 1;
                end
              endcase*/

              SLTI: case(state)
                EXEC_1: begin
                  ALUSrcA = 1;
                  ExtSel = 0; 
                  ALUSrcB = 2'b10;
                  ALUControl = 5'b00111;
                  Extra = 1;
                  RegWrite = 0;
                end
                EXEC_2: begin
                  RegDst = 0;
                  MemtoReg = 1;
                  RegWrite = 1;
                  ALUSel = 1;
                  Extra = 0;
                  is_branch_delay_next = 0;
                end
              endcase

              SLTIU: case(state)
                EXEC_1: begin
                  ALUSrcA = 1;
                  ExtSel = 0; 
                  ALUSrcB = 2'b10;
                  ALUControl = 5'b01001;
                  Extra = 1;
                  RegWrite = 0;
                end
                EXEC_2: begin
                  RegDst = 0;
                  MemtoReg = 1;
                  RegWrite = 1;
                  ALUSel = 1;
                  Extra = 0;
                  is_branch_delay_next = 0;
                end
              endcase



              BGTZ: case(state)
                EXEC_1:begin
                  ALUSrcA=1;
                  ALUSrcB=2'b00;
                  ALUControl = 5'b10000;
                  ALUSel = 1;
                  Extra = 0;
                  RegWrite = 0;
                  is_branch_delay_next = (OutLSB == 1)?0:1;//this isnt an output 
                end
              endcase
              BLT_TYPE: begin
                case(branch_code)
                  BLTZ: case(state) //done ////branch
                    EXEC_1: begin
                      is_branch_delay_next=lessthan;
                      Extra = 0;
                      ALUSel = 1;
                      RegWrite = 0;
                    end
                  endcase

                  BLTZAL: case(state) //TODO
                    EXEC_1: begin
                      ALUSrcA = 0;
                      ALUSrcB = 2'b01;
                      ALUControl = 5'b00010;
                      Extra = 1;
                      ALUSel = 0;
                      RegWrite = 1;
                      MemtoReg = 1;
                    end
                    EXEC_2: begin
                      ALUSrcA = 0;
                      ALUSrcB = 2'b11;
                      RegWrite = 0;
                      ExtSel = 0;
                      ALUSel = 0;
                      ALUControl = 5'b01101;
                      is_branch_delay_next = lessthan;
                    end
                  endcase

                  BGEZ: case(state) //done    ///branch
                    EXEC_1: begin
                      ALUSrcA = 1;
                      ALUControl = 5'b01100;
                      is_branch_delay_next=!lessthan;
                      Extra = 0;
                      ALUSel = 1;
                      RegWrite = 0;
                    end
                  endcase

                  BGEZAL: case(state) //TODO
                    EXEC_1: begin
                      ALUSrcA = 0;
                      ALUSrcB = 2'b01;
                      ALUControl = 5'b00010;
                      Extra = 1;
                      ALUSel = 0;
                      RegWrite = 1;
                      MemtoReg = 1;
                    end
                    EXEC_2: begin
                      ALUSrcA = 0;
                      ALUSrcB = 2'b11;
                      RegWrite = 0;
                      ExtSel = 0;
                      ALUSel = 0;
                      ALUControl = 5'b01101;
                      is_branch_delay_next=!lessthan;
                    end
                  endcase

                endcase
              end

              BEQ: case(state) //done
                EXEC_1: begin
                  ALUSrcA = 1;
                  ALUSrcB = 2'b00;
                  ALUControl = 5'b01010;
                  is_branch_delay_next=OutLSB;
                  Extra = 0;
                  ALUSel = 1;
                  RegWrite = 0;
                end
              endcase

              BNE: case(state) //done
                EXEC_1: begin
                  ALUSrcA = 1;
                  ALUSrcB = 2'b00;
                  ALUControl = 5'b01010;
                  is_branch_delay_next=(OutLSB == 0)?1:0;
                  Extra = 0;
                  ALUSel = 1;
                  RegWrite = 0;
                end
              endcase

              // BGEZAL: case(state) //TODO
              //   EXEC_1: begin
              //     ALUSrcA = 1;
              //     ALUControl = 5'b01100;
              //     is_branch_delay_next=(OutLSB == 0)?1:0;
              //     Extra = 0;
              //     ALUSel = 1;
              //     RegWrite = 0;
              //   end
              // endcase

              BLEZ: case(state) //done
                EXEC_1: begin
                  ALUSrcA = 1;
                  ALUControl = 5'b10000;
                  is_branch_delay_next=(OutLSB == 1)?1:0;
                  Extra = 0;
                  ALUSel = 1;
                  RegWrite = 0;
                end
              endcase

              J: case(state)  //Done
                EXEC_1: begin
                  is_branch_delay_next = 1;
                  Extra = 0;
                  ExtSel = 1;
                  ALUSrcB = 2'b11;
                  ALUControl = 5'b10001;
                  ALUSel = 0;
                  RegWrite = 0;
                end
              endcase

              JAL: case(state)  //Done
                EXEC_1:begin
                  ALUSrcA = 0;
                  ALUSrcB = 2'b01;
                  ALUControl = 5'b00010;
                  Extra = 1;
                  ALUSel = 0;
                  RegWrite = 1;
                  RegDst = 0;
                  MemtoReg = 1;
                end
                EXEC_2: begin
                  is_branch_delay_next = 1;
                  Extra = 0;
                  ExtSel = 1;
                  ALUSrcB = 2'b11;
                  ALUControl = 5'b10001;
                  ALUSel = 0;
                  RegWrite = 0;
                end
              endcase


              ADDIU: case (state)
                EXEC_1: begin
                  ExtSel = 0;
                  ALUSrcB = 2'b10;
                  ALUSrcA = 1;
                  ALUControl = 5'b00010;
                  Extra = 1;
                  RegWrite = 0;
                end
                EXEC_2: begin
                  ALUSel = 1;
                  MemtoReg = 1;
                  RegDst = 0;
                  is_branch_delay_next = 0;
                  RegWrite = 1;
                  Extra = 0;
                end
              endcase
          endcase
      end
  end
endmodule

