module APB_Keyboard(input wire clk,rst_n,
                    input wire[3:0] col_in,
                    output wire[3:0] row,
                    output wire[31:0] PRDATA,
                    output wire KeyboardINT);
    wire[15:0] keyn;
    wire[15:0] key;
    wire[3:0] col_out;
    wire[1:0] hi;
    wire row_rdy;
    reg[15:0] KeyINT;

    KeyToCol KeyToCol(
        .clk      (clk),
        .rst_n    (rst_n),
        .col_in   (col_in),
        .row      (row),
        .col_out  (col_out),
        .hi       (hi),
        .row_rdy  (row_rdy),
        .row_old  (keyn)
    );

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            KeyINT <= 16'b0;
        end
        else if(KeyboardINT)begin
            case(hi)
                2'b00: KeyINT  [3:0] <= col_out;
                2'b01: KeyINT  [7:4] <= col_out;
                2'b10: KeyINT [11:8] <= col_out;
                2'b11: KeyINT[15:12] <= col_out;
            endcase
        end
    end

    assign KeyboardINT = row_rdy&(|(~col_out));
    assign PRDATA = {KeyINT,key};
    assign key = ~keyn;

endmodule