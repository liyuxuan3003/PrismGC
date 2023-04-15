`timescale 1 ns / 1 ns
module LCD_ControlTest
(
    input                clk,            //global clock    
    input                rst_n,          //global reset    

    output reg [15:0]    x_pos,
    output reg [15:0]    y_pos,
    output reg [23:0]    pixel,
    output reg [23:0]    len,
    output reg           enable, 

    output reg [8:0]     wr_len,

    input                busy
);

reg[25:0] cnt_time;
reg[31:0] cnt_pat;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        x_pos <= 100;
        y_pos <= 0;
        pixel <= 0;
        len <= 0;
        enable <= 1'b0;
        cnt_time <= 0;
        cnt_pat <= 0;
    end
    else
    begin
        cnt_time <= cnt_time + 1;
        //if (busy==0 & cnt_time > 26'hFF)
        //    cnt_time <= 26'h3FFFFFF;
        if(cnt_time == 0)
        begin
            if (cnt_pat < 31'h1FF)
            begin
                cnt_pat <= cnt_pat + 1;
                if(cnt_pat == 0)
                begin
                    x_pos <= 0;
                    y_pos <= 0;
                    len <= `H_DISP * (`V_DISP + 1);
                    pixel <= `BLUE;
                    enable <= 1;
                    wr_len <= 9'd256;
                end
                else
                begin 
                    x_pos <= 20;
                    y_pos <= 20+cnt_pat;
                    pixel <= `RED;
                    len   <= 1000;
                    enable <= 1;
                    wr_len <= 9'd1;
                end
            end
        end
        if(cnt_time == 26'h3FFFFFF)
        begin
            enable <= 1'b0;
        end
    end
end

endmodule
