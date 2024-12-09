////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Monitor
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_monitor_pkg;
	import RAM_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class RAM_monitor extends  uvm_monitor;
		`uvm_component_utils(RAM_monitor)
		
		RAM_seq_item seq_item;
		virtual RAM_if RAM_vif;
		uvm_analysis_port #(RAM_seq_item) mon_ap;

		function  new(string name = "RAM_monitor", uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap=new("mon_ap",this);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				seq_item=RAM_seq_item::type_id::create("seq_item");
				@(negedge RAM_vif.clk);
				//input
				seq_item.rst_n=RAM_vif.rst_n;
				seq_item.din=RAM_vif.din;
				seq_item.rx_valid=RAM_vif.rx_valid;
				//output
				seq_item.tx_valid=RAM_vif.tx_valid;
				seq_item.dout=RAM_vif.dout;
				//seq_item.dout_ref = RAM_vif.dout_ref;
				//seq_item.tx_valid_ref=RAM_vif.tx_valid_ref;
				mon_ap.write(seq_item);
				`uvm_info("run_phase",seq_item.convert2string(),UVM_HIGH);
			end	
		endtask : run_phase

	endclass : RAM_monitor
endpackage : RAM_monitor_pkg