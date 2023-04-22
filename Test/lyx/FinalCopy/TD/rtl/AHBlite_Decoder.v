module AHBlite_Decoder
(
    input [31:0] HADDR,

    output[7:0] HSEL_A
);

//RAMCODE
//0x0000_0000-0X0000_ffff
/*Insert RAMCODE decoder code there*/
assign HSEL_A[0] = (HADDR[31:16] == 16'h0000) ? 1'b1 : 1'b0; 
/***********************************/

//RAMDATA
//0X2000_0000-0X2000_FFFF
/*Insert RAMDATA decoder code there*/
assign HSEL_A[1] = (HADDR[31:16] == 16'h2000) ? 1'b1 : 1'b0; 
/***********************************/

//GPIO-n (n=0,1,2,3)
//0X4001_00n0 IN  DATA
//0x4001_00n4 OUT ENABLE
//0X4001_00n8 OUT DATA
/*Insert GPIO decoder code there*/
assign HSEL_A[2] = (HADDR[31:16] == 16'h4001) ? 1'b1 : 1'b0;
/***********************************/

//UART
//0X4000_0010 UART RX DATA
//0X4000_0014 UART TX STATE
//0X4000_0018 UART TX DATA
/*Insert UART decoder code there*/
assign HSEL_A[3] = (HADDR[31:4] == 28'h4000_001) ? 1'b1 : 1'b0;
/***********************************/

//HDMI
//0X4002_0000 XPOS
//0X4002_0004 YPOS
//0X4002_0008 PIXEL
//0X4002_000C LEN
//0x4002_0010 ENABLE
//0x4002_0014 SYS_WR_LEN
//0x4002_0018 SYS_VAILD
//0x4002_001C BUSY
/*Insert HDMI decoder code there*/
assign HSEL_A[4] = (HADDR[31:16] == 16'h4002) ? 1'b1 : 1'b0;
/***********************************/

assign HSEL_A[7:5] = 0;

endmodule