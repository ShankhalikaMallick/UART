`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 17:06:36
// Design Name: 
// Module Name: uart_rx
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

 `include "rx_start.v"
 `include "rx_parity.v"
 `include "rx_sipo.v"
 `include "rx_stop.v"
 `include "rx_fsm.v"

module uart_rx(
    input clk,
    input reset,
    input rx_data_in,
    output [7:0] sipo_out,
    output parity_error,                 // shows if transmitter and receiver have same parity bit
    output stop_error);
    
    wire start;                           // checks for start
    wire strt_bit;
    wire shift;                          // start converting the serial packet to parallel
    wire parity_load;                    // load the data for parity checking
    wire chk_stop;
    wire data_valid;
    wire stop_bit_err;
        
    rx_start rx1( start, reset, rx_data_in, strt_bit);
    rx_sipo rx2( clk, reset, rx_data_in, shift, sipo_out[7:0], data_valid);
    rx_parity rx3 (reset, rx_data_in, sipo_out[7:0], parity_load, parity_error);
    rx_stop rx4 (reset, chk_stop, rx_data_in, stop_error);
    rx_fsm rx5(clk, reset, strt_bit, data_valid, parity_error, stop_error, start, shift, parity_load, chk_stop);
    
endmodule
