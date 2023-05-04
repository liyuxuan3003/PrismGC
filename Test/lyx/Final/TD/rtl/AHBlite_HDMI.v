module AHBlite_HDMI
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
    output reg    [15:0] X_POS,
    output reg    [15:0] Y_POS,
    output reg    [23:0] PIXEL,
    output reg    [23:0] LEN,
    output reg           ENABLE,
    output reg    [8:0]  SYS_WR_LEN,
    input                SYS_VAILD,
    input                BUSY
);

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

endmodule


