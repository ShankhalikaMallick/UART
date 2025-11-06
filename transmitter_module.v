`include "tx_fsm.v"
`include "tx_piso.v"
`include "tx_parity_generator.v"
`include "tx_mux.v"

module transmitter_module(
    input clk,
    input reset,
    input tx_en,
    input [7:0] tx_data,
    output tx_packet );

    wire load_data, shift, s0, s1;
    wire data_bit, parity_bit;

    tx_fsm ob1 (clk, reset, tx_en, load_data, shift, s0, s1);
    tx_piso ob2 (clk, reset, tx_data, shift, load_data, data_bit);
    tx_parity_generator ob3 (load_data, tx_data, parity_bit);
    tx_mux ob4 (data_bit, parity_bit, s0, s1, tx_packet);
    // instantiate different modules
    
endmodule
