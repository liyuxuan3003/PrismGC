module main(SW,LED,SEG,SEGCS);
    input[7:0]  SW;
    output[7:0] LED;
    output[7:0] SEG;
    output[3:0] SEGCS;

    digit(
        .digit(SW[3:0]),
        .digit_led(LED[3:0]),
        .dot(SW[4]),
        .dot_led(LED[4]),
        .code(SW[7:6]),
        .code_led(LED[7:6]),
        .seg(SEG),
        .segcs(SEGCS)
    );

    assign LED[5]=2'b00;
endmodule
