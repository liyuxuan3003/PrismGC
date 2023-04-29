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

always@(posedge clk or negedge rstn)
begin
    if(~rstn)
    begin
        mem[0*4+`ENABLE_OUT] <= 32'b0;
        mem[1*4+`ENABLE_OUT] <= 32'b0;
        mem[2*4+`ENABLE_OUT] <= 32'b0;
        mem[3*4+`ENABLE_OUT] <= 32'b0;

        mem[0*4+`DATA_OUT] <= 32'bz;
        mem[1*4+`DATA_OUT] <= 32'bz;
        mem[2*4+`DATA_OUT] <= 32'bz;
        mem[3*4+`DATA_OUT] <= 32'bz;
    end
    else
    begin
        mem[0*4+`DATA_IN] <= ioPin[`M(0,32)];
        mem[1*4+`DATA_IN] <= ioPin[`M(1,32)];
        mem[2*4+`DATA_IN] <= ioPin[`M(2,32)];
        mem[3*4+`DATA_IN] <= ioPin[`M(3,32)];

        if(sizeDecode[0]) mem[addrIn][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn][31:24] <= dataIn[31:24];

        dataOut <= mem[addrOut];
    end
end

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