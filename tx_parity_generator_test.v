// module to check working of transmitter parity generator

`include "tx_parity_generator.v"
module tx_parity_generator_test ();
    reg load_data;
    reg [7:0] tx_data;
    wire parity_bit;

    tx_parity_generator t1( load_data, tx_data, parity_bit);

    initial begin
        load_data= 1;
        #10; tx_data = 8'b 10110101;
        #2; $display ("parity bit=%b", parity_bit);
        #10; tx_data = 8'b 00110101;
        #2; $display ("parity bit=%b", parity_bit);
        #10; load_data=0;
        #2; $display ("parity bit=%b", parity_bit);
    end
endmodule
