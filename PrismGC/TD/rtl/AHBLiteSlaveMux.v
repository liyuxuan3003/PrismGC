/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */

module AHBLiteSlaveMux #(parameter DEVICES_EXP=4)
(
    input HCLK,
    input HRESETn,
    input HREADY,

    input[2**DEVICES_EXP-1:0] HSEL_A,
    input[2**DEVICES_EXP-1:0] HREADYOUT_A,
    input[2**DEVICES_EXP-1:0] HRESP_A,
    input[2**DEVICES_EXP*32-1:0] HRDATA_A,

    output wire HREADYOUT,
    output wire HRESP,
    output wire [31:0] HRDATA
);

//Reg HSEL_ENCODE
reg [2**DEVICES_EXP-1:0] hselReg;

always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) 
        hselReg <= 0;
    else if(HREADY) 
        hselReg <= HSEL_A;
end

// Mux HREADYOUT
Mux16_1 muxHREADYOUT
(
    .sel(hselReg),
    .sigIn(HREADYOUT_A),
    .sigOut(HREADYOUT),
    .sigOutDefault(1'b1)
);

//Mux HRESP
Mux16_1 muxHRESP
(
    .sel(hselReg),
    .sigIn(HRESP_A),
    .sigOut(HRESP),
    .sigOutDefault(1'b0)
);

//Mux HRDATA
Mux16_1 #(.WIDTH(32)) muxHRDATA
(
    .sel(hselReg),
    .sigIn(HRDATA_A),
    .sigOut(HRDATA),
    .sigOutDefault(32'b0)
);

endmodule 