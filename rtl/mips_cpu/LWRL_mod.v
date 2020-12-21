module LWRL_mod(
    input logic[31:0] SrcA,
    input logic[31:0] SrcB,
    input logic[2:0] byte_number,
    output logic[31:0] LWL,
    output logic[31:0] LWR
);

assign LWL = (byte_number == 3'b001)?32'hFFFF:32'h0000 & ({SrcA[31:24],SrcB[23:0]}) ||
              (byte_number == 3'b010)?32'hFFFF:32'h0000 & ({SrcA[31:16],SrcB[15:0]}) ||
              (byte_number == 3'b011)?32'hFFFF:32'h0000 & ({SrcA[31:8],SrcB[7:0]}) ||
              (byte_number == 3'b100)?32'hFFFF:32'h0000 & (SrcA);

assign LWR = (byte_number == 3'b001)?32'hFFFF:32'h0000 & ({SrcB[31:8],SrcA[7:0]}) ||
              (byte_number == 3'b010)?32'hFFFF:32'h0000 & ({SrcB[31:16],SrcA[15:0]}) ||
              (byte_number == 3'b011)?32'hFFFF:32'h0000 & ({SrcB[31:24],SrcA[23:0]}) ||
              (byte_number == 3'b100)?32'hFFFF:32'h0000 & (SrcA);

endmodule