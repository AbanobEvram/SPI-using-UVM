////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: RAM_shared_pkg
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package RAM_shared_pkg;
	parameter MEM_DEPTH = 256 ;
	parameter ADDR_SIZE = $clog2(MEM_DEPTH) ;

	parameter WRITE_ADD=0;
	parameter WRITE_DATA=1;
	parameter READ_ADD=2;
	parameter READ_DATA=3;

	parameter RX_VALID_ON_DIST=90;
	parameter RESET_ON_DIST=5;

	parameter ACTIVE=1;
	parameter INACTIVE=0;

	parameter ACTIVE_RESET=0;
	parameter INACTIVE_RESET=1;
endpackage : RAM_shared_pkg