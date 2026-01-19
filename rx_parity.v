`timescale 1ps / 1ps
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


module rx_parity(
    input        reset,
    input        parity_in,      // received parity bit
    input  [7:0] data_in,        // received data byte
    input        parity_load,   // asserted for 1 cycle by RX FSM
    output reg   parity_error
);

    always @(posedge parity_load or posedge reset) begin
        
        if (reset) begin
            parity_error <= 1'b0;
        end
        else if (parity_load) begin
            // even parity check
            if (parity_in == ^(data_in))
            parity_error = 0;
            else 
            parity_error = 1;
        end
    end

endmodule
