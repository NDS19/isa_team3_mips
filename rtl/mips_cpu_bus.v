module mips_cpu_bus(
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

    logic[31:0] Instr;
    logic stall;
    logic IrSel;
    logic IrWrite;
    logic IorD;
    logic AluSrcA;
    logic[1:0] AluSrcB;
    logic[4:0] ALUControl;
    logic ALUsel;
    //logic IrWrite;
    logic PCWrite;
    logic RegWrite;
    logic MemtoReg;
    logic MemWrite;
    logic PcSrc;
    logic RegDst;
    logic Is_Jump;
    logic ExtSel;
    logic OutLSB;
    logic PCIs0;
    logic[2:0] state;
    logic[31:0] PC;
    logic[31:0] Result;
    logic BranchDelay;
    logic[31:0] SrcB;
    logic[31:0] SrcA;



    Decoder Decoder_(
        .Active(active),
        .clk(clk),
        .Rst(reset),
        .Instr(Instr),
        .stall(stall),
        .IrSel(IrSel),
        .IorD(IorD),
        .ALUSrcA(AluSrcA),
        .ALUSrcB(AluSrcB),
        .ALUControl(ALUControl),
        .ALUSel(ALUsel),
        .IrWrite(IrWrite),
        .PCWrite(PCWrite),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .MemRead(read),
        .PCSrc(PcSrc),
        .RegDst(RegDst),
        .Is_Jump(Is_Jump),
        .OutLSB(OutLSB),
        .ExtSel(ExtSel),
        .byteenable(byteenable),
        .PCIs0(PCIs0),
        .waitrequest(waitrequest),
        .State(state),
        .BranchDelay(BranchDelay)
        );

    datapath datapath_(
        .clk(clk),
        .PcEn(PCWrite),
        .IorD(IorD),
        .reset(reset),
        .IrWrite(IrWrite),
        .IrSel(IrSel),
        .RegDst(RegDst),
        .ReadData(readdata),
        .MemToReg(MemtoReg),
        .RegWrite(RegWrite),
        .ALUSrcA(AluSrcA),
        .ALUSrcB(AluSrcB),
        .ExtSel(ExtSel),
        .ALUControl(ALUControl),
        .stall(stall),
        .ALUsel(ALUsel),
        .PCSrc(PcSrc),
        .OUTLSB(OutLSB),
        .Instr(Instr),
        .memloc(address),
        .writedata(writedata),
        .is_jump(Is_Jump),
        .PcIs0(PCIs0),
        .PC(PC),
        .Result(Result),
        .SrcB(SrcB),
        .SrcA(SrcA)
    );

    always @(posedge clk) begin
        $display("IrWrite = %b, Is_Jump = %b, Instr = %b, IorD = %b, State = %b IrSel = %b",IrWrite,Is_Jump,Instr,IorD, state, IrSel);
        $display("readdata = %b  address = %b read = %b",readdata, address,  read);
        $display("PC = %b Result = %b PCWrite = %b ALUsel = %b BranchDelay = %b, AluSrcB = %b AluSrcB = %b", PC, Result, PCWrite, ALUsel, BranchDelay,SrcB,AluSrcB);
        $display("SrcA = %b AluSrcA = %b ALUControl = %b",SrcA, AluSrcA, ALUControl);
    end

endmodule
