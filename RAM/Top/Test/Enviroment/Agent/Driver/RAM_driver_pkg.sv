////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_driver
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_driver_pkg;
	import RAM_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	class RAM_driver extends  uvm_driver #(RAM_seq_item);
		`uvm_component_utils(RAM_driver);

		RAM_seq_item stim_seq_item;
		virtual RAM_if RAM_vif;

		function  new(string name = "RAM_driver" , uvm_component parent = null);
      		super.new(name,parent);
  		endfunction : new

  		task run_phase(uvm_phase phase);
  			super.run_phase(phase);
  			forever begin
             	stim_seq_item = RAM_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);

                RAM_vif.rst_n    = stim_seq_item.rst_n;
                RAM_vif.rx_valid = stim_seq_item.rx_valid;
                RAM_vif.din  	 = stim_seq_item.din;
                @(negedge RAM_vif.clk);

                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string(), UVM_HIGH)
            				
  			end
  		endtask : run_phase

	endclass : RAM_driver
endpackage : RAM_driver_pkg