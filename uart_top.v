`timescale 1ps / 1ps

`include "brg.v"
`include "tx.v"

module uart_top;

    // --------------------------------------------------
    // Testbench signals
    // --------------------------------------------------
    reg        sys_clk;        // 16 MHz system clock
    reg        reset;
    reg        tx_start;
    reg [7:0]  tx_data_in;

    wire       tx_tick;
    wire       rx_tick;
    wire       tx_data_out;

    // --------------------------------------------------
    // System clock: 16 MHz (62.5 ns period)
    // --------------------------------------------------
    always #1 sys_clk = ~sys_clk;

    // --------------------------------------------------
    // Baud Rate Generator
    // --------------------------------------------------
    brg obj1 (
        .clk_in(sys_clk),
        .reset(reset),
        .txclk(tx_tick),
        .rxclk(rx_tick)
    );

    // --------------------------------------------------
    // UART Transmitter
    // NOTE: UART clock driven by tx_tick
    // --------------------------------------------------
    uart_tx obj2 (
        .clk(tx_tick),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data_in(tx_data_in),
        .tx_data_out(tx_data_out)
    );

    // --------------------------------------------------
    // Dump for GTKWave
    // --------------------------------------------------
    initial begin
        $dumpfile("uart_top.vcd");
        $dumpvars(0, uart_top);
    end

    // --------------------------------------------------
    // Test sequence
    // --------------------------------------------------
    initial begin
        // Init
        sys_clk    = 0;
        reset      = 1;
        tx_data_in = 8'h00;

        $display("Time | tx_data_out");
        $monitor($time, " %8b",  tx_data_out);

        // Reset pulse
        #200;
        reset = 0;

        // Wait a bit
        #500;

        // Transmit one byte
        tx_data_in = 8'b10101101;
        tx_start=1;
        #8000; tx_start=0;
        // Wait long enough for full UART frame
        // 11 bits × baud period
        #50000;

        tx_data_in = 8'b11100011;
        tx_start=1;
        #8000; tx_start=0;
        // End simulation
        #50000;

        tx_data_in = 8'b10110010;
        tx_start=1;
        #8000; tx_start=0;
        // End simulation
        #50000;
        $finish;
    end

endmodule
