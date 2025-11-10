// this module is to detect the proper working of transmitter mux module by giving random inputs to mux

`include "tx_mux.v"

module tx_mux_test();

    reg data_bit;
    reg parity_bit;
    reg s0, s1;
    wire tx_packet;

    tx_mux t1 ( data_bit, parity_bit, s0, s1, tx_packet );

    initial begin
        data_bit = 1; 
        parity_bit = 0; 
        #10; s0=0; s1=0;
        #2; $display ($time, "s0= %b, s1=%b, tx_packet=%b",s0, s1, tx_packet);
        #10; s0=1; s1=0;
        #2; $display ($time, "s0= %b, s1=%b, tx_packet=%b",s0, s1, tx_packet);
        #10; s0=0; s1=1;
        #2; $display ($time, "s0= %b, s1=%b, tx_packet=%b",s0, s1, tx_packet);
        #10; s0=1; s1=1;
        #2; $display ($time, "s0= %b, s1=%b, tx_packet=%b",s0, s1, tx_packet);
    end
endmodule
