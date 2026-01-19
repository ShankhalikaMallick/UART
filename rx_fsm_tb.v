`timescale 1ps/1ps
`include "rx_fsm.v"
module rx_fsm_tb;

    reg clk;
    reg reset;
    reg strt_bit;

    wire shift;
    wire parity_check;
    wire chk_stop;

    rx_fsm dut (
        .clk(clk),
        .reset(reset),
        .strt_bit(strt_bit),
        .shift(shift),
        .parity_check(parity_check),
        .chk_stop(chk_stop)
    );

    // 10 ps clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("rx_fsm.vcd");
        $dumpvars(0, rx_fsm_tb);

        clk       = 0;
        reset     = 1;
        strt_bit  = 0;

        #20 reset = 0;

        // simulate start bit detection
        #15 strt_bit = 1;
        #10 strt_bit = 0;

        // wait through DATA, PARITY, STOP
        #200 $finish;
    end

    initial begin
        $monitor("T=%0t | start=%b | shift=%b | parity=%b | stop=%b",
                  $time, strt_bit, shift, parity_check, chk_stop);
    end

endmodule
