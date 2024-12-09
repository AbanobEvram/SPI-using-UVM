////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_INTERFACE
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import RAM_shared_pkg::*;
interface RAM_if (clk);
	logic [ADDR_SIZE+1:0] din;
 	logic rst_n,rx_valid;
 	logic [ADDR_SIZE-1:0] dout;
 	logic tx_valid; 
 	logic [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
 	input clk;
endinterface : RAM_if