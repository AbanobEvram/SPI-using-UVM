////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Top
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import slave_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top ();
	bit clk;
	initial begin
		clk=0;
		forever begin
			#1 clk=~clk;
		end
	end

	slave_if s_if(clk);
	
	SLAVE DUT(
		.clk     (clk),
		.rst_n   (s_if.rst_n),
		.rx_valid(s_if.rx_valid),
		.tx_valid(s_if.tx_valid),
		.rx_data (s_if.rx_data),
		.tx_data (s_if.tx_data),
		.MOSI    (s_if.MOSI),
		.SS_n    (s_if.SS_n),
		.MISO    (s_if.MISO)
	);
	SPI_SLAVE GOLDEN(
		.clk     (s_if.clk),
		.MISO    (s_if.MISO_ref),
		.MOSI    (s_if.MOSI),
		.tx_valid(s_if.tx_valid),
		.tx_data (s_if.tx_data),
		.rx_valid(s_if.rx_valid_ref),
		.SS_n    (s_if.SS_n),
		.rx_data (s_if.rx_data_ref),
		.rst_n   (s_if.rst_n)
	);

	bind SLAVE slave_sva SVA(
		.clk          (clk),
		.MISO         (s_if.MISO),
		.MOSI         (s_if.MOSI),
		.tx_valid     (s_if.tx_valid),
		.tx_data      (s_if.tx_data),
		.SS_n         (s_if.SS_n),
		.rx_valid     (s_if.rx_valid),
		.rst_n        (s_if.rst_n),
		.rx_data      (s_if.rx_data),
		.cs           (DUT.cs),
		.rd_add_signal(DUT.rd_add_signal),
		.count_rx     (DUT.count_rx),
		.count_tx 	  (DUT.count_tx)
	);

	initial begin
		uvm_config_db#(virtual slave_if)::set(null,"uvm_test_top","slave_IF",s_if );
		run_test("slave_test");
	end
	
endmodule : top