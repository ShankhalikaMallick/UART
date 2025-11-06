module tx_mux(
    input data_bit,
    input parity_bit,
    input s0,
    input s1,
    output tx_packet);

    wire start_bit;
    wire stop_bit;
    assign start_bit = 1'b0;
    assign stop_bit = 1'b1;
    // assigning multiplexer output
    assign tx_packet= (~s0 & ~s1 & start_bit) | (~s1 & s0 & data_bit) | (s1 & ~s0 & parity_bit) | (s1 & s0 & stop_bit); 
endmodule
