`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:18:45
// Design Name: 
// Module Name: rx_parity_check
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


module rx_parity_check(
    input parity_in,
    input [7:0] data_in,
    input parity_load,
    output parity_error,
    output [7:0] data_out );

    assign parity_error = parity_load && ( parity_in != (^ data_in));
    assign data_out = parity_error? 0: data_in;

endmodule
