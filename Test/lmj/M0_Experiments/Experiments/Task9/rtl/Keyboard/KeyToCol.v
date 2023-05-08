module KeyToCol(input wire clk,rst_n,
                input wire[3:0] col_in,
                output reg[3:0] row,col_out,
                output reg[1:0] hi,
                output wire row_rdy,
                output reg[15:0] row_old);

    reg[19:0] cnt;
    reg[3:0] col1,col2;
    reg[1:0] rowcnt;
    reg rowcnt1;
    reg sa_clk;
    wire[1:0] comb_hi;
    wire[3:0] col;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            cnt <= 20'd0;
            rowcnt1 <= 1'b1;
            sa_clk <= 1'b0;
        end
        else begin
            rowcnt1 <= rowcnt[1];
            if(cnt >= 20'd124_999)begin
            cnt <= 20'd0;
            sa_clk <= ~sa_clk;
            end
            else begin
            cnt <= cnt+1'b1;
            end
        end
    end

    always @(posedge sa_clk or negedge rst_n)begin
        if(!rst_n)begin
            col1 <= 4'b1111;
            col2 <= 4'b1111;
            rowcnt <=2'b10;
        end
        else begin
            rowcnt <= rowcnt+1'b1;
            col1 <= col2;
            col2 <= col_in;
        end
    end

    always @(posedge rowcnt[1] or negedge rst_n)begin
        if(!rst_n)begin
            row <= 4'b1110;
            col_out <= 4'b1111;
            hi <= 2'b00;
            row_old <= 16'hffff;
        end
        else begin
            row <= {row[2:0],row[3]};
            hi <= comb_hi;
            case(comb_hi)
                2'b00:begin
                    col_out <= ~((~col)&row_old[3:0]);
                    row_old[3:0] <= col;
                end
                2'b01:begin
                    col_out <= ~((~col)&row_old[7:4]);
                    row_old[7:4] <= col;
                end
                2'b10:begin
                    col_out <= ~((~col)&row_old[11:8]);
                    row_old[11:8] <= col;
                end
                2'b11:begin
                    col_out <= ~((~col)&row_old[15:12]);
                    row_old[15:12] <= col;
                end
            endcase
        end
    end

    assign row_rdy = rowcnt[1]&(~rowcnt1);
    assign comb_hi = {~(row[3]&row[2]),~(row[3]&row[1])};
    assign col = col1|col2;

endmodule