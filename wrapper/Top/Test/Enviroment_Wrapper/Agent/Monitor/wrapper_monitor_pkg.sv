////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Wrapper_Monitor
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package wrapper_monitor_pkg;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class wrapper_monitor extends uvm_monitor;
        `uvm_component_utils(wrapper_monitor)

        wrapper_seq_item seq_item;
        virtual wrapper_if wrapper_vif;
        uvm_analysis_port #(wrapper_seq_item) mon_ap;

        function new(string name = "wrapper_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction : build_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = wrapper_seq_item::type_id::create("seq_item");
                @(negedge wrapper_vif.clk);
                //Input
                seq_item.rst_n    = wrapper_vif.rst_n;
                seq_item.SS_n     = wrapper_vif.SS_n;
                seq_item.MOSI     = wrapper_vif.MOSI;
                //Output
                seq_item.MISO     = wrapper_vif.MISO;
                seq_item.MISO_ref = wrapper_vif.MISO_ref;
                mon_ap.write(seq_item);
                `uvm_info("run_phase", seq_item.convert2string(), UVM_HIGH)
            end
        endtask : run_phase

    endclass : wrapper_monitor
endpackage : wrapper_monitor_pkg