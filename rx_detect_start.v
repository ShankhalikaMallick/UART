`timescale 1ns / 1ps
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


module rx_detect_start(
    input rx_in,
    output strt_bit );

    assign strt_bit= !(rx_in);
    // if input is 0 then start
    
endmodule
