module SPI_wrapper(clk_w,reset_w,MOSI_w,SS_n_w, MISO_w);
 input clk_w,reset_w,MOSI_w,SS_n_w;
 output MISO_w;
 
 wire [9:0]rx_data;
 wire [7:0]tx_data;
 wire rx_valid,tx_valid;
 
 
 SPI_SLAVE spi_inst(.clk(clk_w),
                    .reset(reset_w),
				    .MOSI(MOSI_w),
					.SS_n(SS_n_w),
					.rx_data(rx_data), 
					.tx_data(tx_data), 
					.rx_valid(rx_valid),
					.tx_valid(tx_valid),
					.MISO(MISO_w));
					
					
					
					 
ram_spi ram_inst(.clk(clk_w),
                    .rst_n(reset_w),
					.din(rx_data), 
					.dout(tx_data), 
					.rx_valid(rx_valid),
					.tx_valid(tx_valid));
					
					
endmodule