module MSB(
    input logic[31:0] In,
    output logic[4:0] Out
);

logic In0;
assign In0 = In[0];
logic In1;
assign In1 = In[1];
logic In2;
assign In2 = In[2];
logic In3;
assign In3 = In[3];
logic In4;
assign In4 = In[4];
logic In5;
assign In5 = In[5];
logic In6;
assign In6 = In[6];
logic In7;
assign In7 = In[7];
logic In8;
assign In8 = In[8];
logic In9;
assign In9 = In[9];
logic In10;
assign In10 = In[10];
logic In11;
assign In11 = In[11];
logic In12;
assign In12 = In[12];
logic In13;
assign In13 = In[13];
logic In14;
assign In14 = In[14];
logic In15;
assign In15 = In[15];
logic In16;
assign In16 = In[16];
logic In17;
assign In17 = In[17];
logic In18;
assign In18 = In[18];
logic In19;
assign In19 = In[19];
logic In20;
assign In20 = In[20];
logic In21;
assign In21 = In[21];
logic In22;
assign In22 = In[22];
logic In23;
assign In23 = In[23];
logic In24;
assign In24 = In[24];
logic In25;
assign In25 = In[25];
logic In26;
assign In26 = In[26];
logic In27;
assign In27 = In[27];
logic In28;
assign In28 = In[28];
logic In29;
assign In29 = In[29];
logic In30;
assign In30 = In[30];
logic In31;
assign In31 = In[31];






always_comb begin
    
 if (In31) begin
	Out = 31;
end
else if (In30) begin
	Out = 30;
end
else if (In29) begin
	Out = 29;
end
else if (In28) begin
	Out = 28;
end
else if (In27) begin
	Out = 27;
end
else if (In26) begin
	Out = 26;
end
else if (In25) begin
	Out = 25;
end
else if (In24) begin
	Out = 24;
end
else if (In23) begin
	Out = 23;
end
else if (In22) begin
	Out = 22;
end
else if (In21) begin
	Out = 21;
end
else if (In20) begin
	Out = 20;
end
else if (In19) begin
	Out = 19;
end
else if (In18) begin
	Out = 18;
end
else if (In17) begin
	Out = 17;
end
else if (In16) begin
	Out = 16;
end
else if (In15) begin
	Out = 15;
end
else if (In14) begin
	Out = 14;
end
else if (In13) begin
	Out = 13;
end
else if (In12) begin
	Out = 12;
end
else if (In11) begin
	Out = 11;
end
else if (In10) begin
	Out = 10;
end
else if (In9) begin
	Out = 9;
end
else if (In8) begin
	Out = 8;
end
else if (In7) begin
	Out = 7;
end
else if (In6) begin
	Out = 6;
end
else if (In5) begin
	Out = 5;
end
else if (In4) begin
	Out = 4;
end
else if (In3) begin
	Out = 3;
end
else if (In2) begin
	Out = 2;
end
else if (In1) begin
	Out = 1;
end
else if (In0) begin
	Out = 0;
end



end



endmodule