`timescale 1ps/1ps
`include "brg.v"

module tb_uart_baud_gen;

    // Testbench signals
    reg clk;
    reg reset;
    wire tx_tick;
    wire rx_tick;

    // Instantiate the DUT
    brg dut ( clk, reset, tx_tick, rx_tick);
    // --------------------------------------------------
    // 16 MHz clock generation
    // Period = 62.5 ns
    // --------------------------------------------------
    initial begin
        clk = 0;
        reset=1'b1;
        #1; reset=1'b0;
        $monitor("%b, %b, %b, %b",clk, reset,tx_tick, rx_tick);
        #20000;
        #20000;
        #20000;
        #20000; $finish;
    end
    always 
    #0.001 clk <= !clk;

endmodule
