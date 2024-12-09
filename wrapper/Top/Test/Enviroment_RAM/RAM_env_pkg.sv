////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Enviroment
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_env_pkg;
	import RAM_scoreboard_pkg::*;
	import RAM_coverage_pkg::*;
	import RAM_agent_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class RAM_env extends  uvm_env;
		`uvm_component_utils(RAM_env)

		RAM_agent agt;
		RAM_scoreboard sb;
		RAM_coverage cov;

		function  new(string name = "RAM_env" , uvm_component parent = null);
      		super.new(name,parent);
    	endfunction : new

		function void build_phase(uvm_phase phase);
      		super.build_phase(phase);
      		agt=RAM_agent::type_id::create("agt",this);
      		sb=RAM_scoreboard::type_id::create("sb",this);
      		cov=RAM_coverage::type_id::create("cov",this);
    	endfunction : build_phase

    	function void connect_phase(uvm_phase phase);
      		super.connect_phase(phase);
      		agt.agt_ap.connect(sb.sb_export);
      		agt.agt_ap.connect(cov.cov_export);
    	endfunction : connect_phase

	endclass : RAM_env
	
endpackage : RAM_env_pkg