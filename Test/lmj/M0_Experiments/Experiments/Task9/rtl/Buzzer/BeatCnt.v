module BeatCnt(input wire clk,rst_n,en,
               input wire[27:0] BeatCntParameter,
               output wire BeatFinish);

    reg[27:0] cnt;

    always @(posedge clk) begin
        if(!rst_n)begin
            cnt <= 28'b0;
        end
        else if(en)begin
            cnt <= cnt+1'b1;
        end
    end

    assign BeatFinish = (cnt == BeatCntParameter);

endmodule