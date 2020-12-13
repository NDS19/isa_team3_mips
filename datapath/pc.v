module pc # (parameter WIDTH = 8)
               (input                    clk, reset, PcEn,
                input      [WIDTH - 1:0] d,
                output reg [WIDTH - 1:0] q,
                input logic is_jump);

    logic jump;

    assign PcIs0 = q == 0;
    
    always @ (posedge clk, posedge reset)
        jump <= is_jump;
        if (reset) q <= 0xBFC00000;
        else       q <= jump ? {q[31:27],d[26:0]} : PcEn ? d : q;
endmodule