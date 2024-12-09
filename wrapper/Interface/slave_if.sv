////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Interface
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import wrapper_shared_pkg::*;
interface slave_if(clk);
	//Input signals
	logic MOSI, SS_n, rst_n, tx_valid;
  	logic [ADDR_SIZE-1:0] tx_data;
  	input clk;
  	//Output signals
  	logic [ADDR_SIZE+1:0] rx_data,rx_data_ref;
   	logic MISO,MISO_ref; 	
  	logic rx_valid,rx_valid_ref;
  	
endinterface : slave_if					