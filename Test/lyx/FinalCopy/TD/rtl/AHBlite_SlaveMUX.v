module AHBlite_SlaveMUX 
(
    input HCLK,
    input HRESETn,
    input HREADY,

    input[15:0] HSEL_A,
    input[15:0] HREADYOUT_A,
    input[15:0] HRESP_A,
    input[511:0] HRDATA_A,

    //output
    output wire HREADYOUT,
    output wire HRESP,
    output wire [31:0] HRDATA
);

//reg the hsel
reg [15:0] hsel_reg;

always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) hsel_reg <= 0;
    else if(HREADY) hsel_reg <= HSEL_A;
end

//hready mux

//wire hready_mux;
Mux16_1 muxHREADYOUT
(
    .sel(hsel_reg),
    .sigIn(HREADYOUT_A),
    .sigOut(HREADYOUT),
    .sigOutDefault(1)
);
Mux16_1 muxHRESP
(
    .sel(hsel_reg),
    .sigIn(HRESP_A),
    .sigOut(HRESP),
    .sigOutDefault(0)
);
//assign HREADYOUT = hready_mux;


Mux16_1 #(.WIDTH(32)) muxHRDATA
(
    .sel(hsel_reg),
    .sigIn(HRDATA_A),
    .sigOut(HRDATA),
    .sigOutDefault(0)
);

//hresp mux
// reg hresp_mux;

// always@(*) 
// begin
//     case(hsel_reg)
//         8'b0000_0001 : begin hresp_mux = P7_HRESP;end
//         8'b0000_0010 : begin hresp_mux = P6_HRESP;end
//         8'b0000_0100 : begin hresp_mux = P5_HRESP;end
//         8'b0000_1000 : begin hresp_mux = P4_HRESP;end
//         8'b0001_0000 : begin hresp_mux = P3_HRESP;end
//         8'b0010_0000 : begin hresp_mux = P2_HRESP;end
//         8'b0100_0000 : begin hresp_mux = P1_HRESP;end
//         8'b1000_0000 : begin hresp_mux = P0_HRESP;end
//         default : begin hresp_mux = 1'b0;end
//     endcase
// end

// assign HRESP = hresp_mux;

//hrdata mux
// reg [31:0] hrdata_mux;

// always@(*) 
// begin
//     case(hsel_reg)
//         8'b0000_0001 : begin hrdata_mux = P7_HRDATA;end
//         8'b0000_0010 : begin hrdata_mux = P6_HRDATA;end
//         8'b0000_0100 : begin hrdata_mux = P5_HRDATA;end
//         8'b0000_1000 : begin hrdata_mux = P4_HRDATA;end
//         8'b0001_0000 : begin hrdata_mux = P3_HRDATA;end
//         8'b0010_0000 : begin hrdata_mux = P2_HRDATA;end
//         8'b0100_0000 : begin hrdata_mux = P1_HRDATA;end
//         8'b1000_0000 : begin hrdata_mux = P0_HRDATA;end
//         default : begin hrdata_mux = 32'b0;end
//     endcase
// end

// assign HRDATA = hrdata_mux;

endmodule 