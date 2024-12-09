////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Wrapper_Design
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
module Maindesign(MOSI,SS_n,clk,rst_n,MISO);
 input MOSI,SS_n,clk,rst_n;
 output MISO;
 wire [9:0] rx_data;
 wire [7:0] tx_data;
 wire rx_valid, tx_valid;
 
SLAVE    spi(MOSI, SS_n, clk, rst_n, tx_valid,MISO,rx_valid,rx_data,tx_data);
 
RAM    	 ram(rx_data,clk,rst_n,rx_valid,tx_data,tx_valid);

endmodule