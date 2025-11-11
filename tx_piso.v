`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:29:03
// Design Name: 
// Module Name: tx_piso
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


module tx_piso(
    input clk,
    input reset,
    input load,
    input shift,
    input [7:0] piso_in,
    output piso_out );

    reg [7:0]temp;

    assign piso_out= temp[0];

    always @(posedge clk, posedge reset)
    begin
        if(reset)
            temp <= 0;
        else
        begin
            if(load)
                temp <= piso_in;
            else
            begin
                if(shift)
                    temp <= {1'b0, temp[7:1]};
                else
                    temp <= temp;
            end
        end 
    end

endmodule
