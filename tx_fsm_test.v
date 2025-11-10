// this module test the working of tx_fsm module

`include "tx_fsm.v" 

module tx_fsm_test ();

    reg clk;
    reg reset;
    reg tx_en;
    wire load_data;
    wire shift;
    wire s0;
    wire s1;
    
    tx_fsm t2 ( clk, reset, tx_en, load_data, shift, s0, s1);
    always 
    begin
        #5; clk=~clk;
    end

    initial begin
        $monitor ($time,"clk=%b\t, reset=%b\t, tx_en=%b\t, load_data=%b\t, shift=%b\t, s0=%b\t, s1=%b\t", clk, reset, tx_en, load_data, shift, s0, s1 );
    clk=0; reset=1;
    tx_en= 0;
    #10; reset=0; tx_en=1;
    #60; $finish; 
    end
endmodule
