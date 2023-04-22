module smg_dem(
					input clk,
					input rst_n,
					input [23:0] idata,
					output [5:0] SEL,
					output [7:0] DIG
				);
	wire [9:0]odataU1;
	function_module		U1(
						.clk(clk),
						.rst_n(rst_n),
						.idata(idata),
						.odata(odataU1)
						);
						
	assign SEL = odataU1[5:0];
	
	encod_module	U2(
						.iData(odataU1[9:6]),
						.oData(DIG)
					   );
endmodule
