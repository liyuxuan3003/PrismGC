/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module Timer 
(
    input               clk,
    input               rstn,
    input[7:0]          addrIn,
    input[7:0]          addrOut,
    input[3:0]          sizeDecode,
    input[31:0]         dataIn,
    output reg[31:0]    dataOut
);

reg [31:0] mem [0:0];

reg [15:0] msCounter;   //50000 clk = 1 ms

always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[0] <= 0;
        msCounter <=0;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[0]][31:24] <= dataIn[31:24];

        dataOut <= mem[addrOut[0]]; 

        msCounter <= msCounter + 1;
        if(msCounter == 50000)
        begin
            msCounter <= 0;
            mem[0] <= mem[0] + 1;
        end
    end
end

endmodule