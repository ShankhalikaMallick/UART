`timescale 1ps / 1ps
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


module rx_stop(
    input        reset,
    input        chk_stop,          // fsm pointer that now we ave to stop receiving
    input        rx_data_in,       // sampled RX line at stop-bit time
    output reg   stop_bit_error
);

    always @(posedge chk_stop or posedge reset) begin
        if (reset) begin
            stop_bit_error <= 1'b0;
        end
        else begin
            if (chk_stop==1) begin
                if( rx_data_in == 1'b1)
                    stop_bit_error = 0;
                else
                    stop_bit_error = 1;
            end
        end
    end

endmodule
