module pc # (parameter WIDTH = 8)
               (input                    clk, IrWrite,
                input      [WIDTH - 1:0] d,
                output reg [WIDTH - 1:0] q);

    always @ (posedge clk)
        q <= IrWrite ? d : q;
endmodule