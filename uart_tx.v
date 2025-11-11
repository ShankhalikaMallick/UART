`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:23:36
// Design Name: 
// Module Name: uart_tx
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


`include "tx_fsm.v"
`include "tx_mux.v"
`include "tx_piso.v"
`include "tx_parity.v"

module uart_tx(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data_in, 
    output tx_data_out,
    output tx_busy );

    wire parity_out;
    wire piso_op;
    wire [1:0] sel;
    wire piso_load;
    wire piso_shift;
    wire parity_load;

    tx_mux tx1 ( sel, piso_op, parity_out, tx_data_out );
    tx_parity tx2 (clk, reset, parity_load, tx_data_in );
    tx_piso tx3 (clk, reset, piso_load, piso_shift, tx_data_in, piso_op );
    tx_fsm tx4 ( clk, reset, tx_start, sel, piso_load, piso_shift, parity_load, tx_busy); 

endmodule
