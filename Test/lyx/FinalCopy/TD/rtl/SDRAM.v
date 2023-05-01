module SDRAM #(parameter MEM_ADDR_WIDTH = 0)   
(
    input                       clk,
    input                       rstn,
    input                       clkSdr,
    input                       clkSdrShift,
    input [MEM_ADDR_WIDTH-1:0]  addrIn,
    input [MEM_ADDR_WIDTH-1:0]  addrOut,
    input [3:0]                 sizeDecode,
    input  [31:0]               dataIn,
    output [31:0]               dataOut,
    output                      readyout,
    input                       enableIn,
    output[60:1]        PI4            //下侧双排针
);

wire Sdr_init_done;
wire Sdr_init_ref_vld;
wire Sdr_busy;
wire Sdr_rd_en;

wire  			        SDRAM_CLK;
wire 			        SDR_RAS;
wire  			        SDR_CAS;
wire  			        SDR_WE;
wire  [`BA_WIDTH-1:0]	SDR_BA; 
wire  [`ROW_WIDTH-1:0]	SDR_ADDR;
wire  [`DATA_WIDTH-1:0]	SDR_DQ ;
wire  [`DM_WIDTH-1:0]	SDR_DM; 

sdr_as_ram  #( .self_refresh_open(1'b1)) uSDRAsRAM
( 
    .Sdr_clk(clkSdr),
    .Sdr_clk_sft(clkSdrShift),
    .Rst(~rstn),
                        
    .Sdr_init_done(Sdr_init_done),
    .Sdr_init_ref_vld(Sdr_init_ref_vld),
    .Sdr_busy(Sdr_busy),
    
    .App_ref_req(1'b0),
    
    .App_wr_en(sizeDecode != 0 ? 1'b1 : 1'b0), 
    .App_wr_addr(addrIn),  	
    .App_wr_dm(~sizeDecode),
    .App_wr_din(dataIn),

    .App_rd_en(enableIn),
    .App_rd_addr(addrOut),
    .Sdr_rd_en	(Sdr_rd_en),
    .Sdr_rd_dout(dataOut),

    .SDRAM_CLK(SDRAM_CLK),
    .SDR_RAS(SDR_RAS),
    .SDR_CAS(SDR_CAS),
    .SDR_WE(SDR_WE),
    .SDR_BA(SDR_BA),
    .SDR_ADDR(SDR_ADDR),
    .SDR_DM(SDR_DM),
    .SDR_DQ(SDR_DQ)	
);

EG_PHY_SDRAM_2M_32 sdram2M32
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

assign readyout = Sdr_rd_en;
//assign readyout = (enableIn == 1) ? Sdr_rd_en : 1'b1;
// assign readyout = Sdr_rd_en;
// assign readyout = (Sdr_init_done && ~Sdr_init_ref_vld) || (Sdr_rd_en && enableOut);

assign PI4[5] = Sdr_rd_en;
assign PI4[7] = enableIn;
assign PI4[9] = Sdr_init_done;
assign PI4[11] = Sdr_init_ref_vld;

endmodule 
