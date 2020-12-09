module RAM_8x4096(
    input logic clk,
    input logic[31:0] a,
    input logic we,
    input logic[31:0] wd,
    output logic[31:0] rd
);
    parameter RAM_INIT_FILE = "";

    reg [7:0] memory [4095:0];

    reg [7:0] b0, b1, b2, b3;
    

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<4096; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end

        assign b0 = memory[a+3];
        assign b1 = memory[a+2];
        assign b2 = memory[a+1];
        assign b3 = memory[a];

    end

    /* Synchronous write path */
    always @(posedge clk) begin
        //$display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
        if (write) begin
            {b0,b1,b2,b3} <= wd;
        end
        rd <= {b0,b1,b2,b3}; // Read-after-write mode
    end
endmodule
