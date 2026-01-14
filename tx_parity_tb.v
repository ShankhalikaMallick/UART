`timescale 1ps / 1ps
`include "tx_parity.v"
module tx_parity_tb;

    // Testbench signals
    reg        clk;
    reg        reset;
    reg        parity_load;
    reg [7:0]  data;
    wire       parity_out;

    // Instantiate DUT
    tx_parity dut (
        .clk(clk),
        .reset(reset),
        .data(data),
        .parity_load(parity_load),
        .parity_out(parity_out)
    );

    // Clock generation: 10 ps period
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk         = 0;
        reset       = 1;
        parity_load = 0;
        data        = 8'h00;

        // Monitor values
        $monitor("Time=%0t | reset=%b | load=%b | data=%b | parity_out=%b",
                  $time, reset, parity_load, data, parity_out);

        // Release reset
        #12 reset = 0;

        // Test case 1: even number of 1s → parity = 0
        #10 data = 8'b1010_1010; // 4 ones
            parity_load = 1;
        #10 parity_load = 0;

        // Hold parity (no load)
        #20 data = 8'b1111_1111; // change data, parity should not change

        // Test case 2: odd number of 1s → parity = 1
        #10 data = 8'b1000_0000; // 1 one
            parity_load = 1;
        #10 parity_load = 0;

        // Test case 3: all zeros → parity = 0
        #10 data = 8'b0000_0000;
            parity_load = 1;
        #10 parity_load = 0;

        // Finish simulation
        #20 $finish;
    end

endmodule
