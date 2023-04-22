module AHBLiteSlaveMux #(parameter DEVICES_EXP=4)
(
    input HCLK,
    input HRESETn,
    input HREADY,

    input[DEVICES_EXP-1:0] HSEL_ENCODE,
    input[2**DEVICES_EXP-1:0] HREADYOUT_A,
    input[2**DEVICES_EXP-1:0] HRESP_A,
    input[2**DEVICES_EXP*32-1:0] HRDATA_A,

    output wire HREADYOUT,
    output wire HRESP,
    output wire [31:0] HRDATA
);

//Reg HSEL_ENCODE
reg [DEVICES_EXP-1:0] hselEncodeReg;

always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) 
        hselEncodeReg <= 2**DEVICES_EXP-1;
    else if(HREADY) 
        hselEncodeReg <= HSEL_ENCODE;
end

// Mux HREADYOUT
Mux16_1 muxHREADYOUT
(
    .sel(hselEncodeReg),
    .sigIn(HREADYOUT_A),
    .sigOut(HREADYOUT)
);

//Mux HRESP
Mux16_1 muxHRESP
(
    .sel(hselEncodeReg),
    .sigIn(HRESP_A),
    .sigOut(HRESP)
);

//Mux HRDATA
Mux16_1 #(.WIDTH(32)) muxHRDATA
(
    .sel(hselEncodeReg),
    .sigIn(HRDATA_A),
    .sigOut(HRDATA)
);

endmodule 