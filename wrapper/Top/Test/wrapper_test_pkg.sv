////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Wrapper_Test
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package wrapper_test_pkg;
    import RAM_env_pkg::*;
    import slave_env_pkg::*;
	import wrapper_env_pkg::*;
    import RAM_config_pkg::*;
    import slave_config_pkg::*;
	import wrapper_config_pkg::*;
	import wrapper_sequence_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class wrapper_test extends  uvm_test;
		`uvm_component_utils(wrapper_test)

        RAM_env env_RAM;
        slave_env env_slave;
		wrapper_env env_wrapper;
        RAM_config RAM_cfg;
        slave_config slave_cfg;
        wrapper_config wrapper_cfg;
        wrapper_rst_assert rst_seq;
        wrapper_main_seq main_seq;
        
        function  new(string name = "wrapper_test", uvm_component parent = null);
        	super.new(name, parent);
        endfunction : new

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            env_RAM         = RAM_env::type_id::create("env_RAM", this);
            env_slave       = slave_env::type_id::create("env_slave", this);
            env_wrapper     = wrapper_env::type_id::create("env_wrapper", this);
            RAM_cfg         = RAM_config::type_id::create("RAM_cfg");
            slave_cfg       = slave_config::type_id::create("slave_cfg");
            wrapper_cfg 	= wrapper_config::type_id::create("wrapper_cfg");
            rst_seq         = wrapper_rst_assert::type_id::create("rst_seq");
            main_seq        = wrapper_main_seq::type_id::create("main_seq");
            
            if (!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", RAM_cfg.RAM_vif))
                `uvm_fatal("build_phase", "Test-unable to get the virtual interface of the RAM from the uvm_config_db")
            if (!uvm_config_db #(virtual slave_if)::get(this, "", "slave_IF", slave_cfg.slave_vif))
                `uvm_fatal("build_phase", "Test-unable to get the virtual interface of the SLAVE from the uvm_config_db")
            if (!uvm_config_db #(virtual wrapper_if)::get(this, "", "wrapper_IF", wrapper_cfg.wrapper_vif))
                `uvm_fatal("build_phase", "Test-unable to get the virtual interface of the wrapper from the uvm_config_db")
            
            RAM_cfg.is_active    =UVM_PASSIVE;
            slave_cfg.is_active  =UVM_PASSIVE;
            wrapper_cfg.is_active=UVM_ACTIVE;

            uvm_config_db #(RAM_config)   ::set(this, "*", "CFG", RAM_cfg);
            uvm_config_db #(slave_config)   ::set(this, "*", "CFG", slave_cfg);
            uvm_config_db #(wrapper_config) ::set(this, "*", "CFG", wrapper_cfg);
        endfunction : build_phase

		task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
                `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
                rst_seq.start(env_wrapper.agt.sqr);
                `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

                `uvm_info("run_phase", "Main Seq Started", UVM_LOW);
                main_seq.start(env_wrapper.agt.sqr);
                `uvm_info("run_phase", "Main Seq Ended", UVM_LOW);

                `uvm_info("run_phase", "Finish Test", UVM_LOW);
            phase.drop_objection(this);
        endtask : run_phase

	endclass : wrapper_test
endpackage : wrapper_test_pkg