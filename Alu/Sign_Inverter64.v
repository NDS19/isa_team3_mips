module Sign_Inverter (
    input logic[63:0] In,
    output logic[63:0] Out
);

always_comb begin
    Out = (~In) + 1;
end


endmodule