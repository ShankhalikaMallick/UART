`timescale 1ps / 1ps
`include "tx.v"
module tx_tb;

    reg        clk;
    reg        reset;
    reg        tx_start;
    reg [7:0]  tx_data_in;
    wire       tx_data_out;

    // Instantiate DUT
    uart_tx dut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data_in(tx_data_in),
        .tx_data_out(tx_data_out)
    );

    // Clock generation (10 ps period)
    always #5 clk = ~clk;

initial begin
    $dumpfile("tx_tb.vcd");   // VCD file name
    $dumpvars(0, tx_tb);   // dump everything in testbench hierarchy
end

    initial begin
        // Initialize
        clk        = 0;
        reset      = 1;
        
        tx_data_in = 8'h00;

        $display("Time | tx_data_out");
        $monitor("%4t |      %b", $time, tx_data_out);

        // Apply reset
        #10 reset = 0;

        // Apply transmit data
        // Example byte: 8'b1010_1101
        #10 tx_data_in = 8'b10101101;
        tx_start = 1;
        #10;
        tx_start = 0;

        /*
            Expected UART Frame (LSB first):

            Start bit  : 0
            Data bits  : 1 0 1 1 0 1 0 1
            Parity bit : ^(10101101) = 1 (even parity)
            Stop bit   : 1
        */

        // Wait long enough to transmit full frame
        // START(1) + DATA(8) + PARITY(1) + STOP(1) = 11 clock cycles
        #200; #200;

        // End simulation
        $finish;
    end

endmodule
