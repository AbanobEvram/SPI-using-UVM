////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Wrapper_Enviroment
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package wrapper_env_pkg;
	import wrapper_scoreboard_pkg::*;
	import wrapper_coverage_pkg::*;
	import wrapper_agent_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class wrapper_env extends  uvm_env;
		`uvm_component_utils(wrapper_env)

		wrapper_agent agt;
		wrapper_scoreboard sb;
		wrapper_coverage cov;

		function  new(string name = "wrapper_env" , uvm_component parent = null);
      		super.new(name,parent);
    	endfunction : new

		function void build_phase(uvm_phase phase);
      		super.build_phase(phase);
      		agt=wrapper_agent::type_id::create("agt",this);
      		sb=wrapper_scoreboard::type_id::create("sb",this);
      		cov=wrapper_coverage::type_id::create("cov",this);
    	endfunction : build_phase

    	function void connect_phase(uvm_phase phase);
      		super.connect_phase(phase);
      		agt.agt_ap.connect(sb.sb_export);
      		agt.agt_ap.connect(cov.cov_export);
    	endfunction : connect_phase

	endclass : wrapper_env
	
endpackage : wrapper_env_pkg