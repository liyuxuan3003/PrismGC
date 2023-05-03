module GPU 
(
    input clk,
    input rstn,
    input [7:0]                 addrIn,
    input [7:0]                 addrOut,
    input [3:0]                 sizeDecode,
    input  [31:0]               dataIn,
    output reg [31:0]           dataOut,
    output                      HDMI_CLK_P,     //HDMI CLK
    output                      HDMI_D2_P,      //HDMI D2
    output                      HDMI_D1_P,      //HDMI D1
    output                      HDMI_D0_P,       //HDMI D0
    output[60:1]        PI4            //下侧双排针
);

reg [31:0] mem [15:0];
reg enableState;
always@(posedge clk or negedge rstn) 
begin
    if(~rstn)
    begin
        mem[0] <= 0;
        mem[1] <= 0;
        mem[2] <= 0;
        mem[3] <= 0;
        mem[4] <= 0;
        mem[5] <= 0;
        mem[6] <= 0;
        mem[7] <= 0;
        mem[8] <= 0;
        enableState <= 0;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[3:0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[3:0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[3:0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[3:0]][31:24] <= dataIn[31:24];

        mem[6] <= {31'b0,SYS_VAILD};
        mem[7] <= {31'b0,BUSY};
        // if(addrOut==6)
        //     dataOut <= SYS_VAILD;
        // else if(addrOut==7)
        //     dataOut <= BUSY;
        // else   
        dataOut <= mem[addrOut[3:0]]; 

        if (mem[7][0] & mem[4][0])
            enableState <= 1;
        if(enableState & ~mem[7][0] & mem[4][0])
        begin
            enableState <= 0;
            mem[4] <= 32'b0;
        end   
    end
end

wire    [15:0] X_POS;
wire    [15:0] Y_POS;
wire    [23:0] PIXEL;
wire    [23:0] LEN;
wire           ENABLE;
wire    [8:0]  SYS_WR_LEN;
wire          SYS_VAILD;
wire          BUSY;

// wire[31:0] pingAddr;
// wire[31:0] pongAddr;

assign X_POS=mem[0][15:0];
assign Y_POS=mem[1][15:0];
assign PIXEL=mem[2][23:0];
assign LEN=mem[3][23:0];
assign ENABLE=mem[4][0];
assign SYS_WR_LEN=mem[5][8:0];

// assign pingAddr = (mem[8]) ? 32'h0 : 32'h100_000;
// assign pongAddr = (mem[8]) ? 32'h100_000 : 32'h0;
wire pingPong;
assign pingPong = mem[8][0];
SDRAM_HDMI_Display u_SDRAM_HDMI_Display
(
    .clk(clk),
    .rst_n(rstn),
    
    //HDMI
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D2_P(HDMI_D2_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D0_P(HDMI_D0_P),

    .bitPingPong(pingPong),

    // .pingAddr(pingAddr),
    // .pongAddr(pongAddr),

    .x_pos(X_POS),
    .y_pos(Y_POS),
    .pixel(PIXEL),
    .len(LEN),
    .enable(ENABLE),
    .sys_wr_len(SYS_WR_LEN),
    .sys_vaild(SYS_VAILD),
    .busy(BUSY)
);

assign PI4[5]   =   addrIn[7];
assign PI4[7]   =   addrIn[6];
assign PI4[9]   =   addrIn[5];
assign PI4[11]  =   addrIn[4];

assign PI4[13]  =   addrOut[7];
assign PI4[15]  =   addrOut[6];
assign PI4[17]  =   addrOut[5];
assign PI4[19]  =   addrOut[4];

endmodule