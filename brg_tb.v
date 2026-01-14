`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 17:22:04
// Design Name: 
// Module Name: brg
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

module brg(
    input  clk_in,
    input  reset,
    output reg txclk,
    output reg rxclk
); 
    /* 
    system clock frequency = 16 MHz
    transmitter clock frequency at 9600 baud rate = 16000000/9600 ≈ 1667 MHz
    receiver must have oversampling of 16X
    receiver clock frequency at 9600*16 baud rate = 16000000/(9600*16) ≈ 104 MHz
    */
    
    // Baud rate parameters
    localparam integer BAUD     = 9600;
    localparam integer FREQ     = 1000000;
    localparam integer OVS      = 16;

    // Divisors
    localparam integer TX_DIV   = 1667;
    localparam integer RX_DIV   = 104;

    reg [11:0] txcount = 0;    // 1667 is of 11 bits in binary
    reg [6:0] rxcount = 0;     // 104 is of 7 bits in binary

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            txcount <= 0;
            rxcount <= 0;
            txclk    <= 0;
            rxclk    <= 0;
        end 
        else 
        begin
            //---------- RX COUNTER ----------
            if (rxcount == RX_DIV-1) begin
                rxcount <= 0;
                rxclk   <= 1'b1;
            end else begin
                rxcount <= rxcount + 1'b1;
                rxclk    <= 0;
            end

            //---------- TX COUNTER ----------
            
            if (txcount == TX_DIV-1) begin
                txcount <= 0;
                txclk   <= 1'b1;       // txclk becomes 1 this cycle , becomes 0 in the next cycle
            end else begin
                txcount <= txcount + 1'b1;
                txclk   <= 0;
            end
            

        end
    end
endmodule
