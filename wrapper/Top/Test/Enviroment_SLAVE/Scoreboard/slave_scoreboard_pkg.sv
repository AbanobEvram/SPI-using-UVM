////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Scoreboard
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package slave_scoreboard_pkg;
	import slave_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class slave_scoreboard extends  uvm_scoreboard;
		`uvm_component_utils(slave_scoreboard)

		uvm_analysis_export #(slave_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(slave_seq_item) sb_fifo;
        slave_seq_item seq_item_sb;

        //Counters for check the result
        int rx_error_count = 0;
        int rx_correct_count = 0;
        int MISO_error_count =0;
        int MISO_correct_count = 0;

        function new(string name = "slave_scoreboard", uvm_component parent = null);
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
            forever begin
                sb_fifo.get(seq_item_sb);
                if ((seq_item_sb.rx_data!==seq_item_sb.rx_data_ref)||(seq_item_sb.rx_valid!==seq_item_sb.rx_valid_ref)) begin
                    `uvm_error("run_phase", $sformatf("comparsion RX failed, DUT:%s  While :rx_data_ref = %0h, rx_valid_ref = %0b",
                     seq_item_sb.convert2string(), seq_item_sb.rx_data_ref, seq_item_sb.rx_valid_ref))
                    rx_error_count++;
                end 
                else begin
                    `uvm_info("run_phase", $sformatf("Correct RX: %s", seq_item_sb.convert2string()), UVM_HIGH)
                    rx_correct_count++;
                end

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
            `uvm_info("report_phase", $sformatf("Total successful[RX]: %0d", rx_correct_count), UVM_LOW)
            `uvm_info("report_phase", $sformatf("Total failed[RX]: %0d", rx_error_count), UVM_LOW)
            `uvm_info("report_phase", $sformatf("Total successful[MOSO]: %0d", MISO_correct_count), UVM_LOW)
            `uvm_info("report_phase", $sformatf("Total failed[MOSO]: %0d", MISO_error_count), UVM_LOW)
        endfunction : report_phase

	endclass : slave_scoreboard
endpackage : slave_scoreboard_pkg