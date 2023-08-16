/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

`include "GlobalDefine.v"

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
`define SYS_WR_LEN  5       //--
`define SYS_VAILD   6
`define BUSY        7
`define PING_PONG   8
`define HDMI_BUSY   9

reg [31:0] mem [`VRAM_BUFF+16-1:0];

wire sysVaild;

reg[2:0]    wrState;
reg[2:0]    wrDiv;
reg[23:0]   wrCount;

reg[15:0]   wrTimeout;

reg         busy;
reg         sysLoad;
reg[31:0]   sysAddrMin;
reg[31:0]   sysAddrMax;
reg[7:0]    sysWriteRefresh;
wire        sysWriteEnable;

reg[23:0]   sysWriteLen;

wire        sysDone;

wire sysFull;
wire sysEmpty;

reg [31:0] sysDataIn;
  
// wire[31:0]  sysDataIn = 
//     (sysReq && wrCount < mem[`LEN][23:0]) ? 
//         (mem[`ENABLE][1]==1 ? {mem[16+wrCount][23:0],8'b0} : {mem[`PIXEL][23:0], 8'b0}) : 
//         sysDataIn;

// wire[31:0]  sysDataIn = 
//     (sysReq && wrCount <= mem[`LEN][23:0]) ? 
//         (mem[`ENABLE][1]==1 ? {24'hFF0000,8'b0} : {mem[`PIXEL][23:0], 8'b0}) : 
//         sysDataIn;

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
        mem[`HDMI_BUSY] <= 0;
    end
    else
    begin
        if(sizeDecode[0]) mem[addrIn[4:0]][7:0]   <= dataIn[7:0];
        if(sizeDecode[1]) mem[addrIn[4:0]][15:8]  <= dataIn[15:8];
        if(sizeDecode[2]) mem[addrIn[4:0]][23:16] <= dataIn[23:16];
        if(sizeDecode[3]) mem[addrIn[4:0]][31:24] <= dataIn[31:24];

        mem[`SYS_VAILD] <= {31'b0,sysVaild};
        mem[`BUSY] <= {31'b0,busy};
        mem[`HDMI_BUSY] <= {31'b0,pixelRequest};

        dataOut <= mem[addrOut[4:0]]; 
    end
end

always@(posedge clkRef or negedge sysRstn) 
begin
    if(~sysRstn)
    begin
        wrState <= 0;
		wrCount <= 0;
		wrDiv <= 0;
        sysWriteRefresh <= 0;
        busy<=0;
    end
    else
    begin
        case (wrState)
            0: begin
                busy <= 0;
                sysWriteRefresh <= 0;
                wrState <= mem[`ENABLE][0] ? 1:0;
            end
            1: begin
                busy <= 1;
                sysAddrMin <= mem[`X_POS][15:0] + mem[`Y_POS][15:0] * `H_DISP;
                sysAddrMax <= `H_DISP * (`V_DISP  + 1);
                sysLoad <= 1'b1;
                wrState <= 2;
                wrDiv <= 0;
            end
            2: begin
                busy <= 1;
                sysLoad <= 1'b0;
                wrCount <= 0;
                wrTimeout <= 0;
                wrDiv <= 0;
                wrState <= 3;
                sysWriteLen <= mem[`LEN][23:0];
            end
            3: begin
                busy <= 1;
                if(sysReq)
                begin
                    sysWriteLen <= 0;
                    wrCount <= wrCount + 1;
                    if(mem[`ENABLE][1]==0)
                    begin
                        sysDataIn <= {mem[`PIXEL][23:0],8'b0};
                    end
                    else
                    begin
                        sysDataIn <= {mem[16+wrCount][23:0],8'b0};
                    end
                end
                wrTimeout <= wrTimeout + 1;
                if(sysDone)
                    wrState <= 4;
            end
            4: begin
                busy <= 0;
                wrState <= mem[`ENABLE][0] ? 4:0;
                sysWriteRefresh <= 0;
            end
            default: wrState <= 0;
        endcase
    end
end

// always@(posedge clkRef or negedge sysRstn) 
// begin
//     if(~sysRstn)
//     begin
//         wrState <= 0;
// 		wrCount <= 0;
// 		wrDiv <= 0;
//         sysWriteRefresh <= 0;
//         busy<=0;
//     end
//     else
//     begin
//         case (wrState)
//             0: begin
//                 busy <= 0;
//                 sysWriteRefresh <= 0;
//                 wrState <= mem[`ENABLE][0] ? 1:0;
//             end
//             1: begin
//                 busy <= 1;
//                 sysAddrMin <= mem[`X_POS][15:0] + mem[`Y_POS][15:0] * `H_DISP;
//                 sysAddrMax <= `H_DISP * (`V_DISP  + 1);
//                 sysLoad <= 1'b1;
//                 wrState <= 2;
//                 wrDiv <= 0;
//             end
//             2: begin
//                 busy <= 1;
//                 sysLoad <= 1'b0;
//                 wrCount <= 0;
//                 wrDiv <= 0;
//                 wrState <= 3;
//             end
//             3: begin
//                 busy <= 1;
//                 wrDiv <= wrDiv + 1;
//                 if(wrDiv == 0)
//                 begin
//                     wrCount <= wrCount + 1;
//                     if(wrCount == mem[`LEN][23:0]+7)
//                     begin
//                         wrState <= 4;
//                     end 
//                 end
//             end
//             4: begin
//                 busy <= 0;
//                 wrState <= mem[`ENABLE][0] ? 4:0;
//                 sysWriteRefresh <= 0;
//             end
//             default: wrState <= 0;
//         endcase
//     end
// end

assign sysWriteEnable = ((wrDiv==1) && (wrState==3))? 1:0;

// System PLL
wire clkRef;       //sdram ctrl clock
wire clkRefOut;    //sdram clock output
wire clkPixel;
wire clkPixel5x;
wire sysRstn;      //sysRstn assign by SystemCrtlPLL
SystemCrtlPLL uSystemCrtlPLL
(
    .clk            (clk),          //50MHz
	.rst_n			(rstn),
    
    .sys_rst_n      (sysRstn),
    .clk_c0         (clkRef),
    .clk_c1         (clkRefOut),
	.clk_c2			(clkPixel),
	.clk_c3			(clkPixel5x)
);

//GPU HDMI Encoder
wire pixelRequest;
wire pingPongSync;
wire[31:0] pixelData;
GPUHDMIEncoder uGPUHDMIEncoder
(
    .clk(clkPixel),
    .clk_TMDS(clkPixel5x),
    .rstn(sysRstn),
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D0_P(HDMI_D0_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D2_P(HDMI_D2_P),
    .RGB(pixelData[31:8]),
    .Request(pixelRequest),
    .PingPongSync(pingPongSync)
);

//SDRAMControl
`define PING_PONG_0 21'h0
`define PING_PONG_1 21'h100_000

wire bitPingPong=mem[`PING_PONG][0];

wire [20:0] wrMinAddr = bitPingPong ? (`PING_PONG_0 | sysAddrMin) : (`PING_PONG_1 | sysAddrMin);
wire [20:0] wrMaxAddr = bitPingPong ? (`PING_PONG_0 | sysAddrMax) : (`PING_PONG_1 | sysAddrMax);

wire [20:0] rdMinAddr = bitPingPong ? (`PING_PONG_1) : (`PING_PONG_0);
wire [20:0] rdMaxAddr = bitPingPong ? (`PING_PONG_1 | (`H_DISP * `V_DISP)) : (`PING_PONG_0 | (`H_DISP * `V_DISP));

SDRAMControl uSDRAMControl
(
    // HOST Side
    .REF_CLK(clkRef),                   //sdram module clock
    .OUT_CLK(clkRefOut),                //sdram clock input
    .RESET_N(sysRstn),                  //sdram module reset

    // FIFO Write Side
    .WR_CLK(clkRef),                    //write fifo clock
    .WR_LOAD(sysLoad),                  //write register load & fifo clear
    .WR_DATA(sysDataIn),                //write data input
    .WR(sysWriteEnable),                //write data request
    .WR_MIN_ADDR(wrMinAddr),            //write start address
    .WR_MAX_ADDR(wrMaxAddr),            //write max address
    .WR_LENGTH(sysWriteLen),            //write burst length
    .WR_FULL(sysFull),
    .WR_EMPTY(sysEmpty),
    .WR_REQ(sysReq),
    .WR_DONE(sysDone),

    // FIFO Read Side
    .RD_CLK(clkPixel),                  //read fifo clock
    .RD_LOAD(pingPongSync),             //read register load & fifo clear
    .RD_DATA(pixelData),                //read data output
    .RD(pixelRequest),                  //read request
    .RD_MIN_ADDR(rdMinAddr),            //read start address
    .RD_MAX_ADDR(rdMaxAddr),            //read max address
    .RD_LENGTH(11'd256),                //read length

    .sysVaild(sysVaild),               
    .sysReadVaild(1'b1),
    .sysWriteRefresh(sysWriteRefresh)
);

endmodule