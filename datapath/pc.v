module pc  (
               input logic  clk, reset, PcEn,
                input logic[31:0] d,
                output logic[31:0] q,
                input logic is_jump);

    logic jump;

    //assign PcIs0 = q == 32'b0;
    
    //always @ (posedge clk, posedge reset)
    always @(posedge clk) begin
        // $display("PC = %d",q);
        jump <= is_jump;
        if (reset == 1) begin
            q <= 32'hBFC00000;
        end
        else begin
            q <= jump ? {q[31:27],d[26:0]} : PcEn ? d : q;
        end  
    end
endmodule