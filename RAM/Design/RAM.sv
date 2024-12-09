////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_Design
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import RAM_shared_pkg::*;
module RAM(din,clk,rst_n,rx_valid,dout,tx_valid);
 input [ADDR_SIZE+1:0] din;
 input clk,rst_n,rx_valid;
 output reg [ADDR_SIZE-1:0] dout;
 output reg tx_valid; 
 reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
 reg [ADDR_SIZE-1:0] wr_addr,rd_addr;
 
 always @(posedge clk or negedge rst_n) begin
 	if (~rst_n) begin
 		tx_valid<=0;
 		wr_addr<=0;
 		rd_addr<=0;
 	end

 	else begin
 		if(rx_valid) begin
 			tx_valid<=(din[9]&din[8]&rx_valid)?1:0;
 			case(din[9:8])
 				2'b00:wr_addr<=din[ADDR_SIZE-1:0];
 				2'b01:mem[wr_addr]<=din[ADDR_SIZE-1:0];
 				2'b10:rd_addr<=din[ADDR_SIZE-1:0];
 				2'b11:dout<=mem[rd_addr];
 			endcase
 		end	
 	end 
 end
endmodule