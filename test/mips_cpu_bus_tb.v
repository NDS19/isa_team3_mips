/* TO DO:
1. Understand how the RAM file is initialised with an input file [tick]
2. Implement timings to determine how quickly test cases are completed [maybe working]
3. Fix compile-time errors
    Output wires from the mips_cpu_bus file are causing declaration errors; because
    these are output wires that the CPU either needs to use or will go to the RAM.
    These might need to be treated as outputs of the tb since otherwise they are just
    dangling wires
*/
//`timescale 1ns / 10ps

module mips_cpu_bus_tb;
    timeunit 1ns / 10ps;

    /* TO DO:
    1. Understand how the RAM file is initialised with an input file [tick]
    2. Implement timings to determine how quickly test cases are completed [maybe working]
    3. Fix compile-time errors
        Output wires from the mips_cpu_bus file are causing declaration errors; because
        these are output wires that the CPU either needs to use or will go to the RAM.
        These might need to be treated as outputs of the tb since otherwise they are just
        dangling wires
    */

    parameter RAM_INIT_FILE = "test/1-binary/lw_3.hex.txt";
    // Have an empty parameter which can be adjusted in the testbench script using the -P
    // in the compilation block
    parameter TIMEOUT_CYCLES = 30;

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
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    assign waitrequest = 0;

    // instianting everything and making the needed connections
    // might have to make all of the relevant connections including ALU, multiplexers, etc.
    RAM_8x4096 #(RAM_INIT_FILE) ramInst(
      .clk(clk),
      .a(address),
      .we(write),
      .wd(writedata),
      .byteenable(byteenable),
      .rd(readdata)
    );
    // instantiating the RAM
    mips_cpu_bus cpuInst(
      .clk(clk),
      .reset(rst),
      .active(active),
      .register_v0(register_v0),
      .address(address),
      .write(write),
      .read(read),
      .waitrequest(waitrequest),
      .writedata(writedata),
      .byteenable(byteenable),
      .readdata(readdata)
      );
    // instantiating the CPU

    //might need to instantiate a cache here if present

    // Generate clock
    initial begin //initial block that is time driven
        clk=0;

        repeat (TIMEOUT_CYCLES) begin
            #100;
            clk = !clk;
            #100;
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
        assert(active==1)
        else $display("TB : CPU did not set active=1 after reset.");

        while (active) begin
            @(posedge clk);
        end
        // checking if active is still = 1 at every positive clock edge.
        // this means that if the program stops active meaning we've reached
        // the end of the instructions, we can $finish
        $display("TB : finished; active=0");
        //displays the time taken
        $display("Time taken : %t", $time);

        // identifying the output and outputting to a stdout file
        $display("RESULT : %d", register_v0);

        // needs to verify if the we have returned to address 0 before finishing
        // should be fine placing this here at the end since we have supposedly
        // finished
        assert(address==0)
        else $display("TB : CPU did not return to address 0 at the end");

        // also needs to check if every register (including the PC has been set to 0)


        $finish; //makes the simulator exit and passes control back to the host
        // operating system

    end



endmodule
