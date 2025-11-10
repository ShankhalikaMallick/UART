`include "baud_rate_generator.v"
`include "transmitter_module.v"
`include "receiver_module.v"

module top_module (
    input clk,
    input reset,
    input [7:0] tx_data,
    output [7:0] rx_dataout,
    output stop_error,
    output parity_error );

    wire rx_en, tx_en;
    wire tx_packet;

    baud_rate_generator ob1 ( clk, reset, rx_en, tx_en);
    transmitter_module ob2 ( clk, reset, tx_en, tx_data, tx_packet );
    receiver_module ob3 ( clk, reset, rx_en, tx_packet, rx_dataout, stop_error, parity_error );

endmodule
