module tx_parity_generator(
    input load_data,
    input [7:0] tx_data,
    output reg parity_bit);

    always @(*)
    begin
        if( load_data==1'b1 )
            parity_bit = ^ tx_data;
        else
            parity_bit = 1'bZ;      
// to be checked later on
    end
endmodule
