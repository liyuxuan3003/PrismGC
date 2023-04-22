module AHBlite_SlaveMUX 
(
    input HCLK,
    input HRESETn,
    input HREADY,

    //port 0
    input P0_HSEL,
    input P0_HREADYOUT,
    input P0_HRESP,
    input [31:0] P0_HRDATA,

    //port 1
    input P1_HSEL,
    input P1_HREADYOUT,
    input P1_HRESP,
    input [31:0] P1_HRDATA,

    //port 2
    input P2_HSEL,
    input P2_HREADYOUT,
    input P2_HRESP,
    input [31:0] P2_HRDATA,

    //port 3
    input P3_HSEL,
    input P3_HREADYOUT,
    input P3_HRESP,
    input [31:0] P3_HRDATA,

    //port 4
    input P4_HSEL,
    input P4_HREADYOUT,
    input P4_HRESP,
    input [31:0] P4_HRDATA,

    //port 5
    input P5_HSEL,
    input P5_HREADYOUT,
    input P5_HRESP,
    input [31:0] P5_HRDATA,

    //port 6
    input P6_HSEL,
    input P6_HREADYOUT,
    input P6_HRESP,
    input [31:0] P6_HRDATA,

    //port 7
    input P7_HSEL,
    input P7_HREADYOUT,
    input P7_HRESP,
    input [31:0] P7_HRDATA,

    //output
    output wire HREADYOUT,
    output wire HRESP,
    output wire [31:0] HRDATA
);

//reg the hsel
reg [7:0] hsel_reg;

always@(posedge HCLK or negedge HRESETn) 
begin
    if(~HRESETn) hsel_reg <= 8'b0000_0000;
    else if(HREADY) hsel_reg <= 
    {P0_HSEL,P1_HSEL,P2_HSEL,P3_HSEL,P4_HSEL,P5_HSEL,P6_HSEL,P7_HSEL};
end

//hready mux

//wire hready_mux;
Mux16_1 muxHREADYOUT
(
    .sel({hsel_reg,8'h0}),
    .sigIn({P0_HREADYOUT,P1_HREADYOUT,P2_HREADYOUT,P3_HREADYOUT,P4_HREADYOUT,P5_HREADYOUT,P6_HREADYOUT,P7_HREADYOUT,8'h0}),
    .sigOut(HREADYOUT),
    .sigOutDefault(1)
);
Mux16_1 muxHRESP
(
    .sel({hsel_reg,8'h0}),
    .sigIn({P0_HRESP,P1_HRESP,P2_HRESP,P3_HRESP,P4_HRESP,P5_HRESP,P6_HRESP,P7_HRESP,8'h0}),
    .sigOut(HRESP),
    .sigOutDefault(0)
);
//assign HREADYOUT = hready_mux;

wire[15:0] hselReg={hsel_reg,8'h0};
wire[511:0] HRDATA_A={P0_HRDATA,P1_HRDATA,P2_HRDATA,P3_HRDATA,P4_HRDATA,P5_HRDATA,P6_HRDATA,P7_HRDATA,256'h0};
//Mux HRDATA
Mux16_1 #(.WIDTH(32)) muxHRDATA
(
    .sel(hselReg),
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