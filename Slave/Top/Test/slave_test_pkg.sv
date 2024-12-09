////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Test
// Date: Novmber, 2024 
////////////////////////////////////////////////////////////////////////////////
package slave_test_pkg;
	import slave_env_pkg::*;
	import slave_config_pkg::*;
	import slave_seq_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class slave_test extends  uvm_test;
		`uvm_component_utils(slave_test)

		slave_env env;
        slave_config slave_cfg;
        slave_rst_assert rst_seq;
        slave_main_seq main_seq;
        slave_rand_seq rand_seq;
        

        function  new(string name = "slave_test", uvm_component parent = null);
        	super.new(name, parent);
        endfunction : new

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            env             = slave_env::type_id::create("env", this);
            slave_cfg 		= slave_config::type_id::create("slave_cfg");
            rst_seq         = slave_rst_assert::type_id::create("rst_seq");
            main_seq        = slave_main_seq::type_id::create("main_seq");
            rand_seq        = slave_rand_seq::type_id::create("rand_seq");

            if (!uvm_config_db #(virtual slave_if)::get(this, "", "slave_IF", slave_cfg.slave_vif))
                `uvm_fatal("build_phase", "Test-unable to get the virtual interface of the slave from the uvm_config_db")
            
            slave_cfg.is_active=UVM_ACTIVE;

            uvm_config_db #(slave_config)::set(this, "*", "CFG", slave_cfg);
        endfunction : build_phase

		task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
                `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
                rst_seq.start(env.agt.sqr);
                `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

                `uvm_info("run_phase", "Main Sequence Started", UVM_LOW);
                main_seq.start(env.agt.sqr);
                `uvm_info("run_phase", "Main Sequence Ended", UVM_LOW);

                `uvm_info("run_phase", "Rand Sequence Started", UVM_LOW);
                rand_seq.start(env.agt.sqr);
                `uvm_info("run_phase", "Rand Sequence Ended", UVM_LOW);

                `uvm_info("run_phase", "Finish Sequences", UVM_LOW);
            phase.drop_objection(this);
        endtask


	endclass : slave_test
endpackage : slave_test_pkg