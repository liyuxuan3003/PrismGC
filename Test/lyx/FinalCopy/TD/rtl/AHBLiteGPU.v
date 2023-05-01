module AHBLiteGPU
(
    input  wire          HCLK,    
    input  wire          HRESETn, 
    input  wire          HSEL,    
    input  wire   [31:0] HADDR,   
    input  wire    [1:0] HTRANS,  
    input  wire    [2:0] HSIZE,   
    input  wire    [3:0] HPROT,   
    input  wire          HWRITE,  
    input  wire   [31:0] HWDATA,  
    input  wire          HREADY,  
    output wire          HREADYOUT, 
    output reg    [31:0] HRDATA,  
    output wire          HRESP,
    output      HDMI_CLK_P,     //HDMI CLK
    output      HDMI_D2_P,      //HDMI D2
    output      HDMI_D1_P,      //HDMI D1
    output      HDMI_D0_P       //HDMI D0
);

reg    [15:0] X_POS;
reg    [15:0] Y_POS;
reg    [23:0] PIXEL;
reg    [23:0] LEN;
reg           ENABLE;
reg    [8:0]  SYS_WR_LEN;
wire          SYS_VAILD;
wire          BUSY;

assign HRESP = 1'b0;
assign HREADYOUT = 1'b1;

wire write_en;
assign write_en = HSEL & HTRANS[1] & HWRITE & HREADY;

wire read_en;
assign read_en = HSEL & HTRANS[1] & (~HWRITE) & HREADY;

reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) wr_en_reg <= 1'b0;
    else if(write_en) wr_en_reg <= 1'b1;
    else wr_en_reg <= 1'b0;
end

reg rd_en_reg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) rd_en_reg <= 1'b0;
    else if(read_en) rd_en_reg <= 1'b1;
    else rd_en_reg <= 1'b0;
end

reg [7:0] addr_reg;
always@(posedge HCLK or negedge HRESETn)
begin
    if(~HRESETn) 
        addr_reg <= 8'h00;
    else if(read_en || write_en) 
        addr_reg <= HADDR[7:0];
end

always@(*) 
begin
    if(rd_en_reg)
    begin
        case (addr_reg)
            8'h18 : HRDATA <= SYS_VAILD;
            8'h1C : HRDATA <= BUSY;
            default: HRDATA <= 32'h0000_0000;
        endcase
    end
    else
        HRDATA <= 32'h0000_0000;
end

always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) 
    begin
        X_POS <= 0;
        Y_POS <= 0;
        PIXEL <= 0;
        LEN <= 0;
        ENABLE <= 0;
        SYS_WR_LEN <= 0;
    end 
    else if(wr_en_reg && HREADY) 
    begin
        case (addr_reg)
            8'h00 : X_POS <= HWDATA;
            8'h04 : Y_POS <= HWDATA;
            8'h08 : PIXEL <= HWDATA;
            8'h0C : LEN <= HWDATA;
            8'h10 : ENABLE <= HWDATA;
            8'h14 : SYS_WR_LEN <= HWDATA;
        endcase
    end
end

SDRAM_HDMI_Display u_SDRAM_HDMI_Display
(
    .clk(HCLK),
    .rst_n(HRESETn),
    
    //HDMI
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D2_P(HDMI_D2_P),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D0_P(HDMI_D0_P),

    .x_pos(X_POS),
    .y_pos(Y_POS),
    .pixel(PIXEL),
    .len(LEN),
    .enable(ENABLE),
    .sys_wr_len(SYS_WR_LEN),
    .sys_vaild(SYS_VAILD),
    .busy(BUSY)
);

endmodule


