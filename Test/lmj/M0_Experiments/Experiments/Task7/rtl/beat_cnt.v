module beat_cnt(
input clk,rstn,
input en,
input [27:0] beat_cnt_parameter,
output beat_finish);
reg [27:0] cnt;
//wire [27:0] cnt_nxt=(cnt==beat_cnt_parameter)? cnt:cnt+1'b1;
always@(posedge clk or negedge rstn)
begin
if(!rstn)
cnt<=0;
else if(en)
begin
    if(beat_finish)
    cnt<=0;
    else
    cnt<=cnt+1'b1;
end

end

assign beat_finish=(cnt==beat_cnt_parameter)? 1'b1:1'b0;
endmodule



