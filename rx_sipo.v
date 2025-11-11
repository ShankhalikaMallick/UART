`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:19:53
// Design Name: 
// Module Name: rx_sipo
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


module rx_sipo (
    input clk,
    input reset,
    input rx_in,
    input sample_done,
    input shift,
    output [9:0] data_out );

    reg [9:0] temp;

    assign data_out=temp;
    
    always@(posedge clk, posedge reset)
    begin
        if(reset)
            temp<=0;
        else
        begin
            if(shift==1)
            begin
                if(sample_done)
                    temp <= {rx_in, temp[9:1]};
                else
                    temp <= temp;
            end
            else
                temp <= temp;
        end
    end

endmodule
