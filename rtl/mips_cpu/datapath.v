module datapath (input  logic       clk, PcEn, IorD,
                 input  logic       reset,
                 input  logic       IrWrite,
                 input  logic       IrSel, 
                 input  logic       RegDst,
                 input  logic       MemToReg,
                 input  logic       RegWrite, 
                 input  logic       ALUSrcA,
                 input  logic[1:0]  ALUSrcB,
                 input  logic       ExtSel,
                 input  logic[4:0]  ALUControl,
                 input  logic[1:0]  MemExt,
                // input  logic       stall,
                 input  logic       ALUsel,
                 input  logic       PCSrc,
                 input  logic[31:0] ReadData,
                 input  logic       is_jump,
                 input  logic       Link,
                 output logic       stall,
                 output logic       OUTLSB,
                 output logic[31:0] Instr,
                 output logic[31:0] memloc,
                 output logic[31:0] writedata,
                 output logic       PcIs0,
                 output logic[31:0] Register0,
                 output logic[31:0] PC,
                 output logic[31:0] Result,
                 output logic[31:0] SrcB,
                 output logic[31:0] SrcA,
                 output logic[31:0] BranchNext,
                 output logic       lessthan
                 );

    wire [4:0]  writereg;
    wire [31:0] inp_mem;
    wire [31:0] irout;
    wire [31:0] wd3;
    wire [31:0] pcnext;
    wire [31:0] nextrd1, nextrd2;
    wire [31:0] rd1;
    wire [31:0] srca, srcb;
    wire [31:0] aluout, aluoutnext;
    wire [31:0] signimm, signimmsh;
    wire [31:0] result;
    wire [31:0] SxOut, ZxOut;
    wire [31:0] branchnext;
    wire [31:0] instr;
    wire [31:0] pc;

    logic signed [31:0] rd1_signed;
    assign rd1_signed = rd1;
    assign lessthan = rd1_signed < 0;

    wire [31:0] memsign16;
    wire [31:0] memsign24;
    wire [31:0] extendedmem;

    assign memsign16 = { {16{ReadData[15]}},ReadData[15:0]};
    //assign memsign16 = ReadData[15]?{16'b1111111111111111,ReadData[15:0]}:{16'b0000000000000000,ReadData[15:0]};
    assign memsign24 = { {24{ReadData[7]}},ReadData[7:0]};
    //assign memsign24 = ReadData[23]?{24'b111111111111111111111111,ReadData[7:0]}:{24'b000000000000000000000000,ReadData[7:0]};
    assign extendedmem = MemExt[1]==0?ReadData:MemExt[0]?memsign16:memsign24;


    assign PcIs0 = pc == 0;
    assign PC = pc;
    assign Result = result;
    assign SrcB = srcb;
    assign SrcA = srca;
    assign BranchNext = branchnext;


    assign OUTLSB = aluout[0];

    assign Instr = instr;

    //next PC logic
    flopr #(32) Brreg(clk, result, branchnext);
    mux2 #(32)  brmux(result, branchnext, PCSrc, pcnext);
    pc          Pcreg(clk, reset, PcEn, pcnext, pc, is_jump);
    mux2 #(32)  RegMem(pc, result, IorD, memloc);
    ir #(32)    Irreg(clk, IrWrite, ReadData, irout);

    // rigister file logic
    mux2 #(32)  muxIR(ReadData, irout, IrSel, instr);
    mux2 #(5)   muxA3(instr[20:16], instr[15:11], RegDst, writereg);
    mux2 #(32)  muxWD3(extendedmem, result, MemToReg, wd3);

    logic[4:0] regWritewithlink;
    assign regWritewithlink = Link?5'b11111:writereg;
    register_file     rf(clk, reset, instr[25:21], instr[20:16], regWritewithlink, nextrd1, nextrd2, RegWrite, wd3, Register0);
    flopr #(32) RegA(clk, nextrd1, rd1);
    flopr #(32) RegB(clk, nextrd2, writedata);
    mux2 #(32)  alumux(aluoutnext, aluout, ALUsel, result);
    signext     se(instr[15:0], SxOut);
    zeroext     ze(instr[15:0], ZxOut);
    mux2 #(32)  extmux(SxOut, ZxOut, ExtSel, signimm);
    sl2         immsh(signimm, signimmsh);

    // ALU logic
    mux4 #(32)  srcbmux(writedata, 32'b100, signimm, signimmsh, ALUSrcB, srcb);
    mux2 #(32)  srcamux(pc, rd1, ALUSrcA, srca);
    ALU_all     alu(ALUControl, instr, clk, srca, srcb, ReadData, aluoutnext, stall);
    flopr #(32) RegALU(clk, aluoutnext, aluout);
endmodule
