`timescale 1ps / 1ps
`include "rx_stop.v"
module tb_rx_stop_bit;

    reg        clk;
    reg        reset;
    reg        stop_bit_in;
    reg        chk_stop;
    reg [7:0]  sipo_out;

    wire       stop_bit_error;
    wire [7:0] rx_data_out;

    // DUT
    rx_stop dut (
        .clk(clk),
        .reset(reset),
        .stop_bit_in(stop_bit_in),
        .chk_stop(chk_stop),
        .sipo_out(sipo_out),
        .stop_bit_error(stop_bit_error),
        .rx_data_out(rx_data_out)
    );

    // --------------------------------------------------
    // Clock generation (10 ps period)
    // --------------------------------------------------
    always #5 clk = ~clk;

    initial begin
        // Dump for GTKWave
        $dumpfile("rx_stop_bit.vcd");
        $dumpvars(0, tb_rx_stop_bit);

        $display("Time | chk | stop | error | rx_data");
        $monitor("%4t |  %b  |  %b   |   %b   | %h",
                  $time, chk_stop, stop_bit_in, stop_bit_error, rx_data_out);

        // --------------------------------------------------
        // Init
        // --------------------------------------------------
        clk         = 0;
        reset       = 1;
        chk_stop    = 0;
        stop_bit_in = 1;
        sipo_out    = 8'h00;

        #12 reset = 0;

        // --------------------------------------------------
        // Case 1: chk_stop LOW → nothing happens
        // --------------------------------------------------
        sipo_out    = 8'hA5;
        stop_bit_in = 0;
        chk_stop    = 0;
        #20;

        // --------------------------------------------------
        // Case 2: Valid stop bit (1)
        // --------------------------------------------------
        sipo_out    = 8'h3C;
        stop_bit_in = 1;
        chk_stop    = 1;
        #10;                // one clock edge
        chk_stop    = 0;
        #20;

        // --------------------------------------------------
        // Case 3: Stop bit error (0)
        // --------------------------------------------------
        sipo_out    = 8'hF0;
        stop_bit_in = 0;
        chk_stop    = 1;
        #10;
        chk_stop    = 0;
        #20;

        // --------------------------------------------------
        // Case 4: Inputs change, outputs stay latched
        // --------------------------------------------------
        sipo_out    = 8'h55;
        stop_bit_in = 1;
        #30;

        // --------------------------------------------------
        // Case 5: Reset clears error
        // --------------------------------------------------
        reset = 1;
        #10;
        reset = 0;
        #20;

        $finish;
    end

endmodule
