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
    output wire   [31:0] HRDATA,  
    output wire          HRESP,
    output wire   [31:0] HDMI_DATA
);

assign HRESP = 1'b0;
assign HREADYOUT = 1'b1;

wire write_en;
assign write_en = HSEL & HTRANS[1] & HWRITE & HREADY;

reg addr_reg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) addr_reg <= 1'b0;
    else if(write_en) addr_reg <= HADDR[2];
end

reg wr_en_reg;
always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) wr_en_reg <= 1'b0;
    else if(write_en) wr_en_reg <= 1'b1;
    else wr_en_reg <= 1'b0;
end

reg[31:0] hdmi_data_reg;
always@(posedge HCLK) 
begin
    if(~HRESETn) 
    begin
        hdmi_data_reg <= 32'h0000_0001;
    end 
    else if(wr_en_reg && HREADY) 
    begin
        hdmi_data_reg <= HWDATA;
    end
end

assign HDMI_DATA = hdmi_data_reg;

assign HRDATA = HDMI_DATA;

endmodule

