`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: anlgoic
// Author: 	xg 
// description:  top module
//////////////////////////////////////////////////////////////////////////////////

`define DEBUG

`include "global_def.v"

module top
(   
	input   SYS_CLK,
		
	output	LED,

    output[60:1] PI4
);

wire			            lock;
wire                        local_clk;
wire                        Clk;
wire                        Clk_sft;
wire                        Rst;

wire  			            SDRAM_CLK;
wire 			            SDR_RAS;
wire  			            SDR_CAS;
wire  			            SDR_WE;
wire  [`BA_WIDTH-1:0]	    SDR_BA; 
wire  [`ROW_WIDTH-1:0]	    SDR_ADDR;
wire  [`DATA_WIDTH-1:0]	    SDR_DQ ;
wire  [`DM_WIDTH-1:0]	    SDR_DM; 

wire 	    				    App_wr_en;
wire   [`ADDR_WIDTH-1:0]	    App_wr_addr;
wire   [`DM_WIDTH-1:0]	        App_wr_dm;
wire   [`DATA_WIDTH-1:0]	    App_wr_din;

wire 	    				    App_rd_en;
wire   [`ADDR_WIDTH-1:0]	    App_rd_addr;
wire 	    				    Sdr_rd_en;
wire  [`DATA_WIDTH-1:0]	        Sdr_rd_dout;

wire 		                Sdr_init_done;
wire                        Sdr_init_ref_vld;

wire		                Check_ok;   //synthesis keep

assign LED=Check_ok;
assign PI4[5]=Check_ok;
assign PI4[7]=App_rd_en;

reg	[7:0]	rst_cnt=0;	
always @(posedge SYS_CLK)
begin
	if (rst_cnt[7])
		rst_cnt <=  rst_cnt;
	else
		rst_cnt <= rst_cnt+1'b1;
end


clk_pll u0_clk
(
    .refclk(SYS_CLK),
    .reset(!rst_cnt[7]),
    .extlock(lock),
    .clk0_out(local_clk),
    .clk1_out(Clk),
    .clk2_out(Clk_sft)
);

assign Rst=!lock;

wire[2:0] judgecnt;

app_wrrd u1_app_wrrd
(   
    .Clk(Clk),
    .Rst(Rst),
    
    .Sdr_init_done(Sdr_init_done),
    .Sdr_init_ref_vld(Sdr_init_ref_vld),

    .App_wr_en(App_wr_en), 
    .App_wr_addr(App_wr_addr),  	
    .App_wr_dm(App_wr_dm),
    .App_wr_din(App_wr_din),

    .App_rd_en(App_rd_en),
    .App_rd_addr(App_rd_addr),
    .Sdr_rd_en	(Sdr_rd_en),
    .Sdr_rd_dout(Sdr_rd_dout),
    .Check_ok(Check_ok),

    .judgecnt(judgecnt)
);

sdr_as_ram #( .self_refresh_open(1'b1)) u2_ram
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

EG_PHY_SDRAM_2M_32 sdram
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
