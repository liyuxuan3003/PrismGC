module TOP(clk_50M,units,tens,rst_n,preset_n,seg_sel,seg_led,row);
    input clk_50M;
    input [3:0] units,tens;
    input rst_n;
    input preset_n;
    output [3:0] seg_sel;
    output [7:0] seg_led;    
    output [3:0] row;
//将行列键盘的行输出0
    assign row = 4'b0000;    

    //50M/1K = 5K
    parameter DIVCLK_CNTMAX_1ms = 24999;
    wire clk_1ms;
    //50M/1 = 50M
    parameter DIVCLK_CNTMAX_1s = 24999999;
    wire clk_1s;

    //例化时钟分频模块,得到周期为1ms的时钟
    clock_division #(
        .DIVCLK_CNTMAX(DIVCLK_CNTMAX_1ms)
    )
    my_clock_0(
        .clk_in(clk_50M),
        .divclk(clk_1ms)
    );

    //例化时钟分频模块，得到周期为1s的时钟
    clock_division #(
        .DIVCLK_CNTMAX(DIVCLK_CNTMAX_1s)
    )
    my_clock_1(
        .clk_in(clk_50M),
        .divclk(clk_1s)
    );

    //例化BCD码向下计数器模块，并进行级联
    wire bin;
    wire bout_0;
    wire bout_1;
    wire [3:0] units_disp;
    wire [3:0] tens_disp;
    assign bin = units_disp || tens_disp;
    BCD_downcounter downcounter_0(
        .clk(clk_1s),
        .rst_n(rst_n),
        .bin(bin),
        .preset_n(preset_n),
        .BCD_i(units),
        .BCD_o(units_disp),
        .bout(bout_0)
    );        

    BCD_downcounter downcounter_1(
        .clk(clk_1s),
        .rst_n(rst_n),
        .bin(bout_0),
        .preset_n(preset_n),
        .BCD_i(tens),
        .BCD_o(tens_disp),
        .bout(bout_1)
    );
  //例化数码管显示模块 
  Digitron4bits mydigitron        
   (.clk_1K(clk_1ms),  
    .ina(units_disp),   
	.inb(tens_disp),   
	.inc(units_disp),	
	.ind(tens_disp),	
	.dot(3'b110),
	.seg_sel(seg_sel),
	.seg_led(seg_led));  
endmodule