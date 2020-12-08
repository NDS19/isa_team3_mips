module Div(
    input logic clk,
    input logic validIn,
    input logic sign,
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


logic[31:0] Inverted_A;
logic[31:0] Inverted_B;
Sign_Inverter invert_A(.In(SrcA),.Out(Inverted_A));
Sign_Inverter inver_B(.In(SrcB),.Out(Inverted_B));

logic[31:0] Inverted_Quotient_next;
Sign_Inverter invert_sum(.In(Quotient_next),.Out(Inverted_Quotient_next));
logic[31:0] Inverted_Remainder_next;
Sign_Inverter invert_sum(.In(Remainder_next),.Out(Inverted_Remainder_next));

//this should maybe be done in more cycles instead of combinatorially
logic[4:0] msbA;
logic[4:0] msbB;

logic running, running_next;

logic[31:0] InputMSB_A; //Inout to MSB, set to either SrcA or Inverted_A dependent on wether A is positive or negative
logic[31:0] InputMSB_B;
MSB MSBA(InputMSB_A,msbA);
MSB MSBB(InputMSB_B,msbB);

// intial begin
//     running = 0;
//     running_next = 0;
// end

always_comb begin
    if (validIn == 0) begin
        running_next = 0;
    end
    else if (running == 0) begin
        running_next = 1;
        count_next = 0;
        if (sign == 1) begin
            if (SrcA[31] == 1 && SrcB[31] == 1) begin   //If both inputs are negative
                Remainder_next = Inverted_A;
                InputMSB_A = Inverted_A;
                InputMSB_B = Inverted_B;
                Divisor_next = Inverted_B << (msbA - msbB);
            end
            else if (SrcA[31] == 1) begin   //If only A is negative
                Remainder_next = Inverted_A; 
                InputMSB_A = Inverted_A;      
                InputMSB_B = SrcB;    
                Divisor_next = SrcB << (msbA - msbB);
            end
            else if (SrcB[31] == 1) begin   //If only B is negative
                Remainder_next = SrcA; 
                InputMSB_A = SrcA;    
                InputMSB_B = Inverted_B;    
                Divisor_next = Inverted_B << (msbA - msbB);
            end
            else begin  //If both inputs are positive
                Remainder_next = SrcA; 
                InputMSB_A = SrcA;      
                InputMSB_B = SrcB;    
                Divisor_next = SrcB << (msbA - msbB);
            end
        end
        else begin
            Remainder_next = SrcA; 
            InputMSB_A = SrcA;      
            InputMSB_B = SrcB;    
            Divisor_next = SrcB << (msbA - msbB);
        end
        Quotient_next = 0;
    end
    /*if (validIn == 1) begin
        count_next = 0;
        Remainder_next = SrcA;
        Quotient_next = 0;
        Divisor_next = SrcB << (msbA - msbB);
        running_next = 0;
    end*/
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
    //else begin
    //    running_next = 1;
    //end
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
        if (sign == 1) begin
            if (SrcA[31] == 0 && SrcB[31] == 0) begin   //If both inputs are positive
                Hi <= Quotient_next;
                Lo <= Remainder_next;
            end
            else if (SrcA[31] == 0) begin   //If A is positive and B is negative
                Hi <= Inverted_Quotient_next;
                Lo <= Remainder_next;
            end
            else if (SrcB[31] == 0) begin   //If only B is positive and A is negative
                Hi <= Inverted_Quotient_next;
                Lo <= Inverted_Remainder_next;
            end
            else begin  //If both inputs are negative
                Hi <= Quotient_next;
                Lo <= Inverted_Remainder_next;
            end
        end 
        else begin
            Hi <= Quotient_next;
            Lo <= Remainder_next;
        end
        validOut <= 1;
        //running <= 0;
    end
    else begin
        validOut <= 0;
    end
end

endmodule