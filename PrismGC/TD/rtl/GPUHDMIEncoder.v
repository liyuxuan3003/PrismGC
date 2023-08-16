/*
 * Copyright (c) 2023 by Liyuxuan, all rights reserved.
 */
 
`include "GlobalDefine.v"

////////////////////////////////////////////////////////////////////////
module GPUHDMIEncoder
(
	input           clk,
    input           clk_TMDS,
    input           rstn,
	output          HDMI_D0_P,
    output          HDMI_D1_P,
    output          HDMI_D2_P,
	output          HDMI_CLK_P,
    output          Request,
    output          PingPongSync,
    input[23:0]     RGB
);

reg [15:0] CounterX;
reg [15:0] CounterY;
reg DrawArea;

////////////////////////////////////////////////////////////////////////
reg hSync, vSync;

localparam	H_AHEAD = 	12'd1;

// assign Request = 
// (CounterX >= `H_TOTAL - `H_DISP && CounterX < `H_TOTAL) && 
// (CounterY >= `V_TOTAL - `V_DISP && CounterY < `V_TOTAL);

assign	Request	= 	
(CounterX >= `H_SYNC + `H_BACK - H_AHEAD && CounterX < `H_SYNC + `H_BACK + `H_DISP - H_AHEAD) &&
(CounterY >= `V_SYNC + `V_BACK && CounterY < `V_SYNC + `V_BACK + `V_DISP) ? 1'b1 : 1'b0;

assign PingPongSync = 
    (CounterX == `H_SYNC + `H_BACK + `H_DISP) && 
    (CounterY == `V_SYNC + `V_BACK + `V_DISP);

always @(posedge clk) 
begin
    DrawArea <= 
    (CounterX >= `H_SYNC + `H_BACK && CounterX < `H_SYNC + `H_BACK + `H_DISP) &&
    (CounterY >= `V_SYNC + `V_BACK && CounterY < `V_SYNC + `V_BACK + `V_DISP);
end


always @(posedge clk or negedge rstn) 
begin
    if(!rstn)
        CounterX <= 0;
    else
        CounterX <= (CounterX==`H_TOTAL-1) ? 0 : CounterX+1;
end

always @(posedge clk or negedge rstn) 
begin
    if(!rstn)
        CounterY <= 0;
    else
        if(CounterX==`H_TOTAL-1) CounterY <= (CounterY==`V_TOTAL-1) ? 0 : CounterY+1;
end

always @(posedge clk) hSync <= (CounterX < `H_SYNC);
always @(posedge clk) vSync <= (CounterY < `V_SYNC);

////////////////
wire [7:0] W = {8{CounterX[7:0]==CounterY[7:0]}};
wire [7:0] A = {8{CounterX[7:5]==3'h2 && CounterY[7:5]==3'h2}};
reg [7:0] red, green, blue;
always @(posedge clk) red <=    RGB[23:16];
always @(posedge clk) green <=  RGB[15:8];
always @(posedge clk) blue <=   RGB[7:0];

////////////////////////////////////////////////////////////////////////
wire [9:0] TMDS_red, TMDS_green, TMDS_blue;
TMDS_encoder encode_R(.clk(clk), .VD(red  ), .CD(2'b00)        , .VDE(DrawArea), .TMDS(TMDS_red));
TMDS_encoder encode_G(.clk(clk), .VD(green), .CD(2'b00)        , .VDE(DrawArea), .TMDS(TMDS_green));
TMDS_encoder encode_B(.clk(clk), .VD(blue ), .CD({vSync,hSync}), .VDE(DrawArea), .TMDS(TMDS_blue));

////////////////////////////////////////////////////////////////////////
reg [3:0] TMDS_mod10=0;  // modulus 10 counter
reg [9:0] TMDS_shift_red=0, TMDS_shift_green=0, TMDS_shift_blue=0;
reg TMDS_shift_load=0;
always @(posedge clk_TMDS) TMDS_shift_load <= (TMDS_mod10==4'd4);

always @(posedge clk_TMDS)
begin
	TMDS_shift_red   <= TMDS_shift_load ? TMDS_red   : TMDS_shift_red  [9:2];
	TMDS_shift_green <= TMDS_shift_load ? TMDS_green : TMDS_shift_green[9:2];
	TMDS_shift_blue  <= TMDS_shift_load ? TMDS_blue  : TMDS_shift_blue [9:2];	
	TMDS_mod10 <= (TMDS_mod10==4'd4) ? 4'd0 : TMDS_mod10+4'd1;
end

// assign HDMI_D2_P = TMDS_shift_red[0];
// assign HDMI_D1_P = TMDS_shift_green[0];
// assign HDMI_D0_P = TMDS_shift_blue[0];
assign HDMI_CLK_P = clk;

EG_LOGIC_ODDR#(.ASYNCRST("ENABLE")) uODDR2
(
    .clk(clk_TMDS),
    .rst(~rstn),
    .q(HDMI_D2_P),
    .d0(TMDS_shift_red[0]),
    .d1(TMDS_shift_red[1])
);

EG_LOGIC_ODDR#(.ASYNCRST("ENABLE")) uODDR1
(
    .clk(clk_TMDS),
    .rst(~rstn),
    .q(HDMI_D1_P),
    .d0(TMDS_shift_green[0]),
    .d1(TMDS_shift_green[1])
);

EG_LOGIC_ODDR#(.ASYNCRST("ENABLE")) uODDR0
(
    .clk(clk_TMDS),
    .rst(~rstn),
    .q(HDMI_D0_P),
    .d0(TMDS_shift_blue[0]),
    .d1(TMDS_shift_blue[1])
);

endmodule


////////////////////////////////////////////////////////////////////////
module TMDS_encoder
(
	input clk,
	input [7:0] VD,     // video data (red, green or blue)
	input [1:0] CD,     // control data
	input VDE,          // video data enable, to choose between CD (when VDE=0) and VD (when VDE=1)
	output reg [9:0] TMDS = 0
);

wire [3:0] Nb1s = VD[0] + VD[1] + VD[2] + VD[3] + VD[4] + VD[5] + VD[6] + VD[7];
wire XNOR = (Nb1s>4'd4) || (Nb1s==4'd4 && VD[0]==1'b0);
wire [8:0] q_m = {~XNOR, q_m[6:0] ^ VD[7:1] ^ {7{XNOR}}, VD[0]};

reg [3:0] balance_acc = 0;
wire [3:0] balance = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7] - 4'd4;
wire balance_sign_eq = (balance[3] == balance_acc[3]);
wire invert_q_m = (balance==0 || balance_acc==0) ? ~q_m[8] : balance_sign_eq;
wire [3:0] balance_acc_inc = balance - ({q_m[8] ^ ~balance_sign_eq} & ~(balance==0 || balance_acc==0));
wire [3:0] balance_acc_new = invert_q_m ? balance_acc-balance_acc_inc : balance_acc+balance_acc_inc;
wire [9:0] TMDS_data = {invert_q_m, q_m[8], q_m[7:0] ^ {8{invert_q_m}}};
wire [9:0] TMDS_code = CD[1] ? (CD[0] ? 10'b1010101011 : 10'b0101010100) : (CD[0] ? 10'b0010101011 : 10'b1101010100);

always @(posedge clk) TMDS <= VDE ? TMDS_data : TMDS_code;
always @(posedge clk) balance_acc <= VDE ? balance_acc_new : 4'h0;
endmodule


////////////////////////////////////////////////////////////////////////

// DISP FRON SYNC BACK
// SYNC BACK DISP FRON
