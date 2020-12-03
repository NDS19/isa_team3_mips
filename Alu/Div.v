module Div(
    input logic clk,
    input logic validIn,
    output logic validOut,

    input logic[31:0] SrcA,
    input logic[31:0] SrcB,
    output logic[31:0] Hi,
    output logic[31:0] Lo
);

logic[31:0] Divisor, Divisor_next;
logic[31:0] Quotient, Quotient_next;
logic[31:0] Remainder, Remainder_next;
logic[5:0] count, count_next;


//this should maybe be done in more cycles instead of combinatorially
logic[4:0] msbA;
logic[4:0] msbB;

logic running, running_next;

MSB MSBA(SrcA,msbA);
MSB MSBB(SrcB,msbB);

// intial begin
//     running = 0;
//     running_next = 0;
// end

always_comb begin
    if (validIn == 1) begin
        count_next = 0;
        Remainder_next = SrcA;
        Quotient_next = 0;
        Divisor_next = SrcB << (msbA - msbB);
        running_next = 0;
    end
    else if (running) begin
        if(count != 33) begin
            Divisor_next = Divisor;
            if (Remainder >= Divisor) begin
                Remainder_next = (Remainder - Divisor);
                Quotient_next = (Quotient << 1) + 1;
            end
            else begin
                Quotient_next = Quotient << 1;
            end
            count_next = count + 1;
            running_next = 1;

            if (Divisor > SrcB) begin
                Divisor_next = Divisor >> 1;
            end
            else begin
                Divisor_next = Divisor;
                count_next = 33;
            end
        end

    end
    else begin
        running_next = 1;
    end
end

always  @(posedge clk) begin
    //$display("HI=%d, _LO=%d", Quotient_next, Remainder_next);
    Divisor <= Divisor_next;
    Remainder <= Remainder_next;
    Quotient <= Quotient_next;
    count <= count_next;
    running <= running_next;

    if (count_next==33) begin
        //$display("Hello");
        Hi <= Quotient_next;
        Lo <= Remainder_next;
        validOut <= 1;
        running <= 0;
    end
    else begin
        validOut <= 0;
    end
end

endmodule