module decoder(
  input [1:0] sw,
  output reg [4:0] start_addr,
  output reg [4:0] end_addr
);

always @ (*) begin
  if (sw == 2'b00) begin
    start_addr = 5'd0;
    end_addr   = 5'd4;
  end
  else if (sw == 2'b01) begin
    start_addr = 5'd5; 
    end_addr   = 5'd9;
  end
  else if (sw == 2'b10) begin
    start_addr = 5'd10; 
    end_addr   = 5'd17;
  end
  else begin
    start_addr = 5'd18;
    end_addr   = 5'd25;
  end
end

endmodule