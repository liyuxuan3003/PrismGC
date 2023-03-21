module TOP(clk_50M,seg_sel,seg_led,sw,min);
    input clk_50M;
	input [1:0] sw;    
    output min;
    output [3:0] seg_sel;
    output [7:0] seg_led;

    //50M/50K = 1K
    parameter DIVCLK_CNTMAX_1000 = 24999;
    wire clk_1K;
   //50M/500K = 100
    parameter DIVCLK_CNTMAX_100 = 249999;
    wire clk_100;    

    //例化时钟分频模块1
    clock_division #(
        .DIVCLK_CNTMAX(DIVCLK_CNTMAX_1000)
    )
    clk_1000Hz(
        .clk_in(clk_50M),
        .divclk(clk_1K)
    );        
    //例化时钟分频模块2
    clock_division #(
        .DIVCLK_CNTMAX(DIVCLK_CNTMAX_100)
    )
    clk_100Hz(
        .clk_in(clk_50M),
        .divclk(clk_100)
    );              
    //例化秒表计数模块              
    wire min;
    wire[3:0] sec_0_01,sec_0_1,sec_1,sec_10;   
    Stopwatch mystopwatch    
    (    
     .clk_100(clk_100),    
     .sw(sw),     
     .sec_0_01(sec_0_01),     
     .sec_0_1(sec_0_1),     
     .sec_1(sec_1),     
     .sec_10(sec_10),     
     .min(min)     
      );    
  //例化数码管显示模块 
  Digitron4bits mydigitron    // 用digitron4bits类型的程序，创建一个名为mydigitron的实例   
   (.clk_1K(clk_1K),  
    .ina(sec_0_01),   
	.inb(sec_0_1),   
	.inc(sec_1),	
	.ind(sec_10),	
	.dot(3'b111),
	.seg_sel(seg_sel),
	.seg_led(seg_led));  
endmodule