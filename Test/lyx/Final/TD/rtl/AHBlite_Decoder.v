module AHBlite_Decoder
#(
    /*RAMCODE enable parameter*/
    parameter Port0_en = 1,
    /************************/

    /*RAMDATA enable parameter*/
    parameter Port1_en = 1,
    /************************/

    /*EMPTY*/
    parameter Port2_en = 0,
    /************************/

    /*UART enable parameter*/
    parameter Port3_en = 1
    /************************/
)
(
    input [31:0] HADDR,

    /*RAMCODE OUTPUT SELECTION SIGNAL*/
    output wire P0_HSEL,

    /*RAMDATA OUTPUT SELECTION SIGNAL*/
    output wire P1_HSEL,

    /*EMPTY*/
    output wire P2_HSEL,

    /*UART OUTPUT SELECTION SIGNAL*/
    output wire P3_HSEL       
);

//RAMCODE
//0x00000000-0x0000ffff
/*Insert RAMCODE decoder code there*/
assign P0_HSEL = (HADDR[31:16] == 16'h0000) ? Port0_en : 1'b0; 
/***********************************/

//RAMDATA
//0X20000000-0X2000FFFF
/*Insert RAMDATA decoder code there*/
assign P1_HSEL = (HADDR[31:16] == 16'h2000) ? Port1_en : 1'b0; 
/***********************************/


//EMPTY
assign P2_HSEL = 1'b0; 
/***********************************/

//UART
//0X40000010 UART RX DATA
//0X40000014 UART TX STATE
//0X40000018 UART TX DATA
/*Insert UART decoder code there*/
assign P3_HSEL = (HADDR[31:4] == 28'h4000_001) ? Port3_en : 1'b0;
/***********************************/

endmodule