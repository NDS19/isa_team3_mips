module pc  (
               input logic  clk, reset, PcEn,
                input logic[31:0] d,
                output logic[31:0] q,
                input logic is_jump);

    logic jump;

    //assign PcIs0 = q == 32'b0;
    
    //always @ (posedge clk, posedge reset)
    logic[31:0] JConst;
    assign JConst = {q[31:28],d[27:0]};
    always @(posedge clk) begin
        // $display("PC = %d",q);
        jump <= is_jump;
        if (reset == 1) begin
            q <= 32'hBFC00000;
        end
        else begin
            q <= jump ? JConst : PcEn ? d : q;
        end  
    end
endmodule