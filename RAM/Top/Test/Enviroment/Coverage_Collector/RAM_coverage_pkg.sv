////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_coverage
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_coverage_pkg;
	import RAM_seq_item_pkg::*;
	import RAM_shared_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class RAM_coverage extends  uvm_component;
		`uvm_component_utils(RAM_coverage)

		uvm_analysis_export #(RAM_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) cov_fifo;
        RAM_seq_item seq_item_cov;

        covergroup covgrp;
        	rst_cp:coverpoint seq_item_cov.rst_n {
        		bins rst_active  = {ACTIVE_RESET};
        		bins rst_inactive= {INACTIVE_RESET};
        	}
        	rx_valid_cp:coverpoint seq_item_cov.rx_valid{
        		bins rx_active  = {ACTIVE};
        		bins rx_inactive= {INACTIVE};
        	}
        	din_addr_cp:coverpoint seq_item_cov.din[ADDR_SIZE-1:0];
        	din_option_cp:coverpoint seq_item_cov.din[ADDR_SIZE+1:ADDR_SIZE]{
        		bins Write_add	= {WRITE_ADD}; 
        		bins Write_data	= {WRITE_DATA};
        		bins Read_add	= {READ_ADD};
        		bins Read_data 	= {READ_DATA};
        	} 

        	wr_addr_cr: cross rx_valid_cp, din_option_cp iff (seq_item_cov.rst_n==INACTIVE_RESET) {
                option.cross_auto_bin_max = 0;
               bins wr_addr_occur = binsof(rx_valid_cp) intersect {ACTIVE} && binsof(din_option_cp) intersect {WRITE_ADD};
            }
            wr_data_cr: cross rx_valid_cp, din_option_cp iff (seq_item_cov.rst_n==INACTIVE_RESET) {
                option.cross_auto_bin_max = 0;
               bins wr_data_occur = binsof(rx_valid_cp) intersect {ACTIVE} && binsof(din_option_cp) intersect {WRITE_DATA};
            }
            rd_addr_cr: cross rx_valid_cp, din_option_cp iff (seq_item_cov.rst_n==INACTIVE_RESET) {
                option.cross_auto_bin_max = 0;
               bins rd_addr_occur = binsof(rx_valid_cp) intersect {ACTIVE} && binsof(din_option_cp) intersect {READ_ADD};
            }
            rd_data_cr: cross rx_valid_cp, din_option_cp iff (seq_item_cov.rst_n==INACTIVE_RESET) {
                option.cross_auto_bin_max = 0;
               bins rd_data_occur = binsof(rx_valid_cp) intersect {ACTIVE} && binsof(din_option_cp) intersect {READ_DATA};
            }
        endgroup : covgrp

        function new(string name = "RAM_coverage", uvm_component parent = null);
            super.new(name, parent);
            covgrp = new;
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction : connect_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                covgrp.sample();
            end
        endtask : run_phase

	endclass : RAM_coverage
endpackage : RAM_coverage_pkg