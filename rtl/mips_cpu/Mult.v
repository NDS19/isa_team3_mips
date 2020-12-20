module Mult(
    input logic clk,
    input logic validIn,
    input logic sign,
    output logic validOut,

    input logic[31:0] SrcA,
    input logic[31:0] SrcB,
    output logic[31:0] Hi,
    output logic[31:0] Lo
);
    //Sign inverted SrcA and SrcB
    logic[31:0] Inverted_A;
    logic[31:0] Inverted_B;
    Sign_Inverter invert_A(.In(SrcA),.Out(Inverted_A));
    Sign_Inverter inver_B(.In(SrcB),.Out(Inverted_B));

    logic[31:0] mp, mp_next;
    logic[63:0] mc, mc_next;
    logic[63:0] sum, sum_next;
    logic[5:0] count, count_next;

    logic[63:0] Inverted_sum_next;
    Sign_Inverter64 invert_sum(.In(sum_next[63:0]),.Out(Inverted_sum_next));

    parameter split = 4;
    parameter nibble_width = 32/split - 1;

    logic[nibble_width:0] mp_nibble;

    assign mp_nibble = mp[nibble_width:0];

    logic running, running_next;

    logic negative;

    logic is_neg_A;
    assign is_neg_A = SrcA[31];
    logic is_neg_B;
    assign is_neg_B = SrcB[31];

    always_comb begin
        if (is_neg_A == is_neg_B) begin
            negative = 0;
        end 
        else begin
            negative = 1;
        end


        if (validIn == 0) begin
            //mp_next = SrcA;
            //mc_next = SrcB;
            sum_next = running == 0?0:sum;
            count_next = 0;
            running_next = 0;
        end
        else if (running == 0) begin
            if (is_neg_A == 1 && sign == 1) begin
                mp_next = Inverted_A;
            end
            else begin
                mp_next = SrcA;
            end
            if (is_neg_B == 1 && sign == 1) begin
                mc_next = Inverted_B;
            end
            else begin
                mc_next = SrcB;
            end
            running_next = 1;
        end
        else if (count != (split+1)) begin
            sum_next = sum + mp_nibble * mc;
            mp_next = mp>>(nibble_width+1);
            mc_next = mc<<(nibble_width+1);
            if (mp==0) begin
                count_next=split+1;
            end
            else begin
                count_next = count + 1;
            end
        end
        else begin
            count_next = 0;
        end
    end

    always  @(posedge clk) begin
        //$display("sum_next = %b  mp_next = %b mp = %b running = %b",sum_next, mp_next, mp, running);
        //$display("Hi = %b  split = %b validOut = %b mc = %b",Hi, split, validOut, mc);
        mp <= mp_next;
        mc <= mc_next;
        sum <= sum_next;
        count <= count_next;
        running <= running_next;
        
        if (count_next==(split+1)) begin
            if (negative == 1  && sign == 1) begin
                Hi <= Inverted_sum_next[63:32];
                Lo <= Inverted_sum_next[31:0];
            end
            else begin
                Hi <= sum_next[63:32];
                Lo <= sum_next[31:0];
            end
            validOut <= 1;
        end
        else begin
            validOut <= 0;
        end
    end


endmodule