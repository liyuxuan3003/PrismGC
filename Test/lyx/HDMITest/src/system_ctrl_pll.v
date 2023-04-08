`timescale 1 ns / 1 ns
module system_ctrl_pll
(
    //global clock
    input               clk,
    input               rst_n,

    //synced signal
    output              clk_c0,     //clock output    
    output              clk_c1,     //clock output  
    output              clk_c2,     //clock output  
    output              clk_c3,     //clock output  
    output              clk_c4,     //clock output  
    output              sys_rst_n,  //system reset

    //lock
    output              locked
);


//----------------------------------
//component instantiation for system_delay
wire    delay_done;    //system init delay has done
system_init_delay
#(
    .SYS_DELAY_TOP      (24'd2500000)
//    .SYS_DELAY_TOP      (24'd256)    //Just for test
)
u_system_init_delay
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
sys_pll    u_sys_pll 
(
    .refclk             (clk),
    .reset              (pll_rst),
    .extlock            (locked),
    .clk0_out           (clk_c0),
    .clk1_out           (clk_c1),
    .clk2_out           (clk_c2),
    .clk3_out           (clk_c3),
    .clk4_out           (clk_c4)
);


//----------------------------------------------
//rst_n sync, only controlled by the main clk
reg     rst_nr1, rst_nr2;
always @(posedge clk_c0)
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
