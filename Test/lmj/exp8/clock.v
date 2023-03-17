module clock_division(clk_in,divclk);
    input clk_in;
    output divclk;
    parameter DIVCLK_CNTMAX = 24999; //时钟分频计数的最大值
    reg [31:0] cnt = 0;              
    reg divclk_reg = 0;
    always@(posedge clk_in) begin
        if(cnt == DIVCLK_CNTMAX) begin
            cnt <= 0;
            divclk_reg <= ~divclk_reg;
        end
        else
            cnt <= cnt + 1;
    end 
    assign divclk = divclk_reg;
endmodule