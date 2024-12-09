////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Assertions
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import wrapper_shared_pkg::*;
module Wrapper_sva (MOSI,SS_n,rst_n,MISO,rx_data,tx_data,rx_valid,tx_valid,clk);
	input MOSI,SS_n,rst_n,clk;
 	input MISO;
 	input [9:0] rx_data;
 	input [7:0] tx_data;
	input rx_valid, tx_valid;

 	//Always comp to test asynch rst_n
 	always_comb begin
 		if(rst_n==ACTIVE_RESET) begin
 			rst_tx_valid_assert 	:	assert final (tx_valid  == INACTIVE);
			rst_rst_rx_valid_assert :	assert final (rx_valid  == INACTIVE);
			rst_rst_tx_data_assert 	:	assert final (tx_data 	== INACTIVE);
			rst_rst_rx_data_assert 	:	assert final (rx_data 	== INACTIVE);
			rst_tx_valid_cover  	:	cover final  (tx_valid  == INACTIVE);
			rst_rst_rx_valid_cover  :	cover final  (rx_valid  == INACTIVE);
			rst_rst_tx_data_cover 	:	cover final  (tx_data 	== INACTIVE);
			rst_rst_rx_data_cover 	:	cover final  (rx_data 	== INACTIVE);
 		end	
 	end




 	property rx_valid_prop;
			@(posedge clk) disable iff(!rst_n) (SS_n) ##1 (!SS_n) [*12] |=> (rx_valid);  
	endproperty

	property tx_valid_prop;
			@(posedge clk) disable iff(!rst_n) (SS_n) ##1 (!SS_n) [*12] ##1 ((!SS_n) && 
       ({$past(MOSI, 10), $past(MOSI, 9)} == 2'b11)) |=> (tx_valid);
	endproperty	

	property rx_data_prop;
			@(posedge clk) disable iff(!rst_n) (SS_n) ##1 (!SS_n) [*12] |=> (rx_data == 
       {$past(MOSI, 10), $past(MOSI, 9), $past(MOSI, 8), $past(MOSI, 7), 
       $past(MOSI, 6), $past(MOSI, 5), $past(MOSI, 4), $past(MOSI, 3),
       $past(MOSI, 2), $past(MOSI)});  
	endproperty	

/**************************************************************/
	rx_valid_assert :assert property(rx_valid_prop);
	tx_valid_assert :assert property(tx_valid_prop);
	rx_data_assert  :assert property(rx_data_prop);
/************************************************************/
	rx_valid_cover  :cover  property(rx_valid_prop);
	tx_valid_cover  :cover  property(tx_valid_prop);
	rx_data_cover   :cover  property(rx_data_prop);
endmodule	