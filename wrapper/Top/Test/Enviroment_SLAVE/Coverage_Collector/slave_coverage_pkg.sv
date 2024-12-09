////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Coverage_Collector
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package slave_coverage_pkg;
	import slave_seq_item_pkg::*;
    import wrapper_shared_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class slave_coverage extends  uvm_scoreboard;
		`uvm_component_utils(slave_coverage)

		uvm_analysis_export #(slave_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(slave_seq_item) cov_fifo;
        slave_seq_item seq_item_cov;

        covergroup covgrp;
            rst_cp:coverpoint seq_item_cov.rst_n{
                bins active   = {0};
                bins inactive = {1};
            }
            
            cs_cov_cp: coverpoint cs_cov {
                bins wr_add  = {WRITE_ADD_COV};
                bins wr_data = {WRITE_DATA_COV};
                bins rd_add  = {READ_ADD_COV};
                bins rd_data = {READ_DATA_COV};
            }
        endgroup : covgrp

        function new(string name = "slave_coverage", uvm_component parent = null);
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


	endclass : slave_coverage
endpackage : slave_coverage_pkg