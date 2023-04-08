module AHBlite_Decoder
#(
    /*RAMCODE enable parameter*/
    parameter Port0_en = 1,
    /************************/

    /*RAMDATA enable parameter*/
    parameter Port1_en = 1,
    /************************/

    /*GPIO enable parameter*/
    parameter Port2_en = 1,
    /************************/

    /*UART enable parameter*/
    parameter Port3_en = 1,
    /************************/

    /*HDMI enable parameter*/
    parameter Port4_en = 1,
    /************************/

    /*? enable parameter*/
    parameter Port5_en = 0,
    /************************/

    /*? enable parameter*/
    parameter Port6_en = 0,
    /************************/

    /*? enable parameter*/
    parameter Port7_en = 0
    /************************/
)
(
    input [31:0] HADDR,

    /*RAMCODE OUTPUT SELECTION SIGNAL*/
    output wire P0_HSEL,

    /*RAMDATA OUTPUT SELECTION SIGNAL*/
    output wire P1_HSEL,

    /*GPIO OUTPUT SELECTION SIGNAL*/
    output wire P2_HSEL,

    /*UART OUTPUT SELECTION SIGNAL*/
    output wire P3_HSEL,   

    /*HDMI OUTPUT SELECTION SIGNAL*/
    output wire P4_HSEL,

    /*? OUTPUT SELECTION SIGNAL*/
    output wire P5_HSEL,

    /*? OUTPUT SELECTION SIGNAL*/
    output wire P6_HSEL,

    /*? OUTPUT SELECTION SIGNAL*/
    output wire P7_HSEL    
);

//RAMCODE
//0x0000_0000-0X0000_ffff
/*Insert RAMCODE decoder code there*/
assign P0_HSEL = (HADDR[31:16] == 16'h0000) ? Port0_en : 1'b0; 
/***********************************/

//RAMDATA
//0X2000_0000-0X2000_FFFF
/*Insert RAMDATA decoder code there*/
assign P1_HSEL = (HADDR[31:16] == 16'h2000) ? Port1_en : 1'b0; 
/***********************************/

//GPIO-n (n=0,1,2,3)
//0X4001_00n0 IN  DATA
//0x4001_00n4 OUT ENABLE
//0X4001_00n8 OUT DATA
/*Insert GPIO decoder code there*/
assign P2_HSEL = (HADDR[31:16] == 16'h4001) ? Port2_en : 1'b0;
/***********************************/

//UART
//0X4000_0010 UART RX DATA
//0X4000_0014 UART TX STATE
//0X4000_0018 UART TX DATA
/*Insert UART decoder code there*/
assign P3_HSEL = (HADDR[31:4] == 28'h4000_001) ? Port3_en : 1'b0;
/***********************************/

//HDMI
//0X4002_0000 LCD CMD
//0X4002_0010 LCD CLR
/*Insert HDMI decoder code there*/
assign P4_HSEL = (HADDR[31:16] == 16'h4002) ? Port4_en : 1'b0;
/***********************************/

endmodule