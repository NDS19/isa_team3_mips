module pc # (parameter WIDTH = 8)
               (input  logic              clk, reset, PcEn,
                input  logic[WIDTH - 1:0] d,
                output logic[WIDTH - 1:0] q,
                output logic              PcIs0);

    assign PcIs0 = q == 0;
    
    always @ (posedge clk, posedge reset)
        
        if (reset) begin
            q <= 0xBFC00000;
        end
        else begin
            q <= PcEn ? d : q;
        end
endmodule