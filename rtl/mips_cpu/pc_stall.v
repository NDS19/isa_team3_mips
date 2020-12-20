module pc_stall  (
               input logic  clk, pc_stall_en,
                input logic[31:0] d,
                output logic[31:0] q);

    //assign PcIs0 = q == 32'b0;
    
    //always @ (posedge clk, posedge reset)
    always @(posedge clk) begin
        // $display("PC = %d",q);
        q <= pc_stall_en ? d : q;
        end  
    
endmodule