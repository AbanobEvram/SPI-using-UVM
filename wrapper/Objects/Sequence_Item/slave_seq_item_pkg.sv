////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Sequence_item
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package slave_seq_item_pkg;
	import wrapper_shared_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class slave_seq_item extends  uvm_sequence_item;
		`uvm_object_utils(slave_seq_item)

		//Randomized properties to generate stimulus
		rand bit MOSI, SS_n, clk, rst_n, tx_valid;
		rand bit [ADDR_SIZE-1:0] tx_data;
		//output signals
		logic [ADDR_SIZE+1:0] rx_data,rx_data_ref;
 		logic MISO,rx_valid,MISO_ref,rx_valid_ref;

 		//Array to hold MOSI data ,The size is 21 bit for the longest way (READ_DATA) [2+2+8 dummy+8]
 		rand bit MOSI_arr [20:0];
 		//counter for the mosi_arr and the size is 5
 		bit [4:0] count;
 		//this is Read/Write flag (1 = read, 0 = write)
 		bit rd_flag;
 		
 		function  new(string name ="slave_seq_item");
 			super.new(name);
 		endfunction : new

 		function string convert2string();
 			return $sformatf("%s rst_n = %0b, SS_n = %0b, MOSI = %0b, tx_valid = %0b, tx_data = %0h, rx_valid = %0b, rx_data = %0h, MISO = %0b",
             super.convert2string(), rst_n, SS_n, MOSI, tx_valid, tx_data, rx_valid, rx_data, MISO);
 		endfunction	

/****************************************************************************************************************/
/********************************************Constraints*********************************************************/

	//Constraint to randomize rst_n with a higher probability of being active
	constraint rst_prob {rst_n dist {ACTIVE_RESET:/RESET_ON_DIST,INACTIVE_RESET:/100-RESET_ON_DIST};}
	
	constraint SS_N_prob {
		if(MOSI_arr[2]&&MOSI_arr[3]){
			if(count==20) //when the state is read data and we finish reading the SS_n will equal 1 to end the communication
				SS_n==1;
			else 
				SS_n==0;
		} 
		else {
			if(count==12) //when we finish states the SS_n will equal 1 to end the communication
				SS_n==1;
			else 
				SS_n==0;
		}
	}

	constraint tx_valid_c {
		//if the state is read data and we finish send the dummy bits the tx_valid should be active
		if((MOSI_arr[2]&&MOSI_arr[3])&&(count>11))
			tx_valid==1;
		else
			tx_valid==0;
	}

	constraint MOSI_arr_prop {
		MOSI_arr[1] dist {0:/50,1:/50};
		MOSI_arr[2] == MOSI_arr[1];
		if(MOSI_arr[2]){//if the bit 9 equal 1 [Read operation]
			if(rd_flag)//if we read address
				MOSI_arr[3]==1;//We will Read date
			else
				MOSI_arr[3]==0;//We will Read address
		}
		else//[Write operation]
			MOSI_arr[3] dist {0:/60,1:/40};
	}

	constraint MOSI_prop {
		MOSI==MOSI_arr[count];//MOSI reflects the current bit of MOSI_arr based on count
	}

	function void pre_randomize();
		if(count==0)//Enable the randomization of the array at the idle state
			MOSI_arr.rand_mode(1);
		else
			MOSI_arr.rand_mode(0);

		if((MOSI_arr[2]&&MOSI_arr[3])&&(count==20))//Enable the randomization of the tx_data at the end of the read data
			tx_data.rand_mode(1);
		else
			tx_data.rand_mode(0);

		/*befor the randomization we shold know the state of the rd_flag*/
		if(rst_n==ACTIVE_RESET)
			rd_flag=0;
		else if(count==0) begin//At the beginning when the count equal zero we will check the rd flag
			if(MOSI_arr[2]&&MOSI_arr[3])//READ_DATA
				rd_flag=0;
			else if (MOSI_arr[2]&&!MOSI_arr[3])//READ_ADD
				rd_flag=1;
		end

	endfunction : pre_randomize

	function void post_randomize();
		//Update the counter after every randomization 
		if(SS_n||rst_n==ACTIVE_RESET)
			count=0;
		else
			count++;
		

	endfunction : post_randomize

	endclass : slave_seq_item
endpackage : slave_seq_item_pkg