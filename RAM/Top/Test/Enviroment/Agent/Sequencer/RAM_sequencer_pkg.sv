////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Sequencer
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_sequencer_pkg;
    import RAM_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class RAM_sequencer extends uvm_sequencer #(RAM_seq_item);
        `uvm_component_utils(RAM_sequencer)

        function new(string name = "RAM_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction : new
        
    endclass : RAM_sequencer 
endpackage : RAM_sequencer_pkg