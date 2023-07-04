/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module GPU 
(
    input               clk,
    input               rstn,
    input[7:0]          addrIn,
    input[7:0]          addrOut,
    input[3:0]          sizeDecode,
    input[31:0]         dataIn,
    output reg[31:0]    dataOut,
    output              HDMI_CLK_P,
    output              HDMI_D2_P,
    output              HDMI_D1_P,
    output              HDMI_D0_P
);

`define X_POS       0
`define Y_POS       1
`define PIXEL       2
`define LEN         3
`define ENABLE      4
`define SYS_WR_LEN  5
`define SYS_VAILD   6
`define BUSY        7
`define PING_PONG   8

reg [31:0] mem [15:0];
reg enableState;
always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[`X_POS] <= 0;
        mem[`Y_POS] <= 0;
        mem[`PIXEL] <= 0;
        mem[`LEN] <= 0;
        mem[`ENABLE] <= 0;
        mem[`SYS_WR_LEN] <= 0;
        mem[`SYS_VAILD] <= 0;
        mem[`BUSY] <= 0;
        mem[`PING_PONG] <= 0;
        enableState <= 0;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[3:0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[3:0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[3:0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[3:0]][31:24] <= dataIn[31:24];

        mem[`SYS_VAILD] <= {31'b0,sysVaild};
        mem[`BUSY] <= {31'b0,busy};

        dataOut <= mem[addrOut[3:0]]; 

        if (mem[`BUSY][0] & mem[`ENABLE][0])
            enableState <= 1;
        if(enableState & ~mem[`BUSY][0] & mem[`ENABLE][0])
            enableState <= 0;
    end
end

wire sysVaild;
wire busy;

SDRAM_HDMI_Display u_SDRAM_HDMI_Display
(
    .clk(clk),
    .rst_n(rstn),
    
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D2_P(HDMI_D2_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D0_P(HDMI_D0_P),

    .bitPingPong(mem[`PING_PONG][0]),

    .x_pos(mem[`X_POS][15:0]),
    .y_pos(mem[`Y_POS][15:0]),
    .pixel(mem[`PIXEL][23:0]),
    .len(mem[`LEN][23:0]),
    .enable(mem[`ENABLE][0]),
    .sys_wr_len(mem[`SYS_WR_LEN][8:0]),
    .sys_vaild(sysVaild),
    .busy(busy)
);

endmodule