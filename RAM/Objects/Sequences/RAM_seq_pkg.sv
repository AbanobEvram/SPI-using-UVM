////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Sequences
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_seq_pkg;
	import RAM_shared_pkg::*;
	import RAM_seq_item_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
/**********************************************************************************************************************************/
	class RAM_rst_assert extends  uvm_sequence #(RAM_seq_item);
		`uvm_object_utils(RAM_rst_assert)

		RAM_seq_item seq_item;

		function  new(string name = "RAM_rst_assert");
			super.new(name);
		endfunction : new

		task pre_body;
            seq_item = RAM_seq_item::type_id::create("seq_item");
        endtask 

		task body();
			start_item(seq_item);
				seq_item.rst_n=ACTIVE_RESET;
				seq_item.rx_valid=INACTIVE;
				seq_item.din=INACTIVE;
			finish_item(seq_item);
		endtask : body
	endclass : RAM_rst_assert
/**********************************************************************************************************************************/
	class RAM_write_only extends  uvm_sequence #(RAM_seq_item);
		`uvm_object_utils(RAM_write_only)

		RAM_seq_item seq_item;

		function  new(string name = "RAM_write_only");
			super.new(name);
		endfunction : new

		task pre_body;
            seq_item = RAM_seq_item::type_id::create("seq_item");
        endtask 

		task body();
			repeat(10000) begin
				start_item(seq_item);
					assert(seq_item.randomize() with {seq_item.din[ADDR_SIZE+1:ADDR_SIZE] inside {2'b00, 2'b01};});
				finish_item(seq_item);
			end
		endtask : body
	endclass : RAM_write_only

/**********************************************************************************************************************************/
	class RAM_read_only extends  uvm_sequence #(RAM_seq_item);
		`uvm_object_utils(RAM_read_only)

		RAM_seq_item seq_item;

		function  new(string name = "RAM_read_only");
			super.new(name);
		endfunction : new

		task pre_body;
            seq_item = RAM_seq_item::type_id::create("seq_item");
        endtask 

		task body();
			repeat(10000) begin
				start_item(seq_item);
					assert(seq_item.randomize() with {seq_item.din[ADDR_SIZE+1:ADDR_SIZE] inside {2'b10, 2'b11};});
				finish_item(seq_item);
			end
		endtask : body
	endclass : RAM_read_only
/**********************************************************************************************************************************/
	class RAM_write_read extends  uvm_sequence #(RAM_seq_item);
		`uvm_object_utils(RAM_write_read)

		RAM_seq_item seq_item;

		function  new(string name = "RAM_write_read");
			super.new(name);
		endfunction : new

		task pre_body;
            seq_item = RAM_seq_item::type_id::create("seq_item");
        endtask 

		task body();
			repeat(10000) begin
				start_item(seq_item);
					assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body
	endclass : RAM_write_read
/**********************************************************************************************************************************/	
endpackage : RAM_seq_pkg