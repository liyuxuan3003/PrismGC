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

    input                busy
);

reg[23:0] cnt_time;
reg[4:0]  cnt_pat;

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
        if(cnt_time == 0)
        begin
            if (cnt_pat < 5'h1F)
            begin
                cnt_pat <= cnt_pat + 1;
                if(cnt_pat == 0)
                begin
                    x_pos <= 0;
                    y_pos <= 0;
                    len <= `H_DISP * (`V_DISP + 1);
                    pixel <= `BLACK;
                    enable <= 1;
                end
                else
                begin 
                    x_pos <= 256;
                    y_pos <= 400+cnt_pat;
                    pixel <= `RED;
                    len   <= 513;
                    enable <= 1;
                end
            end
        end
        if(cnt_time == 24'hFFFFFE)
        begin
            enable <= 1'b0;
        end
    end
end

endmodule
