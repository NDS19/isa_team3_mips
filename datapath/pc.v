module pc # (parameter WIDTH = 8)
               (input                    clk, reset, PcEn,
                input      [WIDTH - 1:0] d,
                output reg [WIDTH - 1:0] q);

    always @ (posedge clk, posedge reset)
        
        if (reset) q <= 0xBFC00000;
        else       q <= PcEn ? d : q;
endmodule