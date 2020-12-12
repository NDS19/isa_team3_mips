module datapath (input  logic       clk, PcEn, IorD,
                 input  logic       reset,
                 input  logic       IrWrite,
                 input  logic       IrSel, RegDst,
                 input  logic       MemToReg,
                 input  logic       RegWrite, ALUSrcA,
                 input  logic[1:0]  ALUSrcB,
                 input  logic       ExtSel,
                 input  logic[3:0]  ALUControl,
                 input  logic       stall,
                 input  logic       ALUsel,
                 input  logic       PCSrc,
                 input  logic[31:0] ReadData,
                 output logic       stall,
                 output logic       OUTLSB,
                 output logic[31:0] Instr,
                 output logic[31:0] memloc,
                 output logic[31:0] writedata);

    wire [4:0]  writereg;
    wire [31:0] memloc;
    wire [31:0] irout;
    wire [31:0] wd3;
    wire [31:0] pcnext;
    wire [31:0] nextrd1, nextrd2;
    wire [31:0] rd1;
    wire [31:0] srca, srcb;
    wire [31:0] aluout;
    wire [31:0] signimm, signimmsh;
    wire [31:0] result;
    wire [31:0] SxOut, ZxOut;
    wire [31:0] branchnext;
    wire [31:0] instr;
    wire        OUTLSB = aluoutnext[0];

    assign Instr = instr;

    //next PC logic
    flopr #(32) Brreg(clk, result, branchnext);
    mux2 #(32)  brmux(result, branchnext, PCSrc, pcnext);
    pc #(32)    Pcreg(clk, reset, PcEn, pcnext, pc);
    mux2 #(32)  RegMem(pc, result, IorD, memloc);
    ir #(32)    Irreg(clk, IrWrite, ReadData, irout);

    // rigister file logic
    mux2 #(32)  muxIR(ReadData, irout, IrSel, instr);
    mux2 #(5)   muxA3(instr[20:16], instr[15:11], RegDst, writereg);
    mux2 #(32)  muxWD3(ReadData, result, MemToReg, wd3);
    regfile     rf(clk, reset, instr[25:21], instr[20:16], writereg, nextrd1, nextrd2, RegWrite, wd3);
    flopr #(32) RegA(clk, nextrd1, rd1);
    flopr #(32) RegB(clk, nextrd2, writedata);
    mux2 #(32)  alumux(nextaluout, aluout, ALUsel, result);
    signext     se(instr[15:0], SxOut);
    zeroext     ze(instr[15:0], ZxOut);
    mux2 #(32)  extmux(SxOut, ZxOut, ExtSel, signimm);
    sl2         immsh(signimm, signimmsh);

    // ALU logic
    mux4 #(32)  srcbmux(writedata, 32'b100, signimm, signimmsh ALUSrcB, srcb);
    mux2 #(32)  srcamux(pc, rd1, ALUSrcA, srca);
    ALU_all     alu(ALUControl, instr[5:0], instr[10:6], clk, srca, srcb, aluoutnext, stall);
    flopr #(32) RegALU(clk, aluoutnext, aluout);
endmodule
)