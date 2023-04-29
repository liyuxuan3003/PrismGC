`timescale 10ns/1ns
module Mux16_1_TB();
    reg[3:0] sel;
    reg[15:0] sigIn;
    wire sigOut;

    Mux16_1 uMux16_1 (.sel(sel),.sigIn(sigIn),.sigOut(sigOut));

    initial
    begin 
        sel=0;
        sigIn=16'h5555;
    end

    integer i;
    initial 
    begin
        for(i=0;i<16;i=i+1)
        begin
            #5 sel=sel+1;
        end
    end
endmodule