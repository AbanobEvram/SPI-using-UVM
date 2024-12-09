////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Sequences
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package slave_seq_pkg;
	import slave_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
/************************************************************************************/
	class slave_rst_assert extends  uvm_sequence #(slave_seq_item);
		`uvm_object_utils(slave_rst_assert)

		slave_seq_item seq_item;

		function new(string name = "slave_rst_assert");
            super.new(name);
        endfunction : new

        task pre_body;
            seq_item = slave_seq_item::type_id::create("seq_item");
        endtask :pre_body

        task body();
        	start_item(seq_item);
                seq_item.rst_n    = 0;        
                seq_item.SS_n     = 0;
                seq_item.MOSI     = 0;
                seq_item.tx_valid = 0;
                seq_item.tx_data  = 0;         
            finish_item(seq_item);
        
        endtask : body
	endclass : slave_rst_assert
/************************************************************************************/	
	class slave_main_seq extends  uvm_sequence #(slave_seq_item);
		`uvm_object_utils(slave_main_seq)

		slave_seq_item seq_item;

		function new(string name = "slave_main_seq");
            super.new(name);
        endfunction : new

        task pre_body;
            seq_item = slave_seq_item::type_id::create("seq_item");
        endtask :pre_body

        task body();
        	repeat(20000) begin
        		start_item(seq_item);
                	assert(seq_item.randomize());        
            	finish_item(seq_item);
        	end
        endtask : body
	endclass : slave_main_seq	
/************************************************************************************/
    class slave_rand_seq extends  uvm_sequence #(slave_seq_item);
        `uvm_object_utils(slave_rand_seq)

        slave_seq_item seq_item;

        function new(string name = "slave_rand_seq");
            super.new(name);
        endfunction : new

        task pre_body;
            seq_item = slave_seq_item::type_id::create("seq_item");
        endtask :pre_body

        task body();

            repeat(10000) begin
                start_item(seq_item);
                    seq_item.constraint_mode(0);
                    assert(seq_item.randomize());        
                finish_item(seq_item);
            end
        endtask : body
    endclass : slave_rand_seq   
/************************************************************************************/
endpackage : slave_seq_pkg