`timescale 1ps/1ps
`include "rx_sipo.v"
module rx_sipo_tb;

    reg clk;
    reg reset;
    reg rx_in;
    reg shift;

    wire [7:0] data_out;
    wire       data_valid;

    rx_sipo dut (
        .clk(clk),
        .reset(reset),
        .rx_in(rx_in),
        .shift(shift),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // 10 ps clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("rx_sipo.vcd");
        $dumpvars(0, rx_sipo_tb);

        clk   = 0;
        reset = 1;
        rx_in = 1;
        shift = 0;

        #20 reset = 0;

        // Send 8'b10101101 (LSB first)
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);

        #50 $finish;
    end

    task send_bit;
        input b;
        begin
            rx_in = b;
            shift = 1;
            #10;
            shift = 0;
            #10;
        end
    endtask

    initial begin
        $monitor("T=%0t | rx_in=%b | shift=%b | data_out=%b | valid=%b",
                 $time, rx_in, shift, data_out, data_valid);
    end

endmodule
