module Buzzer
(
	input clk,
	output BUZ,
    input[3:0] note
);

`define Do 262
`define Re 294
`define Mi 330
`define Fa 349
`define So 392
`define La 440
`define Si 494

`define CLK_FRE 50000000
`define NUM(X) (`CLK_FRE/X)/2 

wire [31:0] clkNum =
    (note == 0) ? 0 :
    (note == 1) ? `NUM(`Do) :
    (note == 2) ? `NUM(`Re) :
    (note == 3) ? `NUM(`Mi) :
    (note == 4) ? `NUM(`Fa) :
    (note == 5) ? `NUM(`So) :
    (note == 6) ? `NUM(`La) :
    (note == 7) ? `NUM(`Si) : 0;

reg [31:0] counter;
always @(posedge clk) if(counter>=clkNum) counter<=0; else counter <= counter+1;

reg speaker;
always @(posedge clk) if(counter>=clkNum) speaker <= ~speaker;

assign BUZ = speaker;

endmodule
