////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Test
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_test_pkg;
	import RAM_env_pkg::*;
	import RAM_config_pkg::*;
	import RAM_seq_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class RAM_test extends  uvm_test;
		`uvm_component_utils(RAM_test)

		RAM_env env;
        RAM_config RAM_cfg;
        RAM_rst_assert rst_seq;
        RAM_write_only write_only_seq;
        RAM_read_only read_only_seq;
        RAM_write_read write_read_seq;

        function  new(string name = "RAM_test", uvm_component parent = null);
        	super.new(name, parent);
        endfunction : new

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            env             = RAM_env::type_id::create("env", this);
            RAM_cfg 		= RAM_config::type_id::create("RAM_cfg");
            rst_seq         = RAM_rst_assert::type_id::create("rst_seq");
            write_only_seq  = RAM_write_only::type_id::create("write_only_seq");
            read_only_seq   = RAM_read_only::type_id::create("read_only_seq");
            write_read_seq  = RAM_write_read::type_id::create("write_read_seq");

            if (!uvm_config_db #(virtual RAM_if)::get(this, "", "RAM_IF", RAM_cfg.RAM_vif))
                `uvm_fatal("build_phase", "Test-unable to get the virtual interface of the RAM from the uvm_config_db")

            RAM_cfg.is_active=UVM_ACTIVE;

            uvm_config_db #(RAM_config)::set(this, "*", "CFG", RAM_cfg);
        endfunction : build_phase

		task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
                `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
                rst_seq.start(env.agt.sqr);
                `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

                `uvm_info("run_phase", "Write Only Sequence Started", UVM_LOW);
                write_only_seq.start(env.agt.sqr);
                `uvm_info("run_phase", "Write Only Sequence Ended", UVM_LOW);

                `uvm_info("run_phase", "Read Only Sequence Started", UVM_LOW);
                read_only_seq.start(env.agt.sqr);
                `uvm_info("run_phase", "Read Only Sequence Ended", UVM_LOW);

                `uvm_info("run_phase", "Write-Read Sequence Started", UVM_LOW);
                write_read_seq.start(env.agt.sqr);
                `uvm_info("run_phase", "Write-Read Sequence Ended", UVM_LOW);

                `uvm_info("run_phase", "Finish Sequences", UVM_LOW);
            phase.drop_objection(this);
        endtask


	endclass : RAM_test
endpackage : RAM_test_pkg