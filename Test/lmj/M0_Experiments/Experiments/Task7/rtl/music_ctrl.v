module music_ctrl(
input clk,en,rstn,addr_finish,beat_finish,
output reg addr_en,
output reg addr_rstn,
output reg tune_pwm_en,
output reg tune_pwm_rstn,
output reg beat_cnt_en,
output reg beat_cnt_rstn);

parameter IDLE = 2'b00;
parameter ADD = 2'b01;
parameter WORK = 2'b10;

reg [3:0] state=2'b01;
reg [3:0] state_nxt=2'b01;



always@(en or beat_finish or addr_finish or state)
begin
case(state)
IDLE :begin
        if(en)
        state_nxt<=ADD;
        else 
        state_nxt<=IDLE;
        end
ADD:begin
        if(addr_finish)
        state_nxt<=IDLE;
        else
        state_nxt<=WORK;
        end
WORK:     begin
        if(beat_finish)
        state_nxt<=ADD;
        else
        state_nxt<=WORK;
        end
 default:state_nxt<=IDLE;
 endcase
 end

 always@(posedge clk or negedge rstn)
 begin
 if(!rstn)
 state<=IDLE;
 else
 state<=state_nxt;
 end
 
 always@(posedge clk)
 case(state_nxt)
 IDLE:
         begin
         addr_en<=1'b0;
         addr_rstn<=1'b0;
         tune_pwm_en<=1'b0;
         tune_pwm_rstn<=1'b0;
         beat_cnt_en<=1'b0;
         beat_cnt_rstn<=1'b0;
         end
ADD:     begin
         addr_en<=1'b1;
         addr_rstn<=1'b1;
         tune_pwm_en<=1'b0;
         tune_pwm_rstn<=1'b0;
         beat_cnt_en<=1'b0;
         beat_cnt_rstn<=1'b0;
         end
WORK:     begin
         addr_en<=1'b0;
         addr_rstn<=1'b1;
         tune_pwm_en<=1'b1;
         tune_pwm_rstn<=1'b1;
         beat_cnt_en<=1'b1;
         beat_cnt_rstn<=1'b1;
         end
default:begin
         addr_en<=1'b0;
         addr_rstn<=1'b0;
         tune_pwm_en<=1'b0;
         tune_pwm_rstn<=1'b0;
         beat_cnt_en<=1'b0;
         beat_cnt_rstn<=1'b0;
         end
         endcase
         endmodule
