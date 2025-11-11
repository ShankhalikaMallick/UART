`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 18:20:11
// Design Name: 
// Module Name: uart_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_test();
    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] data_in;
    wire tx_busy;
    wire [7:0] data_out;
    wire parity_error;
    wire stop_error;
    wire op_valid;
    
    uart obj (clk, reset, tx_start, data_in, tx_busy, data_out, parity_error, stop_error, op_valid);
    
    always #0.001 clk=~clk;
    
    task initialize;
    begin
        clk=0;
        reset=0;
        data_in=0;
        tx_start=0;
    end
    endtask
    
    task rst;
    begin
        reset=1;
        #0.002 reset=0;
    end
    endtask
    
    task data;
    begin
        @(negedge clk)
        tx_start=1;
        data_in=8'hdd;
        #500; $finish;
    end
    endtask
    
    initial begin
    $dumpfile("uart.vcd");
    $dumpvars;
    initialize;
    rst;
    data;
    end
    always @(posedge op_valid) $strobe ("op_data=%h",data_out);
endmodule
