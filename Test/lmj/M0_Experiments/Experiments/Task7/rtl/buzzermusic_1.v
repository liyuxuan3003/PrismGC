module buzzermusic(
    input           clk,rstn,
    input        [1:0]music_select,
    input         music_start,
    output          beep
);
wire en;
assign en = music_start;

wire addr_finish;
wire beat_finish;
wire addr_en;
wire addr_rstn;
wire tune_pwm_en;
wire tune_pwm_rstn;
wire beat_cnt_en;
wire beat_cnt_rstn;
music_ctrl music_ctrl(
    .clk             (clk)
    ,.en             (en)
    ,.rstn           (rstn)
    ,.addr_finish    (addr_finish)
    ,.beat_finish    (beat_finish)
    ,.addr_en        (addr_en)
    ,.addr_rstn      (addr_rstn)
    ,.tune_pwm_en    (tune_pwm_en)
    ,.tune_pwm_rstn  (tune_pwm_rstn)
    ,.beat_cnt_en    (beat_cnt_en)
    ,.beat_cnt_rstn  (beat_cnt_rstn) 
);

reg [11:0] data;
wire [8:0] addr;
addr_cnt addr_cnt(
     .clk          (clk)
    ,.en          (addr_en)
    ,.rstn         (addr_rstn)
    ,.data        (data)
    ,.addr         (addr)
    ,.addr_finish  (addr_finish)
);

wire [11:0] data1;
BlockROM1 #(
     .ADDR_WIDTH(8)
    ,.DATA_WIDTH(12)
) BlockROM1 (
     .en(1'b1)
    ,.clk(clk)
    ,.addr_i(addr)
    ,.data_o(data1)
);

wire [11:0] data2;
BlockROM2 #(
     .ADDR_WIDTH(8)
    ,.DATA_WIDTH(12)
) BlockROM2 (
     .en(1'b1)
    ,.clk(clk)
    ,.addr_i(addr)
    ,.data_o(data2)
);

wire [11:0] data3;
BlockROM3 #(
     .ADDR_WIDTH(8)
    ,.DATA_WIDTH(12)
) BlockROM3 (
     .en(1'b1)
    ,.clk(clk)
    ,.addr_i(addr)
    ,.data_o(data3)
);


reg [1:0]music_select_reg;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        music_select_reg <= 2'b00;
    end 
    else begin
        if (en) 
            music_select_reg <= music_select;
         else 
            music_select_reg <= music_select_reg;
    end
end


always @(music_select_reg)
begin
case (music_select_reg)
    2'b00:data<=data1;
    2'b01:data<=data2;
    2'b10:data<=data3;
    default: data<=data3;
endcase
end

wire [19:0] tune_pwm_parameter;
tune_decoder tune_decoder(
     .tune                (data[11:4])
    ,.tune_pwm_parameter  (tune_pwm_parameter)
);

tune_pwm tune_pwm(     
     .clk            (clk)
    ,.en             (tune_pwm_en)
    ,.rst_n          (tune_pwm_rstn)
    ,.pwm_parameter  (tune_pwm_parameter)
    ,.clk_pwm        (beep)
);


wire  [27:0]  beat_cnt_parameter;
beat_decoder beat_decoder(
     .beat                (data[3:0])
    ,.beat_cnt_parameter  (beat_cnt_parameter)
);

beat_cnt beat_cnt(
     .clk                 (clk)
    ,.en                  (beat_cnt_en)
    ,.rstn                (beat_cnt_rstn)
    ,.beat_cnt_parameter  (beat_cnt_parameter)
    ,.beat_finish         (beat_finish)   
);

endmodule