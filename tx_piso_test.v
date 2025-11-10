// module to test transmitter parallel in serial out piso module 

`include "tx_piso.v"
module tx_piso_test ();

    reg clk;
    reg reset;
    reg [7:0] tx_data;
    reg shift;
    reg load_data;
    wire data_bit;

    tx_piso t2( clk, reset, tx_data, shift, load_data, data_bit );
    
    always
    begin 
        #5; clk= ~clk;
    end 

    initial begin
        clk=0;
        reset=1;
        #2; $display ("reset: data_bit=%b", data_bit);
        #10; reset=0; load_data=1; tx_data= 8'b10111111;
        #2; $display ("load: data_bit=%b", data_bit);
        #10; shift =1; load_data=0;
        $display ($time, "shift");
        #90; load_data=0; shift=0; reset=1;
        #2; $display ($time, "reset: data_bit=%b", data_bit);
        #20; $finish;
    end

endmodule
