////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Scoreboard
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_scoreboard_pkg;
    import RAM_shared_pkg::*;
    import RAM_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class RAM_scoreboard extends  uvm_scoreboard;
        `uvm_component_utils(RAM_scoreboard)

        uvm_analysis_export #(RAM_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
        RAM_seq_item seq_item_sb;
        //ref signals
        bit [ADDR_SIZE-1:0] dout_ref;
        bit tx_valid_ref;
        //internal signals
        logic [ADDR_SIZE-1:0] wr_addr,rd_addr;
        logic [ADDR_SIZE-1:0] mem_ref [MEM_DEPTH-1:0];
        //Counters for check the result
        int error_count = 0;
        int correct_count = 0;

        function new(string name = "RAM_scoreboard", uvm_component parent = null);
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
            $readmemh("RAM_data.dat", mem_ref, 0, 255);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);
                if ((seq_item_sb.dout !== dout_ref) || (seq_item_sb.tx_valid !== tx_valid_ref)) begin
                    `uvm_error("run_phase", $sformatf("comparsion failed, DUT:%s  While :dout_ref = %0h, tx_valid_ref = %0b",
                     seq_item_sb.convert2string(), dout_ref, tx_valid_ref))
                    error_count++;
                end 
                else begin
                    `uvm_info("run_phase", $sformatf("Correct : %s", seq_item_sb.convert2string()), UVM_HIGH)
                    correct_count++;
                end
            end
        endtask : run_phase

        task ref_model(RAM_seq_item seq_item_check);
            if(seq_item_check.rst_n==ACTIVE_RESET) begin
                tx_valid_ref=0;
                wr_addr=0;
                rd_addr=0;
            end
            else begin
                if(seq_item_check.rx_valid==ACTIVE) begin
                    case (seq_item_check.din[ADDR_SIZE+1:ADDR_SIZE])
                        WRITE_ADD : wr_addr=seq_item_check.din[ADDR_SIZE-1:0];
                        WRITE_DATA: mem_ref[wr_addr]=seq_item_check.din[ADDR_SIZE-1:0];
                        READ_ADD  : rd_addr=seq_item_check.din[ADDR_SIZE-1:0];
                        READ_DATA : dout_ref=mem_ref[rd_addr];
                    endcase
                     tx_valid_ref=(seq_item_check.din[ADDR_SIZE+1:ADDR_SIZE]==READ_DATA&&seq_item_check.rx_valid)?1:0;
                end
               
            end
        endtask : ref_model

        function void report_phase (uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful: %0d", correct_count), UVM_LOW)
            `uvm_info("report_phase", $sformatf("Total failed : %0d", error_count), UVM_LOW)
        endfunction : report_phase

    endclass : RAM_scoreboard
endpackage : RAM_scoreboard_pkg