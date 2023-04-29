module AHBLite #(parameter DEVICES_EXP=4)
(
    // CLK & RST
    input               HCLK,
    input               HRESETn,

    // CORE SIDE
    input       [31:0]  HADDR,
    input       [2:0]   HBURST,
    input               HMASTLOCK,
    input       [3:0]   HPROT,
    input       [2:0]   HSIZE,
    input       [1:0]   HTRANS,
    input       [31:0]  HWDATA,
    input               HWRITE,
    output              HREADY,
    output      [31:0]  HRDATA,
    output              HRESP
);

wire[2**DEVICES_EXP-1:0]    HSEL_A;
wire[2**DEVICES_EXP-1:0]    HREADYOUT_A;
wire[2**DEVICES_EXP-1:0]    HRESP_A;
wire[2**DEVICES_EXP*32-1:0] HRDATA_A;

AHBLiteDecoder  #(.DEVICES_EXP(DEVICES_EXP)) uAHBLiteDecoder
(
    .HADDR(HADDR),
    .HSEL_A(HSEL_A)
);

AHBLiteSlaveMux #(.DEVICES_EXP(DEVICES_EXP)) uAHBLiteSlaveMux
(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HREADY(HREADY),
    .HSEL_A(HSEL_A),
    .HREADYOUT_A(HREADYOUT_A),
    .HRESP_A(HRESP_A),
    .HRDATA_A(HRDATA_A),
    .HREADYOUT(HREADY),
    .HRESP(HRESP),
    .HRDATA(HRDATA)
);

`define idRAMCode       0
`define idRamData       1

AHBLiteBlockRAM uRAMCode
(
    .HCLK(HCLK),    
    .HRESETn(HRESETn), 
    .HSEL(HSEL_A[`idRAMCode]),    
    .HADDR(HADDR),   
    .HTRANS(HTRANS),  
    .HSIZE(HSIZE),   
    .HPROT(HPROT),   
    .HWRITE(HWRITE),  
    .HWDATA(HWDATA),   
    .HREADY(HREADY), 
    .HREADYOUT(HREADYOUT_A[`idRAMCode]), 
    .HRDATA(HRDATA_A[(`idRAMCode+1)*32-1:(`idRAMCode)*32]),  
    .HRESP(HRESP_A[`idRAMCode])
);

AHBLiteBlockRAM uRAMData
(
    .HCLK(HCLK),    
    .HRESETn(HRESETn), 
    .HSEL(HSEL_A[`idRamData]),    
    .HADDR(HADDR),   
    .HTRANS(HTRANS),  
    .HSIZE(HSIZE),   
    .HPROT(HPROT),   
    .HWRITE(HWRITE),  
    .HWDATA(HWDATA),   
    .HREADY(HREADY), 
    .HREADYOUT(HREADYOUT_A[`idRamData]), 
    .HRDATA(HRDATA_A[(`idRamData+1)*32-1:(`idRamData)*32]),  
    .HRESP(HRESP_A[`idRamData])
);
    
endmodule