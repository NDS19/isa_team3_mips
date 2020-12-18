`timescale 1ns/100ps

module regfile_tb(
);
    logic clk;
    logic reset;

    logic[4:0] write_index3, a1,a2;
    logic[31:0] write_data3, read_data1, read_data2;
    logic write_enable;

    /* Generate clock, set stimulus, and also check output. */
    initial begin
        $timeformat(-9, 1, " ns", 20);
        $dumpfile("regfile_tb.vcd");
        $dumpvars(0, regfile_tb);

        /* Clock low. */
        clk = 0;
        reset = 1;
        write_index3=0;
        write_enable=0;
        write_data3=0;

        /* Rising edge */
        #5 clk = 1;

        /* Falling edge */
        #5 clk = 0;
        /* Check outputs */
        assert(read_data1==0);
        assert(read_data2==0);
        /* Drive new inputs */
        reset = 0;
        a1=1;
        a2=0;
        write_index3 = 1;
        write_data3 = 3;
        write_enable = 1;

        /* Rising edge */
        #5 clk = 1;

        /* Falling edge */
        #5 clk = 0;
        /* Check outputs */
        assert(read_data1==3);
        assert(read_data2==0);
        /* Drive new inputs */
        a1=1;
        a2=0;
        write_index3 = 2;
        write_data3 = 10;
        write_enable = 1;

        /* Rising edge */
        #5 clk = 1;

        /* Falling edge */
        #5 clk = 0;
        /* Check outputs */
        assert(read_data1==3);
        assert(read_data2==0)
        /* Drive new inputs */
        a2=2;

        #5 clk=1;

        /* Falling edge */
        #5 clk=0;
        /* Check outputs */
        assert(read_data2==10);
        /* Drive new inputs */
        write_index3 =2;
        write_data3 =5;
        write_enable =0;

        /* Rising edge */
        #5 clk = 1;

        /* Falling edge */
        #5 clk = 0;
        /* Check outputs */
        assert(read_data2==10);
    end


    register_file regs(
        .clk(clk),
        .reset(reset),
        .read_data1(read_data1), .read_data2(read_data2), .write_data3(write_data3),
        .a1(a1), .a2(a2), .write_index3(write_index3),
        .write_enable(write_enable)
    );
endmodule
