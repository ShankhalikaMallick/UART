`timescale 1ps / 1ps
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
    input        rx_clk,
    input        reset,
    input        rx_in,
    input        shift,          // asserted once per bit-time
    output reg [7:0] data_out,
    output reg       data_valid   // goes high after 8 bits
);
    
    reg [3:0] bit_cnt;
    reg [3:0] counter;

    always @( posedge rx_clk or posedge reset) begin
        if (reset) begin
            data_out   <= 8'b0;
            data_valid <= 1'b0;
            bit_cnt    <= 4'b0;
            counter    <= 4'b0;
        end 
        else 
        begin
            if (shift==1) 
            begin
                bit_cnt <= bit_cnt +1'b1;
                // UART = LSB first
                if (bit_cnt == 4'b1000)
                begin
                    data_out <= {rx_in, data_out[7:1]};
                    counter  <= counter +1'b1;
                end
                if (counter == 4'b1001) 
                begin
                    data_valid <= 1'b1; // byte complete
                    counter    <= 4'b0;
                    bit_cnt    <= 4'b0;
                end
            end
        end
    end
       

endmodule
