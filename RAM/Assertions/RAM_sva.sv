////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Assertions
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import RAM_shared_pkg::*;
module RAM_sva (din,clk,rst_n,rx_valid,dout,tx_valid,wr_addr,rd_addr,mem);
	input [ADDR_SIZE+1:0] din;
 	input clk,rst_n,rx_valid;
 	input [ADDR_SIZE-1:0] dout;
 	input tx_valid; 
 	input [ADDR_SIZE-1:0] wr_addr,rd_addr;
 	input [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];

 	//Always comp to test asynch rst_n
 	always_comb begin
 		if(rst_n==ACTIVE_RESET) begin
 			rst_wr_addr_assert :	assert final (wr_addr  == INACTIVE);
			rst_rd_addr_assert :	assert final (rd_addr  == INACTIVE);
			rst_tx_valid_assert:	assert final (tx_valid == INACTIVE);
			rst_wr_addr_cover  :	cover final  (wr_addr  == INACTIVE);
			rst_rd_addr_cover  :	cover final  (rd_addr  == INACTIVE);
			rst_tx_valid_cover :	cover final  (tx_valid == INACTIVE);
 		end	
 	end

 	property wr_addr_prop;
			@(posedge clk) disable iff(!rst_n) (rx_valid && din[ADDR_SIZE+1:ADDR_SIZE] == WRITE_ADD)|=> (wr_addr == $past(din[ADDR_SIZE-1:0]));
	endproperty

	property wr_data_prop;
			@(posedge clk) disable iff(!rst_n) (rx_valid && din[ADDR_SIZE+ 1:ADDR_SIZE] == WRITE_DATA) |=> (mem[wr_addr] == $past(din[ADDR_SIZE-1:0]));
	endproperty	

	property rd_addr_prop;
			@(posedge clk) disable iff(!rst_n) (rx_valid && din[ADDR_SIZE+ 1:ADDR_SIZE] == READ_ADD) |=> (rd_addr == $past(din[ADDR_SIZE-1:0]));
	endproperty	
	
	property rd_data_prop;
			@(posedge clk) disable iff(!rst_n) (rx_valid && din[ADDR_SIZE+ 1:ADDR_SIZE] == READ_DATA) |=> (dout == $past(mem[rd_addr]));
	endproperty	

	property tx_valid_prop;
			@(posedge clk) disable iff(!rst_n) (rx_valid && din[ADDR_SIZE+ 1:ADDR_SIZE] == READ_DATA) |=> (tx_valid == 1);
	endproperty	

/**************************************************************/
	wr_addr_assert :assert property(wr_addr_prop);
	wr_data_assert :assert property(wr_data_prop);
	rd_addr_assert :assert property(rd_addr_prop);
	rd_data_assert :assert property(rd_data_prop);
	tx_valid_assert:assert property(tx_valid_prop);
/************************************************************/
	wr_addr_cover :cover  property(wr_addr_prop);
	wr_data_cover :cover  property(wr_data_prop);
	rd_addr_cover :cover  property(rd_addr_prop);
	rd_data_cover :cover  property(rd_data_prop);
	tx_valid_cover:cover  property(tx_valid_prop);
endmodule	