`timescale 1ps/1ps
`include "tx_piso.v"
module tx_piso_tb;

    // Testbench signals
    reg        clk;
    reg        reset;
    reg        load;
    reg        shift;
    reg [7:0]  data;
    wire       piso_out;

    // Instantiate DUT
    tx_piso dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .shift(shift),
        .data(data),
        .piso_out(piso_out)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk   = 0;
        reset = 1;
        load  = 0;
        shift = 0;
        data  = 8'h00;

        // Monitor output
        $monitor("Time=%0t | load=%b | shift=%b | data=%b | piso_out=%b",
                  $time, load, shift, data, piso_out);

        // Release reset
        #12 reset = 0;

        // Load data into PISO
        #10 data = 8'b1010_1101;
            load = 1;
        #10 load = 0;

        // Shift out bits (LSB first)
        repeat (8) begin
            #10 shift = 1;
            #10 shift = 0;
        end

        // Hold (no shift)
        #20 shift = 0;

        // End simulation
        #20 $finish;
    end

endmodule
