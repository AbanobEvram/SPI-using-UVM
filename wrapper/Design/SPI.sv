////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Design
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import wrapper_shared_pkg::*;
module SLAVE(MOSI, SS_n, clk, rst_n, tx_valid,MISO,rx_valid,rx_data,tx_data);

 input MOSI, SS_n, clk, rst_n, tx_valid;
 input [ADDR_SIZE-1:0] tx_data;
 output reg [ADDR_SIZE+1:0] rx_data;
 output reg MISO; 
 output rx_valid;

(* fsm_encoding = "one_hot" *) 

 STATE_e cs,ns;
 reg rd_add_signal; 

 integer count_rx,count_tx;

 //MEM stage
 always @(posedge clk or negedge rst_n) begin
 	if (~rst_n) 
 		cs<=IDLE;		
 	else
 		cs<=ns;
 end

 //Next stage logic
 always @(*) begin
 	case(cs)
 		IDLE: begin
 			if(~SS_n)
 				ns=CHK_CMD;
 			else
 				ns=IDLE;		
 		end
 		CHK_CMD: begin
            if(SS_n==0&&MOSI==0)
                ns = WRITE;
            else if(SS_n==0&&MOSI==1&&rd_add_signal==0)
                ns = READ_ADD;
            else if(SS_n==0&&MOSI==1&&rd_add_signal==1)
                ns = READ_DATA;
            else
                ns = IDLE;                     
 		end
 		WRITE: begin
 			if(~SS_n)
 				ns=WRITE;
 			else
 				ns=IDLE;	
 		end
 		READ_ADD: begin
 			if(~SS_n)
 				ns=READ_ADD;
 			else	
 				ns=IDLE;
 		end
 		READ_DATA: begin
 			if(~SS_n)
 				ns=READ_DATA;
 			else
 				ns=IDLE;	
 		end
 	endcase
 end

 //output logic
 always @(posedge clk or negedge rst_n) begin
 	if (~rst_n) begin
 		rd_add_signal<=0;
        rx_data<=0;
        count_tx<=0;
        count_rx<=0;
 	end
 	else begin
 		case(cs)
 	 		IDLE: begin
				MISO<=0;
                count_tx<=0;
                count_rx<=0;  
 			end
 			CHK_CMD: begin
                count_tx<=0;
                count_rx<=0;  
 			end
 			WRITE: begin
 				if(count_rx<=9) begin
 					rx_data[9-count_rx]<=MOSI;
                    count_rx<=count_rx+1;
                end
 			end
 			READ_ADD: begin
                if(count_rx<=9) begin
                    rx_data[9-count_rx]<= MOSI;
                    count_rx<=count_rx+1;
                    rd_add_signal<=1;
                end		
 			end
 			READ_DATA: begin
                if(count_rx>9) begin
                    if(tx_valid==1&&count_tx<8) begin
                        MISO <= tx_data[7-count_tx];
                        count_tx<=count_tx+1;
                    end
                    else if(tx_valid==1&&count_tx>=8)begin
                        rd_add_signal <= 0;
		            end
                end    
                else begin
                    rx_data[9-count_rx]<= MOSI;
                    count_rx<=count_rx+1;
                end       		
        	end		
 		endcase		
 	end
 end
 assign rx_valid =((cs==WRITE||cs==READ_ADD||cs==READ_DATA)&&count_rx>9)?1:0 ;
endmodule