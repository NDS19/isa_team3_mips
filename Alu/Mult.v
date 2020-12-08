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
    Sign_Inverter invert_sum(.In(sum_next[63:0]),.Out(Inverted_sum_next));

    parameter split = 4;
    parameter nibble_width = 32/split - 1;

    logic[nibble_width:0] mp_nibble;

    assign mp_nibble = mp[nibble_width:0];

    logic running, running_next;

    logic negative;

    always_comb begin
        if (SrcA[31] == SrcB[31]) begin
            negative = 0;
        end 
        else begin
            negative = 1;
        end


        if (validIn == 0) begin
            //mp_next = SrcA;
            //mc_next = SrcB;
            sum_next = 0;
            count_next = 0;
            running_next = 0;
        end
        else if (running == 0) begin
            if (SrcA[31] == 1 && sign == 1) begin
                mp_next = Inverted_A;
            end
            else begin
                mp_next = SrcA;
            end
            if (SrcB[31] == 1 && sign == 1) begin
                mp_next = Inverted_B;
            end
            else begin
                mp_next = SrcB;
            end
            running_next = 1;
        end
        else if (count != split) begin
            sum_next = sum + mp_nibble * mc;
            mp_next = mp>>nibble_width;
            mc_next = mc<<nibble_width;
            if (mp==0) begin
                count_next=split;
            end
            else begin
                count_next = count + 1;
            end
        end
    end

    always_ff  @(posedge clk) begin
        mp <= mp_next;
        mc <= mc_next;
        sum <= sum_next;
        count <= count_next;
        running <= running_next;

        if (count_next==split) begin
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