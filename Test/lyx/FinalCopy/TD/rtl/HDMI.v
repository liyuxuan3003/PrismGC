module HDMI 
(
    input clk,
    input rstn,
    input [7:0]                 addrIn,
    input [7:0]                 addrOut,
    input [3:0]                 sizeDecode,
    input  [31:0]               dataIn,
    output reg [31:0]           dataOut,
    input                       clkPixel,
    input                       clkTMDS,
    output                      HDMI_CLK_P,     //HDMI CLK
    output                      HDMI_D2_P,      //HDMI D2
    output                      HDMI_D1_P,      //HDMI D1
    output                      HDMI_D0_P       //HDMI D0
);

reg [31:0] mem [2:0];

always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[0]=0;
        mem[1]=0;
        mem[2]=0;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn][31:24] <= dataIn[31:24];

        mem[1] <= CounterX;
        mem[2] <= CounterY;

        dataOut <= mem[addrOut]; 
    end
end

wire[15:0] CounterX;
wire[15:0] CounterY;

HDMIEncoder uHDMIEncoder
(
    .clk(clkPixel),
    .clk_TMDS(clkTMDS),
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D0_P(HDMI_D0_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D2_P(HDMI_D2_P),
    .CounterX(CounterX),
    .CounterY(CounterY),
    .RGB(mem[0])
);

endmodule