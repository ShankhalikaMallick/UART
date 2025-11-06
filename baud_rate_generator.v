module baud_rate_generator( 
    input clk,  
    input reset,
    output rx_en,
    output tx_en);

    reg [13:0] tx_count;
    reg [9:0] rx_count;
    parameter freq= 50000000;
    parameter baudrate= 9600;
    parameter divisor= freq / (baudrate*16);

    always @(posedge clk or posedge reset)
    begin
        if(reset==1) 
        begin
            rx_count=0;
            tx_count=0;
        end
        else
        begin
        /// setting receiver enable
            if (rx_count == 325)
                rx_count=0;
            else 
                rx_count = rx_count + 1'b1;
                
        /// setting transmitter enable
            if (tx_count == 5208)
                tx_count=0;
            else 
                tx_count = tx_count + 1'b1;
        end
    end
    assign rx_en = rx_count==0? 1'b1 : 1'b0;
    assign tx_en = tx_count==0? 1'b1 : 1'b0;

endmodule
