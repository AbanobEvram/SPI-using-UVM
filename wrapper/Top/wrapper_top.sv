////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Wrapper_Top
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import wrapper_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top ();
	bit clk;
	initial begin
		$readmemh("RAM_data.dat", DUT_WRAPPER.ram.mem, 0, 255);
		$readmemh("RAM_data.dat", GOLDEN_WRAPPER.mem, 0, 255);
		clk=0;
		forever begin
			#1 clk=~clk;
		end
	end
/********************************************************/
//Interfaces
	slave_if s_if(clk);
	RAM_if r_if(clk);
	wrapper_if w_if(clk);
/********************************************************/
	Maindesign DUT_WRAPPER(
		.clk  (clk),
		.rst_n(w_if.rst_n),
		.MISO (w_if.MISO),
		.MOSI (w_if.MOSI),
		.SS_n (w_if.SS_n)
	);
/*******************************************************/
	SPI_SLAVE GOLDEN_SLAVE(
		.clk     (clk),
		.MISO    (s_if.MISO_ref),
		.MOSI    (s_if.MOSI),
		.tx_valid(s_if.tx_valid),
		.tx_data (s_if.tx_data),
		.rx_valid(s_if.rx_valid_ref),
		.SS_n    (s_if.SS_n),
		.rx_data (s_if.rx_data_ref),
		.rst_n   (s_if.rst_n)
	);
	wrapper_golden GOLDEN_WRAPPER(
		.clk  (clk),
		.rst_n(w_if.rst_n),
		.MISO (w_if.MISO_ref),
		.MOSI (w_if.MOSI),
		.SS_n (w_if.SS_n)
	);
/************************************************************/
//Assertions
	bind RAM RAM_sva RAM_SVA(
		.din(r_if.din),
		.rx_valid(r_if.rx_valid),
		.rst_n(r_if.rst_n),
		.dout(r_if.dout),
		.tx_valid(r_if.tx_valid),
		.wr_addr(DUT_WRAPPER.ram.wr_addr),
		.rd_addr(DUT_WRAPPER.ram.rd_addr),
		.mem(DUT_WRAPPER.ram.mem),
		.clk(clk)
	);

	bind SLAVE slave_sva SLAVE_SVA(
		.clk          (clk),
		.MISO         (s_if.MISO),
		.MOSI         (s_if.MOSI),
		.tx_valid     (s_if.tx_valid),
		.tx_data      (s_if.tx_data),
		.SS_n         (s_if.SS_n),
		.rx_valid     (s_if.rx_valid),
		.rst_n        (s_if.rst_n),
		.rx_data      (s_if.rx_data),
		.cs           (DUT_WRAPPER.spi.cs),
		.rd_add_signal(DUT_WRAPPER.spi.rd_add_signal),
		.count_rx     (DUT_WRAPPER.spi.count_rx),
		.count_tx 	  (DUT_WRAPPER.spi.count_tx)
	);

	bind Maindesign Wrapper_sva WRAPPER_SVA(
		.rst_n   (w_if.rst_n),
		.MOSI    (w_if.MOSI),
		.SS_n    (w_if.SS_n),
		.MISO    (w_if.MISO),
		.tx_valid(DUT_WRAPPER.tx_valid),
		.rx_valid(DUT_WRAPPER.rx_valid),
		.tx_data (DUT_WRAPPER.tx_data),
		.rx_data (DUT_WRAPPER.rx_data),
		.clk     (clk)
		);
/************************************************************/ 
 	assign r_if.din      = DUT_WRAPPER.rx_data;
	assign r_if.rst_n    = w_if.rst_n;
	assign r_if.rx_valid = DUT_WRAPPER.rx_valid;
	assign r_if.dout     = DUT_WRAPPER.tx_data;
	assign r_if.tx_valid = DUT_WRAPPER.tx_valid;

	assign s_if.MOSI     = w_if.MOSI;
	assign s_if.SS_n     = w_if.SS_n;
	assign s_if.rst_n    = w_if.rst_n;
	assign s_if.tx_valid = DUT_WRAPPER.tx_valid;
	assign s_if.tx_data  = DUT_WRAPPER.tx_data;
	assign s_if.rx_data  = DUT_WRAPPER.rx_data;
	assign s_if.MISO     = w_if.MISO;
	assign s_if.rx_valid = DUT_WRAPPER.rx_valid;
/************************************************************/
	initial begin
		uvm_config_db#(virtual RAM_if)::set(null,"uvm_test_top","RAM_IF",r_if );
		uvm_config_db#(virtual slave_if)::set(null,"uvm_test_top","slave_IF",s_if );
		uvm_config_db#(virtual wrapper_if)::set(null,"uvm_test_top","wrapper_IF",w_if );
	
		run_test("wrapper_test");
	end
endmodule : top