module MSB(
    input logic[31:0] In,
    output logic[4:0] Out
);

always_comb begin
    
    if (In[31]) begin
        Out = 31;
    end
    else if (In[30]) begin
        Out = 30;
    end
    else if (In[29]) begin
        Out = 29;
    end
    else if (In[28]) begin
        Out = 28;
    end
    else if (In[27]) begin
        Out = 27;
    end
    else if (In[26]) begin
        Out = 26;
    end
    else if (In[25]) begin
        Out = 25;
    end
    else if (In[24]) begin
        Out = 24;
    end
    else if (In[23]) begin
        Out = 23;
    end
    else if (In[22]) begin
        Out = 22;
    end
    else if (In[21]) begin
        Out = 21;
    end
    else if (In[20]) begin
        Out = 20;
    end
    else if (In[19]) begin
        Out = 19;
    end
    else if (In[18]) begin
        Out = 18;
    end
    else if (In[17]) begin
        Out = 17;
    end
    else if (In[16]) begin
        Out = 16;
    end
    else if (In[15]) begin
        Out = 15;
    end
    else if (In[14]) begin
        Out = 14;
    end
    else if (In[13]) begin
        Out = 13;
    end
    else if (In[12]) begin
        Out = 12;
    end
    else if (In[11]) begin
        Out = 11;
    end
    else if (In[10]) begin
        Out = 10;
    end
    else if (In[9]) begin
        Out = 9;
    end
    else if (In[8]) begin
        Out = 8;
    end
    else if (In[7]) begin
        Out = 7;
    end
    else if (In[6]) begin
        Out = 6;
    end
    else if (In[5]) begin
        Out = 5;
    end
    else if (In[4]) begin
        Out = 4;
    end
    else if (In[3]) begin
        Out = 3;
    end
    else if (In[2]) begin
        Out = 2;
    end
    else if (In[1]) begin
        Out = 1;
    end
    else if (In[0]) begin
        Out = 0;
    end



end



endmodule