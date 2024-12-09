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
    class RAM_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(RAM_scoreboard)

        uvm_analysis_export   #(RAM_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
        RAM_seq_item seq_item_sb;
        
        bit tx_valid_ref;
        bit [ADDR_SIZE - 1 : 0] dout_ref, wr_addr, rd_addr;
        bit [ADDR_SIZE - 1 : 0] mem_test [MEM_DEPTH];
        // We use rx_valid_reg and din_reg because the slave sends the values, and in the next clock cycle, the RAM takes these values
        bit rx_valid_reg;
        bit [ADDR_SIZE + 1 : 0] din_reg;
        //counters
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
            $readmemh("RAM_data.dat", mem_test, 0, 255);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);
                if ((seq_item_sb.dout !== dout_ref) || (seq_item_sb.tx_valid !== tx_valid_ref)) begin
                    `uvm_error("run_phase", $sformatf("comparsion failed, Transaction received by the DUT:%s  While the reference dout: dout_ref = %0h, tx_valid_ref = %0b",
                     seq_item_sb.convert2string(), dout_ref, tx_valid_ref))
                    error_count++;
                end 
                else begin
                    `uvm_info("run_phase", $sformatf("Correct RAM Transaction: %s", seq_item_sb.convert2string()), UVM_HIGH)
                    correct_count++;
                end
            end
        endtask : run_phase

        task ref_model(RAM_seq_item seq_item_chk);
            if (!seq_item_chk.rst_n) begin
                wr_addr = 0;
                rd_addr = 0;
                dout_ref = 0;
                din_reg  = 0;
                    rx_valid_reg = 0;
            end
            else begin
                    din_reg  <= seq_item_sb.din;
                    rx_valid_reg <= seq_item_sb.rx_valid;
            end
            if (rx_valid_reg && seq_item_chk.rst_n) begin
                case (din_reg [ADDR_SIZE + 1 : ADDR_SIZE])
                    2'b00: wr_addr = din_reg [ADDR_SIZE - 1 : 0];
                    2'b01: mem_test [wr_addr] = din_reg [ADDR_SIZE - 1 : 0];
                    2'b10: rd_addr = din_reg [ADDR_SIZE - 1 : 0];
                    2'b11: dout_ref = mem_test [rd_addr];
                endcase
            end
            
            if (!seq_item_chk.rst_n) 
                tx_valid_ref = 0;
            else if (rx_valid_reg) 
                if (din_reg [ADDR_SIZE + 1 : ADDR_SIZE] == 2'b11)
                    tx_valid_ref = 1;
                else
                    tx_valid_ref = 0;
        endtask : ref_model

        function void report_phase (uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful transactions: %0d", correct_count), UVM_MEDIUM)
            `uvm_info("report_phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM)
        endfunction : report_phase

    endclass : RAM_scoreboard
endpackage : RAM_scoreboard_pkg