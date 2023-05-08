module AHBlite_Buzzermusic(
    input wire        HCLK,
    input wire        HRESETn,
    input wire        HSEL,
    input wire [31:0] HADDR,
    input   wire    [2:0]   HBURST,
    input   wire            HMASTLOCK,
    input wire [1:0]  HTRANS,
    input wire [2:0]  HSIZE,
    input wire [3:0]  HPROT,
    input wire        HWRITE,
    input wire [31:0] HWDATA,
    input wire        HREADY,
    output wire       HREADYOUT,
    output wire[31:0] HRDATA,
    output wire       HRESP,
    
    output wire [1:0] music_select,
    output wire       music_start
    );

    assign HRESP=1'b0;
    assign HREADYOUT=1'b1;

    wire write_en;
    assign write_en=HSEL & HTRANS[1] & HWRITE & HREADY;

    reg wr_en_reg;
    always@(posedge HCLK or negedge HRESETn)
    begin
     if(~HRESETn)
     wr_en_reg<=1'b0;
     else if(write_en)
     wr_en_reg<=1'b1;
     else
     wr_en_reg<=1'b0;
     end

     assign music_select=wr_en_reg?  HWDATA[1:0]:2'b00;
     assign music_start = wr_en_reg? HWDATA[4]:1'b0;
     assign HRDATA={30'd0,music_select};
     endmodule





 