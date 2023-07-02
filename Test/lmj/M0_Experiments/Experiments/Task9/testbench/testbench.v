`timescale 1ps/1ps

module testbench();

    reg clk,RSTn;
    reg[3:0] col;
    wire[3:0] row;

    BuzzerNLCDSoC core(
        .clk(clk),
        .RSTn(RSTn),
        .SWCLK(1'b0),
        .col(col),
        .row(row)
    );

    always  #5 clk = ~clk;

    initial begin
        clk = 0;
        RSTn = 0;
        #10;
        RSTn = 1;
    end

    always @(row) begin
        case(row)
            4'b1110:begin
                col = 4'b0111;
            end
            default:begin
                col = 4'b1111;
            end
        endcase
    end
endmodule