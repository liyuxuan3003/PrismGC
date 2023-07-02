module TunePWM(input wire clk,rst_n,en,
               input wire[19:0] PWMParameter,
               input wire[1:0] loudness,
               output reg PWM);
    
    reg[19:0] cnt,PWMDuty;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            cnt <= 20'd0;
            PWM <= 1'b1;
        end
        else begin
            if (en) begin
                if (cnt == PWMParameter) begin
                    cnt <= 20'd0;
                    PWM <= 1'b1;
                end else begin
                    if (cnt == PWMDuty) begin
                        PWM <= ~PWM;
                    end else begin
                        PWM <= PWM;
                    end
                    cnt <= cnt + 1'b1;
                end           
            end else begin
                cnt <= cnt;
                PWM <= PWM;
            end
        end
    end

    always @(loudness,PWMParameter) begin
        case(loudness)
            2'b00: PWMDuty = PWMParameter >> 3;
            2'b01: PWMDuty = PWMParameter >> 2;
            2'b10: PWMDuty = PWMParameter >> 2 + PWMParameter >> 3;
            2'b11: PWMDuty = PWMParameter >> 1;
            default: PWMDuty = PWMParameter >> 1;
        endcase
    end

endmodule