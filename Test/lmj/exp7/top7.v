module TOP(clk_50M,ina,inb,seg_sel,seg_led);
    input clk_50M;
    input [3:0] ina, inb;
    output [3:0] seg_sel;
output [7:0] seg_led;
    parameter DIVCLK_CNTMAX = 24999; //50M/50K = 1K
wire clk_1K;
    //例化时钟分频模块
    clock_division #(
        .DIVCLK_CNTMAX(DIVCLK_CNTMAX)
    )
    my_clock(
        .clk_in(clk_50M),
        .divclk(clk_1K)
);
    //例化计数器模块
    wire [1:0] bit_disp;
    counter counter(
        .clk(clk_1K),
        .cnt(bit_disp)
);
    //例化多路复用器模块
    wire [3:0] data_disp;
    Mux Mux(
        .sel(bit_disp),
        .ina(ina),
        .inb(inb),
        .data_out(data_disp)
);  
    //例化数码管位选译码模块
    seg_sel_decoder seg_sel_decoder(
        .bit_disp(bit_disp),
        .seg_sel(seg_sel)
    );
    //例化数码管段码译码模块
    seg_led_decoder seg_led_decoder(
        .data_disp(data_disp),
        .seg_led(seg_led)
    );
endmodule