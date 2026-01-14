`timescale 1ps / 1ps
`include "tx_fsm.v"
module tx_fsm_tb;

    // Testbench signals
    reg        clk;
    reg        reset;
    wire [1:0] sel;
    wire       load;
    wire       shift;
    wire       parity_load;

    // Instantiate DUT
    tx_fsm dut (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .load(load),
        .shift(shift),
        .parity_load(parity_load)
    );

    // Clock generation (10 ps period)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk   = 0;
        reset = 1;

        // Display header
        $display("Time | reset | sel | load | shift | parity_load");
        $monitor("%4t |   %b   |  %b  |  %b   |   %b   |      %b",
                  $time, reset, sel, load, shift, parity_load);

        // Apply reset
        #12 reset = 0;

        /*
            FSM behavior expectation:
            START  : 1 cycle
            DATA   : 8 cycles (shift asserted)
            PARITY : 1 cycle
            STOP   : 1 cycle
            Then repeat
        */

        // Run long enough to see one full UART frame
        #150;

        // Assert reset again mid-operation (robustness check)
        reset = 1;
        #10 reset = 0;

        // Run again
        #100;

        $finish;
    end

endmodule
