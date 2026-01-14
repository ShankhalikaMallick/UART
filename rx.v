`timescale 1ns / 1ps
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

 `include "rx_detect_start.v"
 `include "rx_parity_check.v"
 `include "rx_sipo.v"
 `include "rx_stop_bit.v"
 `include "rx_fsm.v"

module uart_rx(
    input clk,
    input reset,
    input rx_data_in,
    output [7:0] rx_data_out,
    output parity_error,
    output stop_error,
    output rx_done    );
    
    wire strt_bit;
    wire [9:0] sipo_out;
    wire parity_load;
    wire [7:0] parity_out;
    wire sample_done;
    wire run_shift;
    wire chk_stop;
    wire stop_bit_err;
    
    assign rx_done= chk_stop;       // output is checked at the end state
    
    rx_detect_start rx1(rx_data_in, strt_bit);
    rx_sipo rx2(clk, reset, rx_data_in, sample_done, run_shift, sipo_out);
    rx_parity_check rx3 (sipo_out[9], sipo_out[7:0], parity_load, parity_error, parity_out);
    rx_stop_bit rx4 (sipo_out[9], parity_out, chk_stop, stop_error, rx_data_out);
    rx_fsm rx5(clk, reset, strt_bit, run_shift, parity_load, parity_error, chk_stop, sample_done);
    
endmodule
