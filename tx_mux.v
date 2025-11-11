`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:21:13
// Design Name: 
// Module Name: tx_mux
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


module tx_mux (
    input [1:0] select,
    input data_bit,
    input parity_bit,
    output reg tx_out );

    always @(select, data_bit, parity_bit)
    begin
        case (select)
            2'b00: tx_out=1'b0;
            2'b01: tx_out=data_bit;
            2'b10: tx_out=parity_bit;
            2'b11: tx_out=1'b1;
        endcase
    end

endmodule
