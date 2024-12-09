////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Wrapper_Scoreboard
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package wrapper_scoreboard_pkg;
	import wrapper_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class wrapper_scoreboard extends  uvm_scoreboard;
		`uvm_component_utils(wrapper_scoreboard)

		uvm_analysis_export #(wrapper_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(wrapper_seq_item) sb_fifo;
        wrapper_seq_item seq_item_sb;

        //Counters for check the result
        int MISO_error_count =0;
        int MISO_correct_count = 0;

        function new(string name = "wrapper_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction : connect_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            //$readmemh("RAM_data.dat", mem_ref, 0, 255);
            forever begin
                sb_fifo.get(seq_item_sb);
                if (seq_item_sb.MISO!==seq_item_sb.MISO_ref) begin
                    `uvm_error("run_phase", $sformatf("comparsion MISO failed, DUT:%s  While :MISO_ref = %0b",
                     seq_item_sb.convert2string(), seq_item_sb.MISO_ref))
                    MISO_error_count++;
                end 
                else begin
                    `uvm_info("run_phase", $sformatf("Correct RX: %s", seq_item_sb.convert2string()), UVM_HIGH)
                    MISO_correct_count++;
                end
            end
        endtask : run_phase

        function void report_phase (uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful[MOSO]: %0d", MISO_correct_count), UVM_LOW)
            `uvm_info("report_phase", $sformatf("Total failed[MOSO]: %0d", MISO_error_count), UVM_LOW)
        endfunction : report_phase

	endclass : wrapper_scoreboard
endpackage : wrapper_scoreboard_pkg