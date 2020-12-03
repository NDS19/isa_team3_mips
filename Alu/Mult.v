module Mult(
    input logic clk,
    input logic validIn,
    output logic validOut,

    input logic[31:0] SrcA,
    input logic[31:0] SrcB,
    output logic[31:0] Hi,
    output logic[31:0] Lo

);

    logic[31:0] mp, mp_next;
    logic[63:0] mc, mc_next;
    logic[63:0] sum, sum_next;
    logic[5:0] count, count_next;

    parameter split = 4;
    parameter nibble_width = 32/split - 1;

    logic[nibble_width:0] mp_nibble;

    assign mp_nibble = mp[nibble_width:0];

    always_comb begin
        if (validIn == 1) begin
            mp_next = SrcA;
            mc_next = SrcB;
            sum_next = 0;
            count_next = 0;
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
        if (count_next==split) begin
            Hi <= sum_next[63:32];
            Lo <= sum_next[31:0];
            validOut <= 1;
        end
        else begin
            validOut <= 0;
        end
    end


endmodule