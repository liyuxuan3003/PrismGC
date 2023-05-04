module IIC_demo(
					input clk,
					input rst_n,
					output SDA,
					output SCL,
					output [7:0] DIG,
					output [5:0] SEL
				);
	
	smg_dem		U1(
					.clk(clk),
					.rst_n(rst_n),
					.idata(),
					.SEL(SEL),
					.DIG(DIG)
				  );
	wire Done;
	wire [7:0]dataU1;
	IIC_module	U2(
						.clk(clk),
						.rst_n(rst_n),
						.SCL(SCL),
						.SDA(SDA),
						.iCall(isCall),
						.idata(D2),
						.iAddr(D1),
						.odata(dataU1),
						.oDone(Done)
					);
reg [3:0] i;
reg [7:0] D1,D2;
reg [1:0]isCall;
reg [23:0] D3;

always @ ( posedge clk , negedge rst_n)
	if(!rst_n)
		begin
			i <= 4'd0;
			D1 <= 8'd0;
			D1 <= 8'd0;
			D3 <= 24'd0;
			isCall <= 2'b00;
		end
	else
		case(i)
			0:
				if(Done)
					begin
						isCall[1] <= 1'b0;
						i <= i +1'b1;
					end
				else
					begin
						isCall[1] <= 1'b1;
						D1 <= 8'd0;
						D2 <= 8'hAB;
					end
			1:
				if(Done)
					begin
						isCall[1] <= 1'b0;
						i <= i +1'b1;
					end
				else
					begin
						isCall[1] <= 1'b1;
						D1 <= 8'd1;
						D2 <= 8'hCD;
					end
			2:
				if(Done)
					begin
						isCall[1] <= 1'b0;
						i <= i +1'b1;
					end
				else
					begin
						isCall[1] <= 1'b1;
						D1 <= 8'd2;
						D2 <= 8'hEF;
					end
			3:
				if(Done)
					begin
						D3[23:16] <= dataU1;
						isCall[0] <= 1'b0;
						i <= i +1'b1;
					end
				else 
					begin
						isCall[0] <= 1'b1;
						D1 <= 8'd0;
					end
			4:
				if(Done)
					begin
						D3[15:8] <= dataU1;
						isCall[0] <= 1'b0;
						i <= i +1'b1;
					end
				else 
					begin
						isCall[0] <= 1'b1;
						D1 <= 8'd1;
					end
			5:
				if(Done)
					begin
						D3[7:8] <= dataU1;
						isCall[0] <= 1'b0;
						i <= i +1'b1;
					end
				else 
					begin
						isCall[0] <= 1'b1;
						D1 <= 8'd2;
					end
			6:
				i <= i;
		endcase
endmodule
	
	