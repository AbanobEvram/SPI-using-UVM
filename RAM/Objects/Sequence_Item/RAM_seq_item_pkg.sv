////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Seq_item
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_seq_item_pkg;
	import RAM_shared_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class RAM_seq_item extends  uvm_sequence_item;
		`uvm_object_utils(RAM_seq_item)

		//Randomized properties to generate stimulus
		rand bit rst_n,rx_valid;
		rand bit [ADDR_SIZE+1:0] din;
		//output signals
		bit [ADDR_SIZE-1:0] dout;
 		bit tx_valid; 
 		bit [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];

 		/*Write and Read address array to handle all possible addresses based on ADDR_SIZE*/
 		bit [ADDR_SIZE-1:0] wa_arr [MEM_DEPTH];
 		bit [ADDR_SIZE-1:0] ra_arr [MEM_DEPTH];
 		//Write & Read index for the array
 		bit [ADDR_SIZE-1:0] wa_indx,ra_indx;
 		//Flags for check the read and write addresses occurred
 		bit wr_addr_occur, rd_addr_occur;


 		function  new(string name ="RAM_seq_item");
 			super.new(name);
 			//loop to save all possible addresses in the array
 			for (int i = 0; i < MEM_DEPTH; i++) begin
 				wa_arr [i] = i;
 				ra_arr [i] = i;
 			end
 			wa_arr.shuffle();
 			ra_arr.shuffle();
 		endfunction : new

 		function string convert2string();
 			return $sformatf("%s rst_n = %0b, rx_valid = %0b, din = %0h, tx_valid = %0b, dout = %0h",
                super.convert2string(), rst_n, rx_valid, din, tx_valid, dout);
 		endfunction	
/****************************************************************************************************************/
/********************************************Constraints*********************************************************/

	//Constraint to randomize rst_n with a higher probability of being active
	constraint rst_prob {rst_n dist {ACTIVE_RESET:/RESET_ON_DIST,INACTIVE_RESET:/100-RESET_ON_DIST};}

	// Constraint to randomize rx_valid with a high probability of being valid
    constraint rx_valid_prob {rx_valid dist {ACTIVE:/RX_VALID_ON_DIST,INACTIVE:/100-RX_VALID_ON_DIST};}

    // Constraints on din to ensure valid address mapping
 	constraint din_prob {
 		din [ADDR_SIZE + 1] dist {ACTIVE:/40,INACTIVE:/ 60}; // Randomize high bit for read/write operation
        din [ADDR_SIZE]     dist {ACTIVE:/40,INACTIVE:/ 60}; // Randomize low bit for operation validity

        //Ensure proper handling of write and read operations based on flags
        if (din[ADDR_SIZE + 1] == 0) { 
            if (!wr_addr_occur) //if the write address not occurr the bit 8 will be 0
                din[ADDR_SIZE] == 0; 
        }
        else {
            if (!rd_addr_occur) //if the read address not occurr the bit 8 will be 0
                din[ADDR_SIZE] == 0;
        }
 	
        //if the operation is write or read address we will send the address from the arrays
        if (din[ADDR_SIZE+1:ADDR_SIZE]==WRITE_ADD)
        	din[ADDR_SIZE-1:0] == wa_arr[wa_indx]; 
        else if (din[ADDR_SIZE+1:ADDR_SIZE]==READ_ADD)
        	din[ADDR_SIZE-1:0] == ra_arr[ra_indx];
 	}


 	//Function to handle updates and shuffling post-randomization
 	function void post_randomize();
 		if(wa_indx==MEM_DEPTH-1) //Check if all write addresses have been use
 			wa_arr.shuffle();
 		else if(din[ADDR_SIZE+1:ADDR_SIZE]==WRITE_ADD)
 			wa_indx++;//Increment if the operation is write address

 		if(ra_indx==MEM_DEPTH-1) //Check if all read addresses have been use
 			ra_arr.shuffle();
 		else if(din[ADDR_SIZE+1:ADDR_SIZE]==READ_ADD)
 			ra_indx++;//Increment if the operation is read address

 		//update the flags
 		if (din[ADDR_SIZE + 1 : ADDR_SIZE] == WRITE_ADD)
           	wr_addr_occur = 1; 
        else if (din[ADDR_SIZE + 1 : ADDR_SIZE] == READ_ADD)
            rd_addr_occur = 1;

 	endfunction : post_randomize



	endclass : RAM_seq_item
endpackage : RAM_seq_item_pkg