`include "GlobalDefine.v"

module GPIO #(parameter PORT_NUM = 0)
(
    input clk,
    input rstn,
    input [PORT_NUM*4-1:0]      addrIn,
    input [PORT_NUM*4-1:0]      addrOut,
    input [3:0]                 sizeDecode,
    input  [31:0]               dataIn,
    output reg [31:0]           dataOut,
    inout [PORT_NUM*32-1:0]     ioPin
);

`define DATA_IN     0
`define ENABLE_OUT  1
`define DATA_OUT    2

reg [31:0] mem [(PORT_NUM*4-1):0];

integer n;

generate
    always@(posedge clk or negedge rstn)
    begin
        if(~rstn)
        begin
            for(n=0;n<PORT_NUM;n=n+1)
            begin
                mem[n*4+`ENABLE_OUT] <= 32'b0;
                mem[n*4+`DATA_OUT] <= 32'bz;
            end
        end
        else
        begin
            for(n=0;n<PORT_NUM;n=n+1)
            begin
                mem[n*4+`DATA_IN] <= ioPin[32*n+:32];
            end

            if(sizeDecode[0]) mem[addrIn][7:0]   <= dataIn[7:0];
            if(sizeDecode[1]) mem[addrIn][15:8]  <= dataIn[15:8];
            if(sizeDecode[2]) mem[addrIn][23:16] <= dataIn[23:16];
            if(sizeDecode[3]) mem[addrIn][31:24] <= dataIn[31:24];

            dataOut <= mem[addrOut];
        end
    end
endgenerate

genvar i;
genvar j;

generate
    for(i=0; i<PORT_NUM; i=i+1) 
    begin: mem_crtl
        for(j=0; j<32; j=j+1)
        begin: out
            assign ioPin[i*32+j] = mem[i*4+`ENABLE_OUT][j] ? mem[i*4+`DATA_OUT][j] : 1'bz;
        end
    end
endgenerate


/*
genvar i;
genvar j;
generate
    for(i=0; i<PORT_NUM; i=i+1) 
    begin: mem_crtl
        always@(posedge clk or negedge rstn) 
        begin
            if(~rstn)
            begin
                mem[i*4+`ENABLE_OUT] <= 32'b0;
                mem[i*4+`DATA_OUT]   <= 32'bz;
            end
            else
            begin
                //if(addrOut >> 2 == i)
                //    dataOut <= ioPin[`M(i,32)];
            end
        end
        for(j=0; j<32; j=j+1)
        begin: out
            assign ioPin[i*32+j] = mem[i*4+`ENABLE_OUT][j] ? mem[i*4+`DATA_OUT] : 1'bz;
        end
    end
endgenerate
*/
endmodule