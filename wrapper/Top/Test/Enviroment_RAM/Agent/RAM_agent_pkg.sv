////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Agent
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_agent_pkg;
	import RAM_seq_item_pkg::*;
	import RAM_driver_pkg::*;
	import RAM_monitor_pkg::*;
	import RAM_sequencer_pkg::*;
	import RAM_config_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class RAM_agent extends  uvm_agent;
		`uvm_component_utils(RAM_agent)

		RAM_driver driver;
		RAM_monitor monitor;
		RAM_sequencer sqr;
		RAM_config RAM_cfg;
		uvm_analysis_port #(RAM_seq_item) agt_ap;

		function  new(string name = "RAM_agent" , uvm_component parent = null);
      		super.new(name,parent);
    	endfunction : new

    	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);

    		if(!uvm_config_db#(RAM_config)::get(this,"","CFG",RAM_cfg))
        	`uvm_fatal("build_phase","Agent - unable to get configuration object");  
		  
		  	 if(RAM_cfg.is_active==UVM_ACTIVE) begin
		  		driver  =RAM_driver::type_id::create("driver",this);
         	 	sqr    =RAM_sequencer::type_id::create("sqr",this);  
          	end
          	monitor =RAM_monitor::type_id::create("monitor",this);
      	  	agt_ap 	=new("agt_ap",this);

    	endfunction : build_phase

    	function void connect_phase(uvm_phase phase);
      		super.connect_phase(phase);
      		if(RAM_cfg.is_active==UVM_ACTIVE) begin
            	driver.RAM_vif=RAM_cfg.RAM_vif;
          		driver.seq_item_port.connect(sqr.seq_item_export);          
      		end
      		monitor.RAM_vif=RAM_cfg.RAM_vif;
      		monitor.mon_ap.connect(agt_ap);
		endfunction : connect_phase

	endclass : RAM_agent
endpackage : RAM_agent_pkg