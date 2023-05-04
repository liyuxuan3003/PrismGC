module top
(
	input CLK,
    input[7:0] SWI,
    output BUZ
);

Buzzer uBuzzer
(
    .clk(CLK),
    .BUZ(BUZ),
    .note(SWI)
);

endmodule