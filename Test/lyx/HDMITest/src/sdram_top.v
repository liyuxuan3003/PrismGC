`timescale 1ns / 1ps

`include "sdram_global_def.v"

module sdram_top
(   
	input   SYS_CLK,

    input   local_clk,
    input   Clk,
    input   Clk_sft,

    input 	    				    App_wr_en,
    input   [`ADDR_WIDTH-1:0]	    App_wr_addr,
    input   [`DM_WIDTH-1:0]	        App_wr_dm,
    input   [`DATA_WIDTH-1:0]	    App_wr_din,

    input 	    				    App_rd_en,
    input   [`ADDR_WIDTH-1:0]	    App_rd_addr,
    output 	    				    Sdr_rd_en,
    output  [`DATA_WIDTH-1:0]	    Sdr_rd_dout
);

wire			            lock;
wire                        Rst;

wire  			            SDRAM_CLK;
wire 			            SDR_RAS;
wire  			            SDR_CAS;
wire  			            SDR_WE;
wire  [`BA_WIDTH-1:0]	    SDR_BA; 
wire  [`ROW_WIDTH-1:0]	    SDR_ADDR;
wire  [`DATA_WIDTH-1:0]	    SDR_DQ ;
wire  [`DM_WIDTH-1:0]	    SDR_DM; 

wire 		                Sdr_init_done;
wire                        Sdr_init_ref_vld;

reg	[7:0]	rst_cnt=0;	
always @(posedge SYS_CLK)
begin
	if (rst_cnt[7])
		rst_cnt <=  rst_cnt;
	else
		rst_cnt <= rst_cnt+1'b1;
end

assign Rst=!lock;

sdr_as_ram #( .self_refresh_open(1'b1)) u_sdr_as_ram
( 
    .Sdr_clk(Clk),
    .Sdr_clk_sft(Clk_sft),
    .Rst(Rst),
                        
    .Sdr_init_done(Sdr_init_done),
    .Sdr_init_ref_vld(Sdr_init_ref_vld),
    .Sdr_busy(Sdr_busy),

    .App_ref_req(1'b0),

    .App_wr_en(App_wr_en), 
    .App_wr_addr(App_wr_addr),  	
    .App_wr_dm(App_wr_dm),
    .App_wr_din(App_wr_din),

    .App_rd_en(App_rd_en),
    .App_rd_addr(App_rd_addr),
    .Sdr_rd_en	(Sdr_rd_en),
    .Sdr_rd_dout(Sdr_rd_dout),

    .SDRAM_CLK(SDRAM_CLK),
    .SDR_RAS(SDR_RAS),
    .SDR_CAS(SDR_CAS),
    .SDR_WE(SDR_WE),
    .SDR_BA(SDR_BA),
    .SDR_ADDR(SDR_ADDR),
    .SDR_DM(SDR_DM),
    .SDR_DQ(SDR_DQ)	
);

assign SDR_CKE=1'b1;

EG_PHY_SDRAM_2M_32 u_sdram
(
    .clk(SDRAM_CLK),
    .ras_n(SDR_RAS),
    .cas_n(SDR_CAS),
    .we_n(SDR_WE),
    .addr(SDR_ADDR[10:0]),
    .ba(SDR_BA),
    .dq(SDR_DQ),
    .cs_n(1'b0),
    .dm0(SDR_DM[0]),
    .dm1(SDR_DM[1]),
    .dm2(SDR_DM[2]),
    .dm3(SDR_DM[3]),
    .cke(1'b1)
);

endmodule 
