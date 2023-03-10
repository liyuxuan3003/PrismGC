module digit(digit,digit_led,dot,dot_led,code,code_led,seg,segcs);
    input[3:0]  digit;
    output[3:0] digit_led;
    input       dot;
    output      dot_led;
    input[1:0]  code;
    output[1:0] code_led;
    output[7:0] seg;
    output[3:0] segcs;

    driver_seg(
        .digit(digit),
        .dot(dot),
        .seg(seg));

    driver_segcs(
        .code(code),
        .segcs(segcs));

    assign digit_led=digit;
    assign dot_led=dot;
    assign code_led=code;
endmodule