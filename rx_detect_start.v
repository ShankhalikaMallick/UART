`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:16:47
// Design Name: 
// Module Name: rx_detect_start
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rx_start(
    input  start,       // NEW: here start from fsm 
    input  reset,
    input  rx_in,
    output reg strt_bit
);


    always @( posedge reset or negedge rx_in) 
    begin
        if (reset) begin
            strt_bit <= 1'b0;
        end
        else 
        if((start==1)&&(rx_in==0))
                strt_bit <= 1'b1;
        else
        strt_bit=0;
    end

endmodule
