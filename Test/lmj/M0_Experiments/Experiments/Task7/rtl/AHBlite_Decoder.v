module AHBlite_Decoder
#(
    /*RAMCODE enable parameter*/
    parameter Port0_en = 1,
    /************************/

    /*RAMDATA enable parameter*/
    parameter Port1_en = 1,
    /************************/

    /*keyboard enable parameter*/
    parameter Port2_en = 1,
    /************************/

    /*buzzermusic enable parameter*/
    parameter Port3_en= 1
    /************************/
)(
    input [31:0] HADDR,

    /*RAMCODE OUTPUT SELECTION SIGNAL*/
    output wire P0_HSEL,

    /*RAMDATA OUTPUT SELECTION SIGNAL*/
    output wire P1_HSEL,

    /*keyboard OUTPUT SELECTION SIGNAL*/
    output wire P2_HSEL,

    /*buzzermusic OUTPUT SELECTION SIGNAL*/
    output wire P3_HSEL       
);

//RAMCODE-----------------------------------
//0x00000000-0x0000ffff
/*Insert RAMCODE decoder code there*/

assign P0_HSEL = (HADDR[31:16] == 16'h0000) ? Port0_en : 1'b0; 
/***********************************/



//RAMDATA-----------------------------
//0x20000000-0x2000ffff
/*Insert RAMDATA decoder code there*/

assign P1_HSEL = (HADDR[31:16] == 16'h2000) ? Port1_en : 1'b0;
/***********************************/

//------------------------------


//0x40000000 key_data/key_clear

assign P2_HSEL =(HADDR[31:4] == 28'h4000000) ? Port2_en : 1'b0;
/***********************************/

//0x40000010 buzzermusic select/en

assign P3_HSEL =(HADDR[31:4] == 28'h4000001) ? Port3_en : 1'b0;
/***********************************/

endmodule