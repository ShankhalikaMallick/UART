`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:15:11
// Design Name: 
// Module Name: uart
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


`include "uart_tx.v"
`include "uart_rx.v"
`include "brg.v"

module uart(
    input clk,
    input reset,
    input tx_start,
    input [7:0] data_in,
    output tx_busy,
    output [7:0] data_out,
    output pariy_error,
    output stop_error,
    output op_valid );

    wire tx_data_out, clk1, clk2;

    brg ob1(clk,reset,clk1, clk2);
    uart_rx ob2(clk1, rst, tx_data_out, data_out, pariy_error, stop_error, op_valid);
    uart_tx ob3(clk2, reset, tx_start,data_in, tx_data_out, tx_busy);

endmodule
