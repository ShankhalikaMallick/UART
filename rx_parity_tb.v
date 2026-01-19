`timescale 1ps/1ps
`include "rx_parity.v"
module rx_parity_tb;

    reg        clk;
    reg        reset;
    reg        parity_in;
    reg [7:0]  data_in;
    reg        parity_check;

    wire       parity_error;

    rx_parity dut (
        .clk(clk),
        .reset(reset),
        .parity_in(parity_in),
        .data_in(data_in),
        .parity_check(parity_check),
        .parity_error(parity_error)
    );

    // 10 ps clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("rx_parity_check.vcd");
        $dumpvars(0, rx_parity_tb);

        clk          = 0;
        reset        = 1;
        parity_check = 0;
        parity_in    = 0;
        data_in      = 8'h00;

        #20 reset = 0;

        // ------------------------------------------------
        // Case 1: Correct parity
        // data = 10101101 → parity = 1 (even parity)
        // ------------------------------------------------
        #10;
        data_in      = 8'b10101101;
        parity_in    = ^data_in;   // correct parity
        parity_check = 1;

        #10 parity_check = 0;

        // ------------------------------------------------
        // Case 2: Wrong parity
        // ------------------------------------------------
        #30;
        data_in      = 8'b10101101;
        parity_in    = ~(^data_in); // wrong parity
        parity_check = 1;

        #10 parity_check = 0;

        // ------------------------------------------------
        // End
        // ------------------------------------------------
        #50 $finish;
    end

    initial begin
        $monitor("T=%0t | data=%b | parity_in=%b | error=%b",
                 $time, data_in, parity_in, parity_error);
    end

endmodule
