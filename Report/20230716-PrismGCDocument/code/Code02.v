// Buzzer
AHBLiteBuzzer uAHBBuzzer
(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(HSEL_A[`idBuzzer]),
    .HADDR(HADDR),
    .HPROT(HPROT),
    .HSIZE(HSIZE),
    .HTRANS(HTRANS),
    .HWDATA(HWDATA),
    .HWRITE(HWRITE),
    .HRDATA(HRDATA_A[`idBuzzer*32+:32]),
    .HREADY(HREADY),
    .HREADYOUT(HREADYOUT_A[`idBuzzer]),
    .HRESP(HRESP_A[`idBuzzer]),
    .BUZ(BUZ)
);