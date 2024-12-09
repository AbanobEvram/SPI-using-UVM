////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Wrapper_Sequences
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package wrapper_sequence_pkg;
    import wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
/************************************************************************************/
    class wrapper_rst_assert extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_rst_assert);
        
        wrapper_seq_item seq_item;

        function new(string name = "wrapper_rst_assert");
            super.new(name);
        endfunction : new

        task pre_body;
            seq_item = wrapper_seq_item::type_id::create("seq_item");
        endtask : pre_body

        task body;
            start_item(seq_item);
                seq_item.rst_n = 0;         
                seq_item.SS_n  = 0;
                seq_item.MOSI  = 0;         
            finish_item(seq_item);

        endtask : body
    endclass : wrapper_rst_assert
/************************************************************************************/   
    class wrapper_main_seq extends  uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_main_seq)

        wrapper_seq_item seq_item;

        function new(string name = "wrapper_main_seq");
            super.new(name);
        endfunction : new

        task pre_body;
            seq_item = wrapper_seq_item::type_id::create("seq_item");
        endtask :pre_body

        task body();
            repeat(50000) begin
                start_item(seq_item);
                    assert(seq_item.randomize());        
                finish_item(seq_item);
            end
        endtask : body
    endclass : wrapper_main_seq   
/************************************************************************************/ 
endpackage