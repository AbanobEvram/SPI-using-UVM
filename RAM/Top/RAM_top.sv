////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Top
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import RAM_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top ();
	bit clk;
	initial begin
		$readmemh("RAM_data.dat", DUT.mem, 0, 255);
		clk=0;
		forever begin
			#1 clk=~clk;
		end
	end

	RAM_if r_if(clk);
	RAM DUT(
		.clk(clk),
		.rst_n(r_if.rst_n),
		.rx_valid(r_if.rx_valid),
		.tx_valid(r_if.tx_valid),
		.din(r_if.din),
		.dout(r_if.dout)
		);
	bind RAM RAM_sva SVA(
		.din(r_if.din),
		.rx_valid(r_if.rx_valid),
		.rst_n(r_if.rst_n),
		.dout(r_if.dout),
		.tx_valid(r_if.tx_valid),
		.wr_addr(DUT.wr_addr),
		.rd_addr(DUT.rd_addr),
		.mem(DUT.mem),
		.clk(clk)
	);

	initial begin
		uvm_config_db#(virtual RAM_if)::set(null,"uvm_test_top","RAM_IF",r_if );
		run_test("RAM_test");
	end
	
endmodule : top