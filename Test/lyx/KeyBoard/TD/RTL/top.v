module top
(
	input CLK,
    input[7:0] SWI,
    output[7:0] LED,
    input[3:0] COL,
    output[3:0] ROW
);

KeyBoard uKeyBoard
(
    .clk(CLK),
    .SWI(SWI),
    .LED(LED),
    .COL(COL),
    .ROW(ROW)
);

endmodule