
module HDMI_SDRAM_Display
(
    //global clock
    input           clk,
    input           rst_n,          //global reset
    
	//HDMI
	output			HDMI_CLK_P,
	output			HDMI_D2_P,
	output			HDMI_D1_P,
	output			HDMI_D0_P,

    //LCD
    input[15:0]     x_pos,
    input[15:0]     y_pos,
    input[23:0]     pixel,
    input[23:0]     len,
    input           enable,
    input[8:0]      sys_wr_len,
    output          sys_vaild,
    output       	busy

	//VRAM PingPong ADDRESS
	reg[23:0]       pingAddr;
	reg[23:0]       pongAddr;
);

//system global clock control
wire    clk_sdr;       //sdram ctrl clock
wire    clk_sdr_shift; //sdram clock output
wire	clk_pixel;
wire    clk_pixel_5x;
wire    sys_rst_n;     //global reset
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
reg            sys_rload;
wire   [31:0]  sys_rdata;
wire           sys_rd;
reg    [23:0]  sys_raddr_min;
reg    [23:0]  sys_raddr_max;

//sdram write port
reg            sys_wload;
reg    [23:0]  sys_wdata;
wire           sys_we;
reg    [23:0]  sys_waddr_min;
reg    [23:0]  sys_waddr_max;
wire           sys_we_force;

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
    .WR_LOAD            (sys_wload),         //write register load & fifo clear
    .WR_DATA            (sys_wdata),      //write data input
    .WR                 (sys_we),           //write data request
    .WR_MIN_ADDR        (sys_waddr_min),     //write start address
    .WR_MAX_ADDR        (sys_waddr_max),     //write max address
    .WR_LENGTH          (sys_wr_len),       //write burst length

    //    FIFO Read Side
    .RD_CLK             (clk_pixel),        //read fifo clock
    .RD_LOAD            (1'b0),             //read register load & fifo clear
    .RD_DATA            (sys_rdata),        //read data output
    .RD                 (sys_rd),           //read request
    .RD_MIN_ADDR        (sys_raddr_min),    //read start address
    .RD_MAX_ADDR        (sys_raddr_max),    //read max address
    .RD_LENGTH          (9'd256),           //read length
    
    //User interface add by CrazyBingo
    .Sdram_Init_Done    (sdram_init_done),  //SDRAM init done signal
	.WR_FORCE           (sys_we_force)
);

//HDMI Encoder
HDMIEncoder uHDMIEncoder
(
    //global clock
    .clk                (clk_pixel),        
    .clk_TMDS           (clk_pixel_5x),        
    .rst_n              (sys_rst_n), 
     
	.HDMI_CLK_P(HDMI_CLK_P),
	.HDMI_D2_P(HDMI_D2_P),
	.HDMI_D1_P(HDMI_D1_P),
	.HDMI_D0_P(HDMI_D0_P),
    
    //user interface
    .Request        (Request),
    .PixelData      (sys_rdata),    
    .CounterX       (),    
    .CounterY       (),
	.Blank			(Blank)
);

assign sys_vaild = sdram_init_done;

always @(negedge rst_n)
begin
	pingAddr <= 0;
	pongAddr <= 0;
end

reg[1:0]  wrState;
reg[4:0]  wrDiv;
reg[23:0] wrCount;
reg sysForceWriteReg;
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
	begin
        wrState <= 0;
		wrCount <= 0;
		wrDiv <= 0;
	end
    else
	case (wrState)
		0: wrState <= enable ? 1:0;
		1: begin
			sys_waddr_min <= pingAddr + x_pos + y_pos * H_DISP;
			sys_waddr_max <= pingAddr + H_DISP * (V_DISP  + 1);
			sys_wload <= 1'b1;
			wrState <= 2;
			end
		2: begin
            sys_wload <= 1'b0;
			wrCount <= 0;
			wrDiv <= 0;
			wrState <= 3;
			end
		3: begin
			wrDiv <= wrDiv + 1;
			sys_wdata <= pixel;
			if(wrDiv == 0)
			begin
                wrCount <= wrCount + 1;
                if(wrCount == len+254)
					wrState <= 4;
				//if(wrCount == len)
				//begin
				//	wrState <= 4;
				//	if(len<256)
				//		sysForceWriteReg <= 1;
			end
		4: begin
			wrState <= enable? 4:0;
			sysForceWrite <= 0;
			end
		default: wrState <= 0;
    end
end
assign busy = (wrState==1) | (wrState==2) | (wrState==3);
assign sys_we = (cnt_div==1) & (wrState==3);
assign sys_we_force = sysForceWrite;

wire Request;
wire Blank;
reg [1:0] rdState;
always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n)
        rdState <= 0;
	else
	begin
		case(rdState)
		0: rdState <= Blank? 1:0;
		1: begin
			sys_raddr_min <= pongAddr;
			sys_raddr_max <= pongAddr + H_DISP * V_DISP;
			sys_rload <= 1;
			rdState <= 2;
			end
		2: begin
			sys_rload <= 0;
			rdState <= 3;
			end
		3: rdState <= Request?0:3; 
		default: rdState <= 0; 
	end		
end
assign sys_rd = Request;

endmodule
