////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: SLAVE_Golden
// Date: December, 2024 
////////////////////////////////////////////////////////////////////////////////
import slave_shared_pkg::*;
module SPI_SLAVE (MOSI,MISO,SS_n,rx_data,rx_valid,tx_data,tx_valid,clk,rst_n );
input MOSI,SS_n,tx_valid,clk,rst_n;
input [7:0] tx_data;
output rx_valid;
output reg MISO;
output reg [9:0] rx_data;
reg internal_signal;

STATE_e cs,ns;
reg [4:0]counter1,counter2;
wire done_count ;
assign done_count =(counter1>=10)? 1:0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    always @(*) begin
        case (cs)
            IDLE: begin
                if (SS_n )
                    ns = IDLE;
                else
                    ns = CHK_CMD;
            end
            CHK_CMD: begin
                if (SS_n == 0 && MOSI == 0)
                    ns = WRITE;
                else if (SS_n == 0 && MOSI == 1 && internal_signal == 0)
                    ns = READ_ADD;
                else if (SS_n == 0 && MOSI == 1 && internal_signal == 1)
                    ns = READ_DATA;
                else
                    ns = IDLE;
            end
            WRITE: begin
                if (SS_n )
                    ns = IDLE;
                else
                    ns = WRITE;
                end
            READ_ADD: begin
                if (SS_n )
                    ns = IDLE;
                else
                    ns = READ_ADD;
                end
            READ_DATA: begin
                if (SS_n )
                    ns = IDLE;
                else
                    ns = READ_DATA;
            end
            default: ns = IDLE;
        endcase
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin 
            rx_data<=0;     
            counter1 <= 0;
            internal_signal <= 0;
            counter2<=0;
        end 
        else begin
            case (cs)
                IDLE: begin
                    counter1 <= 0;
                    counter2<=0;
                    MISO <= 0;
                end
                CHK_CMD: begin
                    counter1<=0;
                    counter2<=0;                   
                end
                WRITE: begin
                    if (counter1<=9) begin
                        rx_data[9-counter1] <= MOSI;
                        counter1 <= counter1 + 1;
                    end                
                end
                READ_ADD: begin
                    if (counter1<=9) begin
                        internal_signal <= 1;
                        rx_data[9-counter1] <= MOSI;
                        counter1 <= counter1 + 1;
                    end                           
                end
                READ_DATA : begin
                    if (counter1>9)begin
                        if (tx_valid==1&&counter2<8) begin
                            MISO <= tx_data[7-counter2];
                            counter2<=counter2+1;
                        end      
                        else if (tx_valid==0&&counter2==8) 
                            internal_signal <= 0;   
                    end
                    else begin
                        rx_data[9-counter1] <= MOSI;
                        counter1<=counter1+1;
                    end         
                end
                default: begin
                    counter1<=0;
                    internal_signal<=0;
                end
            endcase
        end
    end
    assign rx_valid =((cs==WRITE||cs==READ_ADD||cs==READ_DATA)&&done_count)?1:0;
endmodule