
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
    output reg          busy
);

//system global clock control
wire    clk_sdr;    //sdram ctrl clock
wire    clk_sdr_shift; //sdram clock output
wire	clk_pixel;
wire    clk_pixel_5x;
wire    sys_rst_n;  //global reset
system_ctrl_pll u_system_ctrl_pll
(
    .clk            (clk),          //50MHz
	.rst_n			(rst_n),	    //global reset
    
    .sys_rst_n      (sys_rst_n),    //global reset
    .clk_c0         (clk_sdr),      //144MHz 
    .clk_c1         (clk_sdr_shift),   //144MHz -90deg
	.clk_c2			(clk_pixel),	//1x pixel clock
	.clk_c3			(clk_pixel_5x)	//5x pixel clock
);

//sdram read port
wire    [31:0]  sys_data_out;
wire            sys_rd;

//sdram write port
reg            sys_load;
reg    [23:0]  sys_data_in;
wire           sys_we;
reg    [31:0]  sys_addr_min;
reg    [31:0]  sys_addr_max;

wire           sdram_init_done;            //sdram init done

//Sdram_Control_2Port module     
Sdram_Control_2Port    u_Sdram_Control_2Port
(
    //    HOST Side
    .REF_CLK            (clk_sdr),          //sdram module clock
    .OUT_CLK            (clk_sdr_shift),       //sdram clock input
    .RESET_N            (sys_rst_n),        //sdram module reset

    //    FIFO Write Side
    .WR_CLK             (clk_sdr),        //write fifo clock
    .WR_LOAD            (sys_load),         //write register load & fifo clear
    .WR_DATA            ({sys_data_in,8'b0}),      //write data input
    .WR                 (sys_we),           //write data request
    .WR_MIN_ADDR        (sys_addr_min),     //write start address
    .WR_MAX_ADDR        (sys_addr_max),     //write max address
    .WR_LENGTH          (sys_wr_len),       //write burst length

    //    FIFO Read Side
    .RD_CLK             (clk_pixel),         //read fifo clock
    .RD_LOAD            (1'b0),             //read register load & fifo clear
    .RD_DATA            (sys_data_out),     //read data output
    .RD                 (sys_rd),           //read request
    .RD_MIN_ADDR        (21'd0),            //read start address
    .RD_MAX_ADDR        (`H_DISP * `V_DISP),//read max address
    .RD_LENGTH          (9'd256),           //read length
    
    //User interface add by CrazyBingo
    .Sdram_Init_Done    (sdram_init_done),  //SDRAM init done signal
    .Sdram_Read_Valid   (1'b1),             //Enable to read
    .Sdram_PingPong_EN  (1'b0)              //SDRAM PING-PONG operation enable
);

//HDMI Encoder
HDMIEncoder uHDMIEncoder
(
    //global clock
    .clk                (clk_pixel),        
    .clk_TMDS           (clk_pixel_5x),        
    //.rst_n              (sys_rst_n), 
     
	.HDMI_CLK_P(HDMI_CLK_P),
	.HDMI_D2_P(HDMI_D2_P),
	.HDMI_D1_P(HDMI_D1_P),
	.HDMI_D0_P(HDMI_D0_P),
    
    //user interface
    .Request        (sys_rd),
    .PixelData      (sys_data_out[31:8]),    
    .CounterX       (),    
    .CounterY       (),
	.Blank			()
);

localparam  H_DISP = 12'd1024;  
localparam	V_DISP = 12'd600; 
assign sys_vaild = sdram_init_done;

reg[4:0] cnt_div;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_div <= 0;
    else
        cnt_div <= cnt_div + 1;
end

reg[23:0] cnt;
reg state;
reg done;
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
    begin
        state <= 0;
        sys_addr_max <= H_DISP * V_DISP;
        done <= 0;
        cnt <= 0;
    end
    else if(sys_vaild)
    begin
        if(enable == 1'b0)
            done = 1'b0;
        else if(enable == 1'b1 & busy == 1'b0 & done == 1'b0)
        begin
            busy <= 1'b1;
            sys_addr_min <= x_pos + y_pos * H_DISP;
            sys_addr_max <= H_DISP * (V_DISP  + 1);
            sys_load <= 1'b1;
            cnt <= 0;
            state <= 1'b0;
        end
        else if(busy == 1'b1)
        begin
            sys_load <= 1'b0;
            if(cnt_div==0)
            begin
                sys_data_in <= pixel;
                cnt <= cnt + 1;
                if(cnt == len+254)
                begin
                    busy <= 1'b0;
                    done <= 1'b1;
                end
            end        
        end
    end
end

assign sys_we = (cnt_div==1) & busy;

endmodule
