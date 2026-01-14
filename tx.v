`timescale 1ps / 1ps 
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
    input [7:0] tx_data_in,                 // input data of 8 bits
    output tx_data_out);                    // packet of 11 bits given as output including start , data, parity and stop bits 

    wire parity_bit;
    wire data_bit;
    wire [1:0] sel;
    wire piso_load;
    wire parity_load;
    wire piso_shift;

    tx_mux tx1 ( sel, data_bit, parity_bit, tx_data_out );
    tx_parity tx2 (clk, reset, tx_data_in, parity_load, parity_bit );
    tx_piso tx3 (clk, reset, piso_load, piso_shift, tx_data_in, data_bit );
    tx_fsm tx4 ( clk, reset,tx_start, sel, piso_load, piso_shift, parity_load); 

endmodule
