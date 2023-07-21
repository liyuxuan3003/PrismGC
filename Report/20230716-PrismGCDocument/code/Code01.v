wire[2**`DEVICES_EXP-1:0]    HSEL_A;
wire[2**`DEVICES_EXP-1:0]    HREADYOUT_A;
wire[2**`DEVICES_EXP-1:0]    HRESP_A;
wire[2**`DEVICES_EXP*32-1:0] HRDATA_A;

// Decoder
AHBLiteDecoder uDecoder
(
    .HADDR(HADDR),
    .HSEL_A(HSEL_A)
);

// Slave MUX
AHBLiteSlaveMux uSlaveMUX
(
    // CLOCK & RST
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