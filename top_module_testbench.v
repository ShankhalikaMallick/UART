// this is the top most module testbench for the entire function 
`include "top_module.v"
module top_module_testbench();

    reg clk;
    reg reset;
    reg [7:0] tx_data;
    wire [7:0] rx_dataout;
    wire stop_error;
    wire parity_error;

    top_module obj( clk, reset,tx_data, rx_dataout,stop_error, parity_error);
    always begin
        #5; clk=~clk;
    end
    
    initial begin
        $monitor("clk=%b\t, reset=%b\t ,tx_data=%b\t , rx_dataout=%b\t,stop_error=%b\t, parity_error=%b\t",clk, reset,tx_data, rx_dataout,stop_error, parity_error);
        clk=0; reset=0; tx_data= 8'b10101101;
        #116; $finish;
    end
endmodule
