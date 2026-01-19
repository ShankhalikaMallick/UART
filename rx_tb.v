
`timescale 1ps / 1ps
`include "rx.v"

module tb_uart_rx;

    reg clk;
    reg reset;
    reg rx_data_in;

    wire [7:0] rx_data_out;
    wire parity_error;
    wire stop_error;

    // --------------------------------------------------
    // Instantiate DUT
    // --------------------------------------------------
    uart_rx dut (
        .clk(clk),
        .reset(reset),
        .rx_data_in(rx_data_in),
        .rx_data_out(rx_data_out),
        .parity_error(parity_error),
        .stop_error(stop_error)
    );

    // --------------------------------------------------
    // Clock generation
    // --------------------------------------------------
    always #10 clk = ~clk;   // 20 ps period (slow & visible)

    // --------------------------------------------------
    // Dump for GTKWave
    // --------------------------------------------------
    initial begin
        $dumpfile("uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);
    end

    // --------------------------------------------------
    // UART send task (RX stimulus)
    // --------------------------------------------------
    task send_uart_byte(input [7:0] data);
        integer i;
        reg parity;
    begin
        parity = ^data;  // EVEN parity

        // Start bit
        rx_data_in = 0;
        #20;

        // Data bits (LSB first)
        for (i = 0; i < 8; i = i + 1) begin
            rx_data_in = data[i];
            #20;
        end

        // Parity bit
        rx_data_in = parity;
        #20;

        // Stop bit
        rx_data_in = 1;
        #20;
    end
    endtask

    // --------------------------------------------------
    // Monitor
    // --------------------------------------------------
    initial begin
        $display("Time | RX | Data | ParErr | StopErr");
        $monitor("%4t |  %b |  %h  |   %b    |   %b",
                  $time, rx_data_in, rx_data_out, parity_error, stop_error);
    end

    // --------------------------------------------------
    // Test sequence
    // --------------------------------------------------
    initial begin
        clk = 0;
        reset = 1;
        rx_data_in = 1;   // idle high

        #50;
        reset = 0;

        // -------- Test 1 --------
        #40;
        send_uart_byte(8'hAD);   // 10101101

        #200;

        // -------- Test 2 --------
        send_uart_byte(8'h3C);   // 00111100

        #200;

        // -------- Test 3 --------
        send_uart_byte(8'hE1);   // 11100001

        #200;

        $finish;
    end

endmodule
