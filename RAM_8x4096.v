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
    
    logic[31:0] A;

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
        

    end

    assign A = a==32'h0 ? a: a - 32'hBFC00000;
    assign b0 = A==32'h0 ? 8'b0 : memory[A];
    assign b1 = A==32'h0 ? 8'b0 : memory[A+1];
    assign b2 = A==32'h0 ? 8'b0 : memory[A+2];
    assign b3 = A==32'h0 ? 8'b0 : memory[A+3];
    /* Synchronous write path */
    always @(posedge clk) begin
        //$display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
        /*
        case(byteenable)
            4'b0000:    begin
                if (wd) begin
                {32'b0} <= wd;
                end
                rd <= {32'b0}; // Read-after-write mode
            end
            4'b0001: begin
            if (we) begin
            {24'b0,b0} <= wd;
            end
            rd <= {24'b0,b0}; // Read-after-write mode
            end
            4'b0010: begin
            if (we) begin
            {16'b0,b1,8'b0} <= wd;
            end
            rd <= {16'b0,b1,8'b0}; // Read-after-write mode
            end
            4'b0011: begin
            if (we) begin
            {16'b0,b1,b0} <= wd;
            end
            rd <= {16'b0,b1,b0}; // Read-after-write mode
            end
            4'b0100: begin
            if (we) begin
            {8'b0,b2,16'b0} <= wd;
            end
            rd <= {8'b0,b2,16'b0}; // Read-after-write mode
            end
            4'b0101: begin
            if (we) begin
            {8'b0,b2,8'b0,b0} <= wd;
            end
            rd <= {8'b0,b2,8'b0,b0}; // Read-after-write mode
            end
            4'b0110: begin
            if (we) begin
            {8'b0,b2,b1,8'b0} <= wd;
            end
            rd <= {8'b0,b2,b1,8'b0}; // Read-after-write mode
            end
            4'b0111: begin
            if (we) begin
            {8'b0,b2,b1,b0} <= wd;
            end
            rd <= {8'b0,b2,b1,b0}; // Read-after-write mode
            end
            4'b1000: begin
            if (we) begin
            {b3,24'b0} <= wd;
            end
            rd <= {b3,24'b0}; // Read-after-write mode
            end
            4'b1001:begin 
            if (we) begin
            {b3,16'b0,b0} <= wd;
            end
            rd <= {b3,16'b0,b0}; // Read-after-write mode
            end
            4'b1010: begin
            if (we) begin
            {b3,8'b0,b1,8'b0} <= wd;
            end
            rd <= {b3,8'b0,b1,8'b0}; // Read-after-write mode
            end
            4'b1011: begin
            if (wd) begin
            {b3,8'b0,b1,b0} <= wd;
            end
            rd <= {b3,8'b0,b1,b0}; // Read-after-write mode
            end
            4'b1100: begin
            if (wd) begin
            {b3,b2,16'b0} <= wd;
            end
            rd <= {b3,b2,16'b0}; // Read-after-write mode
            end
            4'b1101: begin
            if (wd) begin
            {b3,b2,8'b0,b0} <= wd;
            end
            rd <= {b3,b2,8'b0,b0}; // Read-after-write mode
            end
            4'b1110: begin
            if (wd) begin
            {b3,b2,b1,8'b0} <= wd;
            end
            rd <= {b3,b2,b1,8'b0}; // Read-after-write mode
            end
            4'b1111: begin
            if (wd) begin
            {b3,b2,b1,b0} <= wd;
            end
            rd <= {b3,b2,b1,b0}; // Read-after-write mode
            end
        endcase
        */
        //$display("OUT %b A%b", {b3,b2,b1,b0}, A);
        rd <= {b3,b2,b1,b0};
    end
endmodule

