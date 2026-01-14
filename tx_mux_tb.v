`timescale 1ps/1ps
`include "tx_mux.v"
module tx_mux_tb;

    // Testbench signals
    reg  [1:0] select;
    reg        data_bit;
    reg        parity_bit;
    wire       tx_out;

    // Instantiate the DUT (Device Under Test)
    tx_mux dut (
        .select(select),
        .data_bit(data_bit),
        .parity_bit(parity_bit),
        .tx_out(tx_out)
    );

    initial begin
        // Initialize inputs
        select     = 2'b00;
        data_bit   = 1'b0;
        parity_bit = 1'b0;

        // Monitor changes
        $monitor("Time=%0t | select=%b | data=%b | parity=%b | tx_out=%b",
                  $time, select, data_bit, parity_bit, tx_out);

        // Test start bit
        #10 select = 2'b00;

        // Test data bit = 0
        #10 select = 2'b01; data_bit = 1'b0;

        // Test data bit = 1
        #10 data_bit = 1'b1;

        // Test parity bit = 0
        #10 select = 2'b10; parity_bit = 1'b0;

        // Test parity bit = 1
        #10 parity_bit = 1'b1;

        // Test stop bit
        #10 select = 2'b11;

        // End simulation
        #10 $finish;
    end

endmodule
