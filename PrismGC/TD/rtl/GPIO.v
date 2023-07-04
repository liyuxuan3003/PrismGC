/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

`include "GlobalDefine.v"

module GPIO #(parameter PORT_NUM = 0)
(
    input                   clk,
    input                   rstn,
    input[7:0]              addrIn,
    input[7:0]              addrOut,
    input[3:0]              sizeDecode,
    input[31:0]             dataIn,
    output reg[31:0]        dataOut,
    inout[PORT_NUM*32-1:0]  ioPin
);

`define IDAT  0
`define OENA  1
`define ODAT  2

reg [31:0] mem [(PORT_NUM*4-1):0];

// 实现对mem的写入
integer nInt;
always@(posedge clk or negedge rstn)
begin
    if(~rstn)   
    begin
        //初始化部分
        for(nInt=0; nInt<PORT_NUM; nInt=nInt+1)
        begin
            mem[nInt*4+`OENA] <= 32'b0;   //默认为输入状态
            mem[nInt*4+`ODAT] <= 32'bz;     //默认输出值为高阻态
        end
    end
    else
    begin
        //输入数据 从ioPin读取
        for(nInt=0; nInt<PORT_NUM; nInt=nInt+1)
        begin
            mem[nInt*4+`IDAT] <= ioPin[32*nInt+:32];
        end

        //输出数据和输出使能 从总线读取
        if(sizeDecode[0]) mem[addrIn[(PORT_NUM-1):0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[(PORT_NUM-1):0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[(PORT_NUM-1):0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[(PORT_NUM-1):0]][31:24] <= dataIn[31:24];

        //总线从mem读回
        dataOut <= mem[addrOut[(PORT_NUM-1):0]];
    end
end

// 实现对ioPin的写入
genvar nGen;
genvar p;
generate
    //遍历每一个PORT
    for(nGen=0; nGen<PORT_NUM; nGen=nGen+1) 
    begin: mem_crtl
        //遍历每一个PORT上的每一个引脚
        for(p=0; p<32; p=p+1)
        begin: out
            //若输出使能为高 则输出值为输出数据
            //若输出使能为低 则输出值为高阻态
            assign ioPin[nGen*32+p] = mem[nGen*4+`OENA][p] ? mem[nGen*4+`ODAT][p] : 1'bz;
        end
    end
endgenerate

endmodule