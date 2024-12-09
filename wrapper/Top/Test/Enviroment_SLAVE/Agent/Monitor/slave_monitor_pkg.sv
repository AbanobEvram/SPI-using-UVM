////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Monitor
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package slave_monitor_pkg;
    import slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class slave_monitor extends uvm_monitor;
        `uvm_component_utils(slave_monitor)

        slave_seq_item seq_item;
        virtual slave_if slave_vif;
        uvm_analysis_port #(slave_seq_item) mon_ap;

        function new(string name = "slave_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction : build_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = slave_seq_item::type_id::create("seq_item");
                @(negedge slave_vif.clk);
                //Input
                seq_item.rst_n    = slave_vif.rst_n;
                seq_item.SS_n     = slave_vif.SS_n;
                seq_item.MOSI     = slave_vif.MOSI;
                seq_item.tx_valid = slave_vif.tx_valid;
                seq_item.tx_data  = slave_vif.tx_data;
                //Output
                seq_item.rx_valid     = slave_vif.rx_valid;
                seq_item.rx_data      = slave_vif.rx_data;
                seq_item.MISO         = slave_vif.MISO;
                seq_item.rx_valid_ref = slave_vif.rx_valid_ref;
                seq_item.rx_data_ref  = slave_vif.rx_data_ref;
                seq_item.MISO_ref     = slave_vif.MISO_ref;
                mon_ap.write(seq_item);
                `uvm_info("run_phase", seq_item.convert2string(), UVM_HIGH)
            end
        endtask : run_phase

    endclass : slave_monitor
endpackage : slave_monitor_pkg