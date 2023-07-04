/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module SystemCrtlPLL
(
    //global clock
    input   clk,
    input   rst_n,

    //synced signal
    output  clk_c0,         //clock output    
    output  clk_c1,         //clock output
    output  clk_c2,         //clock output
    output  clk_c3,         //clock output
    output  sys_rst_n       //system reset
);

//----------------------------------
//component instantiation for system_delay
wire    delay_done;    //system init delay has done
SystemInitDelay
#(
    .SYS_DELAY_TOP      (24'd2500000)
//    .SYS_DELAY_TOP      (24'd256)    //Just for test
)
uSystemInitDelay
(
    //global clock
    .clk                (clk),
    .rst_n              (1'b1),            //It don't depend on rst_n when power up
    //system interface
    .delay_done         (delay_done)
);


//-----------------------------------
//system pll module
wire    pll_rst = ~delay_done;// ? ~locked : 1'b1;    //PLL reset, H valid
wire    locked;
sys_pll    u_sys_pll 
(
  	.refclk			(clk),  
	.reset			(pll_rst),
	.extlock		(locked),
	.clk0_out		(clk_c0),
	.clk1_out		(clk_c1),
	.clk2_out		(clk_c2),
	.clk3_out		(clk_c3)
);

wire    clk_ref = clk_c0;
//----------------------------------------------
//rst_n sync, only controlled by the main clk
reg     rst_nr1, rst_nr2;
always @(posedge clk_ref)
begin
    if(!rst_n)
        begin
        rst_nr1 <= 1'b0;
        rst_nr2 <= 1'b0;
        end
    else
        begin
        rst_nr1 <= 1'b1;
        rst_nr2 <= rst_nr1;
        end
end
assign    sys_rst_n = rst_nr2 & locked;    //active low

endmodule

