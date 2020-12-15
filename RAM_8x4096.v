module RAM_8x4096(
    input logic clk,
    input logic[31:0] a,
    input logic we,
    input logic[31:0] wd,
    input logic[3:0] byteenable,
    output logic[31:0] rd
);
    parameter RAM_INIT_FILE = "";

    reg [7:0] memory [4194303:0];

    reg [7:0] b0, b1, b2, b3;
    

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<4194304; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end
        
        a = a - 32'hBFC00000;
        
        b0 = a==32'h0 ? 8'b0 : memory[a];
        b1 = a==32'h0 ? 8'b0 : memory[a+1];
        b2 = a==32'h0 ? 8'b0 : memory[a+2];
        b3 = a==32'h0 ? 8'b0 : memory[a+3];

    end

    /* Synchronous write path */
    always @(posedge clk) begin
        //$display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
        case(byteenable)
            4'b0000:
            if (write) begin
            {32'b0} <= wd;
            end
            rd <= {32'b0}; // Read-after-write mode
            4'b0001:
            if (write) begin
            {24'b0,b0} <= wd;
            end
            rd <= {24'b0,b0}; // Read-after-write mode
            4'b0010:
            if (write) begin
            {16'b0,b1,8'b0} <= wd;
            end
            rd <= {16'b0,b1,8'b0}; // Read-after-write mode
            4'b0011:
            if (write) begin
            {16'b0,b1,b0} <= wd;
            end
            rd <= {16'b0,b1,b0}; // Read-after-write mode
            4'b0100:
            if (write) begin
            {8'b0,b2,16'b0} <= wd;
            end
            rd <= {8'b0,b2,16'b0}; // Read-after-write mode
            4'b0101:
            if (write) begin
            {8'b0,b2,8'b0,b0} <= wd;
            end
            rd <= {8'b0,b2,8'b0,b0}; // Read-after-write mode
            4'b0110:
            if (write) begin
            {8'b0,b2,b1,8'b0} <= wd;
            end
            rd <= {8'b0,b2,b1,8'b0}; // Read-after-write mode
            4'b0111:
            if (write) begin
            {8'b0,b2,b1,b0} <= wd;
            end
            rd <= {8'b0,b2,b1,b0}; // Read-after-write mode
            4'b1000:
            if (write) begin
            {b3,24'b0} <= wd;
            end
            rd <= {b3,24'b0}; // Read-after-write mode
            4'b1001:
            if (write) begin
            {b3,16'b0,b0} <= wd;
            end
            rd <= {b3,16'b0,b0}; // Read-after-write mode
            4'b1010:
            if (write) begin
            {b3,8'b0,b1,8'b0} <= wd;
            end
            rd <= {b3,8'b0,b1,8'b0}; // Read-after-write mode
            4'b1011:
            if (write) begin
            {b3,8'b0,b1,b0} <= wd;
            end
            rd <= {b3,8'b0,b1,b0}; // Read-after-write mode
            4'b1100:
            if (write) begin
            {b3,b2,16'b0} <= wd;
            end
            rd <= {b3,b2,16'b0}; // Read-after-write mode
            4'b1101:
            if (write) begin
            {b3,b2,8'b0,b0} <= wd;
            end
            rd <= {b3,b2,8'b0,b0}; // Read-after-write mode
            4'b1110:
            if (write) begin
            {b3,b2,b1,8'b0} <= wd;
            end
            rd <= {b3,b2,b1,8'b0}; // Read-after-write mode
            4'b1111:
            if (write) begin
            {b3,b2,b1,b0} <= wd;
            end
            rd <= {b3,b2,b1,b0}; // Read-after-write mode
        
    end
endmodule

