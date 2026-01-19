`timescale 1ps / 1ps
`include "rx_start.v"
module tb_rx_detect_start;

    reg clk;
    reg reset;
    reg rx_in;
    wire strt_bit;

    // DUT
    rx_start dut (
        .clk(clk),
        .reset(reset),
        .rx_in(rx_in),
        .strt_bit(strt_bit)
    );

    // Clock (10 ps)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("rx_start.vcd");
        $dumpvars(0, tb_rx_detect_start);
        $monitor($time, "\t %b", strt_bit);
        clk = 0;
        reset = 1;
        rx_in = 1;   // idle

        #10 reset = 0;

        // idle
        #20 rx_in = 1;

        // falling edge = START
        #20 rx_in = 0;

        // stay low (data bit 0) → no retrigger
        #40 rx_in = 0;

        // rising edge (stop bit)
        #20 rx_in = 1;

        // data 0 again → no false start
        #20 rx_in = 0;

        // valid new start
        #20 rx_in = 1;
        #20 rx_in = 0;

        #50 $finish;
    end

endmodule
