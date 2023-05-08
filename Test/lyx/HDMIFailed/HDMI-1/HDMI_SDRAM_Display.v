
module HDMI_SDRAM_Display
(
    //global clock
    input               clk,
    input               rst_n,          //global reset
    
	//HDMI
	output			HDMI_CLK_P,
	output			HDMI_D2_P,
	output			HDMI_D1_P,
	output			HDMI_D0_P,

    //LCD
    input[15:0]         x_pos,
    input[15:0]         y_pos,
    input[23:0]         pixel,
    input[23:0]         len,
    input               enable,
    input[8:0]          sys_wr_len,
    output              sys_vaild,
    output              busy
);

//system global clock control
wire    clk_ref;    //sdram ctrl clock
wire    clk_refout; //sdram clock output
wire	clk_pixel, clk_pixel_5x;
wire    sys_rst_n;  //global reset
system_ctrl_pll u_system_ctrl_pll
(
    .clk            (clk),          //50MHz
	.rst_n			(rst_n),	    //global reset
    
    .sys_rst_n      (sys_rst_n),    //global reset
    .clk_c0         (clk_ref),      //144MHz 
    .clk_c1         (clk_refout),   //144MHz -90deg
	.clk_c2			(clk_pixel),	//1x pixel clock
	.clk_c3			(clk_pixel_5x)	//5x pixel clock
);


//Sdram_Control_2Port module     
//sdram write port
wire            clk_write   =   clk_ref;    //Change with input signal
wire    [31:0]  sys_data_in =   {sys_data, sys_data[7:0]};
//sdram read port
wire            clk_read    =   clk_pixel;    //Change with vga timing    
wire    [31:0]  sys_data_out;
wire            sys_rd_out;
Sdram_Control_2Port    u_Sdram_Control_2Port
(
    //    HOST Side
    .REF_CLK            (clk_ref),          //sdram module clock
    .OUT_CLK            (clk_refout),       //sdram clock input
    .RESET_N            (sys_rst_n),        //sdram module reset

    //    FIFO Write Side
    .WR_CLK             (clk_write),        //write fifo clock
    .WR_LOAD            (sys_load),         //write register load & fifo clear
    .WR_DATA            (sys_data_in),      //write data input
    .WR                 (sys_we),           //write data request
    .WR_MIN_ADDR        (sys_addr_min),     //write start address
    .WR_MAX_ADDR        (sys_addr_max),     //write max address
    .WR_LENGTH          (sys_wr_len),       //write burst length

    //    FIFO Read Side
    .RD_CLK             (clk_read),         //read fifo clock
    .RD_LOAD            (1'b0),             //read register load & fifo clear
    .RD_DATA            (sys_data_out),     //read data output
    .RD                 (sys_rd_out),       //read request
    .RD_MIN_ADDR        (21'd0),            //read start address
    .RD_MAX_ADDR        (`H_DISP * `V_DISP),//read max address
    .RD_LENGTH          (9'd256),           //read length
    
    //User interface add by CrazyBingo
    .Sdram_Init_Done    (sdram_init_done),  //SDRAM init done signal
    .Sdram_Read_Valid   (1'b1),             //Enable to read
    .Sdram_PingPong_EN  (1'b0)              //SDRAM PING-PONG operation enable
);

//-------------------------------------
//LCD driver timing
lcd_driver u_lcd_driver
(
    //global clock
    .clk                (clk_pixel),        
    .rst_n              (sys_rst_n), 

    .clk_pixel(clk_pixel),
    .clk_pixel_5x(clk_pixel_5x),
     
	 //lcd interface
	.lcd_dclk			(),
	.lcd_blank			(),
	.lcd_sync			(),		    	

	.HDMI_CLK_P(HDMI_CLK_P),
	.HDMI_D2_P(HDMI_D2_P),
	.HDMI_D1_P(HDMI_D1_P),
	.HDMI_D0_P(HDMI_D0_P),
    
    //user interface
    .lcd_request        (sys_rd_out),
    .lcd_data           (sys_data_out[31:8]),    
    .lcd_xpos           (),    
    .lcd_ypos           ()
);

//-------------------------------------------
//Generate LCD Test picture
wire            sys_load;
wire    [23:0]  sys_data;
wire            sys_we;
wire    [31:0]  sys_addr_min;
wire    [31:0]  sys_addr_max;

wire            sdram_init_done;            //sdram init done

assign sys_vaild = sdram_init_done;
LCD_Control    
#(
    .H_DISP             (`H_DISP),
    .V_DISP             (`V_DISP)
)
u_LCD_Control
(
    .clk                (clk_ref),        
    .rst_n              (sys_rst_n),     
    
    .sys_vaild          (sdram_init_done),
    .sys_load           (sys_load),
    .sys_data           (sys_data),    
    .sys_we             (sys_we),
    .sys_addr_min       (sys_addr_min),
    .sys_addr_max       (sys_addr_max),
    
    .x_pos(x_pos),
    .y_pos(y_pos),
    .pixel(pixel),
    .len(len),
    .enable(enable),
    .busy(busy)
);

endmodule
