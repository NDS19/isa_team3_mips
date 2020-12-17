module register_file(
  input logic clk,
  input logic reset,

  input logic[4:0] a1, a2, write_index3,
  output logic[31:0] read_data1, read_data2,

  input logic write_enable,
  input logic[31:0] write_data3,

  output logic[31:0] Register0
);

logic[31:0] regs[31:0];
/* 32 registers of 32 bits inside register file
*/
logic[31:0] reg_0,reg_1,reg_2;
assign reg_0 = regs[0];
assign reg_1 = regs[1];
assign reg_2 = regs[2];

assign read_data1 = (a1!=0)? regs[a1]:0;
assign read_data2 = (a2!=0)? regs[a2]:0;

assign Register0 = regs[2];

integer index;
always @(posedge clk) begin
  $display("write_index3 = %b write_enable = %b write_data3 = %b",write_index3, write_enable, write_data3);
  if(reset==1) begin
    for(index=0;index<33;index= index+1)begin
      regs[index]<=0;
    end
  end
  if(write_enable==1&write_index3!==5'b000000) begin
    regs[write_index3]<=write_data3;
    end
  end

endmodule
