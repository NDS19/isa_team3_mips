module mips_cpu_bus_tb;
    timeunit 1ns / 10ps;

    parameter RAM_INIT_FILE = "test/01-binary/countdown.hex.txt";
    parameter TIMEOUT_CYCLES = 10000;

    // inputs
    logic clk;
    logic rst;

    // outputs
    logic active; // detects when the cpu has finished executing instructions, 0 when finished
    logic[31:0] register_v0; // output of register 2, used for testing

    // wires to connect to the RAM
    logic[31:0] address;
    logic write;
    logic read;
    input logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    /*RAM module name*/ #(RAM_INIT_FILE) ramInst(clk, address, write, read, writedata, readdata);
    // instantiating the RAM
    [/*CPU module name*/] cpuInst(clk, rst, active, register_v0, address, write, read, waitrequest, writedata, byteenable, readdata);
    // instantiating the CPU

    //might need to instantiate a cache here if present

    // Generate clock
    initial begin //initial block that is time driven
        clk=0;

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end
        // clock is created here in the test bench
        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin //initial block that is event driven and runs in parallel
    //to the time driven block
        rst <= 0;

        @(posedge clk);
        rst <= 1;

        @(posedge clk);
        rst <= 0;

        @(posedge clk);
        assert(running==1)
        else $display("TB : CPU did not set running=1 after reset.");

        while (running) begin
            @(posedge clk);
        end
        // checking if running is still = 1 at every positive clock edge.
        // this means that if the program stops running meaning we've reached
        // the end of the instructions, we can $finish
        $display("TB : finished; running=0");

        $finish;

    end



endmodule
