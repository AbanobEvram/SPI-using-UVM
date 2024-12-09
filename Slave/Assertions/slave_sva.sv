////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Assertions
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import slave_shared_pkg::*;
module slave_sva (MOSI, SS_n, clk, rst_n, tx_valid,MISO,rx_valid,rx_data,tx_data,cs,rd_add_signal,count_rx,count_tx);

 	input MOSI, SS_n, clk, rst_n, tx_valid;
 	input [ADDR_SIZE-1:0] tx_data;
 	input [ADDR_SIZE+1:0] rx_data;
 	input MISO; 
 	input rx_valid;
 	input STATE_e cs;
 	input rd_add_signal; 
 	input integer count_rx,count_tx;

	always_comb begin
		if (rst_n==ACTIVE_RESET) begin
			rst_count_rx_assert 	 : assert final (count_rx == 0);
			rst_count_tx_assert 	 : assert final (count_tx == 0);
			rst_rd_add_signal_assert : assert final (rd_add_signal == INACTIVE);
			rst_cs_assert 	 		 : assert final (cs == IDLE);
			rst_count_rx_cover 	 	 : cover final  (count_rx == 0);
			rst_count_tx_cover 	 	 : cover final  (count_tx == 0);
			rst_rd_add_signal_cover  : cover final  (rd_add_signal == INACTIVE);
			rst_cs_cover 	 		 : cover final  (cs == IDLE);
		end
	end
	/*This assertinos for the cs*/
	property idel_prop;
		@(posedge clk) disable iff(!rst_n) SS_n |=> cs == IDLE;
	endproperty	

	property check_prop;
		@(posedge clk) disable iff(!rst_n) (!SS_n&&cs==IDLE) |=> cs == CHK_CMD;
	endproperty

	property write_prop;
		@(posedge clk) disable iff(!rst_n) (!SS_n&&cs==CHK_CMD&&!MOSI) |=> cs == WRITE;
	endproperty	

	property read_add_prop;
		@(posedge clk) disable iff(!rst_n) (!SS_n&&cs==CHK_CMD&&MOSI&&!rd_add_signal) |=> cs == READ_ADD;
	endproperty

	property read_data_prop;
		@(posedge clk) disable iff(!rst_n) (!SS_n&&cs==CHK_CMD&&MOSI&&rd_add_signal) |=> cs == READ_DATA;
	endproperty	
	/*This assertions for the rd_add_signal*/
	property rd_flag_ra_pr;
			@(posedge clk) disable iff(!rst_n) ((cs == READ_ADD) && (count_rx == 10)) |=> (rd_add_signal);
	endproperty

	property rd_flag_rd_pr;
			@(posedge clk) disable iff(!rst_n) ((cs == READ_DATA) && (count_tx >= 8)) |=> (!rd_add_signal);
	endproperty

/**************************************************************/
	idel_assert 	  :assert property(idel_prop);
	check_assert 	  :assert property(check_prop);
	write_assert 	  :assert property(write_prop);
	read_add_assert   :assert property(read_add_prop);
	read_data_assert  :assert property(read_data_prop);
	rd_flag_ra_assert :assert property(rd_flag_ra_pr);
	rd_flag_rd_assert :assert property(rd_flag_rd_pr);
/************************************************************/
	idel_cover 	 	 :cover  property(idel_prop);
	check_cover 	 :cover  property(check_prop);
	write_cover 	 :cover  property(write_prop);
	read_add_cover 	 :cover  property(read_add_prop);
	read_data_cover	 :cover  property(read_data_prop);
	rd_flag_ra_cover :cover  property(rd_flag_ra_pr);
	rd_flag_rd_cover :cover  property(rd_flag_rd_pr);

endmodule	