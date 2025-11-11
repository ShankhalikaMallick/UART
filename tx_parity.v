`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:22:01
// Design Name: 
// Module Name: tx_parity
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


module tx_parity(
    input clk,
    input reset,
    input [7:0] parity_data_in,
    input parity_load,
    output reg parity_out );

    always @(posedge clk, posedge reset)
    begin
        if(reset)
            parity_out<=0;
        else
        begin
            if(parity_load)
                parity_out <=^(parity_data_in);
            else
                parity_out <= parity_out;
        end
    end
endmodule
