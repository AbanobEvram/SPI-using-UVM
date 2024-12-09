////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Shared
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
package slave_shared_pkg;
    localparam MEM_DEPTH = 256;
    localparam ADDR_SIZE = $clog2(MEM_DEPTH);
    
    typedef enum bit [2:0] {IDLE,CHK_CMD,WRITE,READ_ADD,READ_DATA} STATE_e;

    typedef enum bit [2 : 0] {IDLE_COV, WRITE_ADD_COV, WRITE_DATA_COV, READ_ADD_COV, READ_DATA_COV} STATE_COV_e;
    STATE_COV_e cs_cov;

    parameter RX_VALID_ON_DIST=90;
    parameter RESET_ON_DIST=1;

    parameter ACTIVE=1;
    parameter INACTIVE=0;

    parameter ACTIVE_RESET=0;
    parameter INACTIVE_RESET=1;
endpackage : slave_shared_pkg