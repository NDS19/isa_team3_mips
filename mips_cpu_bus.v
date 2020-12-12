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


logic Instr;
logic stall;
logic IrSel;
logic IrWrite;
logic IorD;
logic AluSrcA;
logic AluSrcB;
logic ALUControl;
logic ALUsel;
logic IrWrite;
logic PCWrite;
logic RegWrite;
logic MemtoReg;
logic MemWrite;
logic PcSrc;
logic RegDst;




Decoder Decoder_( 
    .clk(clk),
    .Instr(Instr),
    .stall(stall),
    .IrSel(IrSel),
    .IrWrite(IrWrite),
    .IorD(IorD),
    .AluSrcA(AluSrcA),
    .AluSrcB(AluSrcB),
    .ALUControl(ALUControl),
    .ALUsel(ALUsel),
    .IrWrite(IrWrite),
    .PCWrite(PCWrite),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite)
    .PcSrc(PcSrc)
    .RegDst(RegDst)
    );

datapath datapath_(
    .clk(clk)
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
    //.ExtSel(),
    .ALUControl(ALUControl),
    .stall(stall),
    .ALUsel(ALUsel),
    .PCSrc(PcSrc),
    //.OUTLSB(),
    .Instr(Instr),
    .memloc(address),
    .writedata(writedata)

)

endmodule
)


