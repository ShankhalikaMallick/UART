`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:20:39
// Design Name: 
// Module Name: rx_stop_bit
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


module rx_stop_bit(
    input stop_bit_in,
    input [7:0] data_in,
    input chk_stop,             // enable signal for stop bit checker
    output stop_bit_error,
    output [7:0] data_out );

    assign stop_bit_error= chk_stop && (!stop_bit_in);
    assign data_out= stop_bit_error ? 0: data_in;

endmodule
