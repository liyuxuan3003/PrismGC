module AHBlite_GPIO
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
    output wire   [31:0] HRDATA,  
    output wire          HRESP,
    output wire   [3:0]  GPIO_WRITE,
    /*** GPIO0 ***/
    output wire   [31:0] GPIO0_O_ENA,
    output wire   [31:0] GPIO0_O_DAT,
    input  wire   [31:0] GPIO0_I_DAT,
    /*** GPIO1 ***/
    output wire   [31:0] GPIO1_O_ENA,
    output wire   [31:0] GPIO1_O_DAT,
    input  wire   [31:0] GPIO1_I_DAT,
    /*** GPIO2 ***/
    output wire   [31:0] GPIO2_O_ENA,
    output wire   [31:0] GPIO2_O_DAT,
    input  wire   [31:0] GPIO2_I_DAT,
    /*** GPIO3 ***/
    output wire   [31:0] GPIO3_O_ENA,
    output wire   [31:0] GPIO3_O_DAT,
    input  wire   [31:0] GPIO3_I_DAT
);

assign HRESP = 1'b0;
assign HREADYOUT = 1'b1;

/*** 使能部分 ***/
wire write_en;
assign write_en = HSEL & HTRANS[1] & HWRITE & HREADY;

wire read_en;
assign read_en  = HSEL & HTRANS[1] & (~HWRITE) & HREADY;

reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn)
begin
    if(~HRESETn) wr_en_reg <= 1'b0;
    else if(write_en) wr_en_reg <= 1'b1;
    else  wr_en_reg <= 1'b0;
end

reg rd_en_reg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) rd_en_reg <= 1'b0;
    else if(read_en) rd_en_reg <= 1'b1;
    else rd_en_reg <= 1'b0;
end

/*** 地址部分 ***/
reg [3:0] addr_reg;
reg [3:0] addr_group_reg;
always@(posedge HCLK or negedge HRESETn)
begin
    if(~HRESETn) 
    begin
        addr_reg <= 4'h0;
        addr_group_reg <= 4'h0;
    end
    else if(read_en || write_en) 
    begin
        addr_reg <= HADDR[3:0];
        addr_group_reg <= HADDR[7:4];
    end
end

/*** 位宽部分 ***/
reg [3:0] size_dec;
always@(*) begin
    //HADDR[1:0] 地址（最后两位）
    //HSIZE[1:0] 位宽
    //10 Word       32位
    //01 Half Word  16位
    //00 Byte        8位
    case({HADDR[1:0],HSIZE[1:0]})
        //32位访问 1种情况
        4'b0010 : size_dec = 4'b1111;
        //16位访问 2种情况
        4'b0001 : size_dec = 4'b0011;
        4'b1001 : size_dec = 4'b1100;
        //08位访问 4种情况
        4'b0000 : size_dec = 4'b0001;
        4'b0100 : size_dec = 4'b0010;
        4'b1000 : size_dec = 4'b0100;
        4'b1100 : size_dec = 4'b1000;
        //其他情况
        default : size_dec = 4'b0000;
    endcase
end

reg [3:0] size_reg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) size_reg <= 0;
    else if(write_en & HREADY) size_reg <= size_dec;
end

assign GPIO_WRITE=wr_en_reg ? size_reg : 4'h0;

/*** 输入 ***/

assign HRDATA = 
    (rd_en_reg & addr_reg >= 4'h0 & addr_reg < 4'h4 & addr_group_reg == 4'h0) ? {GPIO0_I_DAT} : 
    (rd_en_reg & addr_reg >= 4'h4 & addr_reg < 4'h8 & addr_group_reg == 4'h0) ? {GPIO0_O_ENA} : 
    (rd_en_reg & addr_reg >= 4'h8 & addr_reg < 4'hC & addr_group_reg == 4'h0) ? {GPIO0_O_DAT} : //0
    (rd_en_reg & addr_reg >= 4'h0 & addr_reg < 4'h4 & addr_group_reg == 4'h1) ? {GPIO1_I_DAT} : 
    (rd_en_reg & addr_reg >= 4'h4 & addr_reg < 4'h8 & addr_group_reg == 4'h1) ? {GPIO1_O_ENA} :
    (rd_en_reg & addr_reg >= 4'h8 & addr_reg < 4'hC & addr_group_reg == 4'h1) ? {GPIO1_O_DAT} : //1
    (rd_en_reg & addr_reg >= 4'h0 & addr_reg < 4'h4 & addr_group_reg == 4'h2) ? {GPIO2_I_DAT} : 
    (rd_en_reg & addr_reg >= 4'h4 & addr_reg < 4'h8 & addr_group_reg == 4'h2) ? {GPIO2_O_ENA} :
    (rd_en_reg & addr_reg >= 4'h8 & addr_reg < 4'hC & addr_group_reg == 4'h2) ? {GPIO2_O_DAT} : //2
    (rd_en_reg & addr_reg >= 4'h0 & addr_reg < 4'h4 & addr_group_reg == 4'h3) ? {GPIO3_I_DAT} : 
    (rd_en_reg & addr_reg >= 4'h4 & addr_reg < 4'h8 & addr_group_reg == 4'h3) ? {GPIO3_O_ENA} :
    (rd_en_reg & addr_reg >= 4'h8 & addr_reg < 4'hC & addr_group_reg == 4'h3) ? {GPIO3_O_DAT} : //3
    32'h0000_0000;

/*** 输出 ***/
reg [31:0] o_dat_reg[3:0];
reg [31:0] o_ena_reg[3:0];

wire [3:0] o_group_id;
assign o_group_id=addr_group_reg;

integer i;

always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) 
    begin
        for(i=0;i<4;i=i+1)
        begin
            o_dat_reg[i] <= 32'd0;
            o_ena_reg[i] <= 32'd0;
        end
    end
    else if(wr_en_reg & addr_reg >= 4'h8 & addr_reg < 4'hC)  
    begin
        if(size_reg[0]) o_dat_reg[o_group_id][7:0]   <= HWDATA[7:0];
        if(size_reg[1]) o_dat_reg[o_group_id][15:8]  <= HWDATA[15:8];
        if(size_reg[2]) o_dat_reg[o_group_id][23:16] <= HWDATA[23:16];
        if(size_reg[3]) o_dat_reg[o_group_id][31:24] <= HWDATA[31:24];
    end
    else if(wr_en_reg & addr_reg >= 4'h4 & addr_reg < 4'h8) 
    begin
        if(size_reg[0]) o_ena_reg[o_group_id][7:0]   <= HWDATA[7:0];
        if(size_reg[1]) o_ena_reg[o_group_id][15:8]  <= HWDATA[15:8];
        if(size_reg[2]) o_ena_reg[o_group_id][23:16] <= HWDATA[23:16];
        if(size_reg[3]) o_ena_reg[o_group_id][31:24] <= HWDATA[31:24];
    end
end
    
assign GPIO0_O_DAT = o_dat_reg[0];
assign GPIO0_O_ENA = o_ena_reg[0];
assign GPIO1_O_DAT = o_dat_reg[1];
assign GPIO1_O_ENA = o_ena_reg[1];
assign GPIO2_O_DAT = o_dat_reg[2];
assign GPIO2_O_ENA = o_ena_reg[2];
assign GPIO3_O_DAT = o_dat_reg[3];
assign GPIO3_O_ENA = o_ena_reg[3];

endmodule
