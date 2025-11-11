`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 17:22:04
// Design Name: 
// Module Name: brg
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


module brg(
    input clk_in,
    input reset,
    output reg clk_rx,
    output reg clk_tx    );
    
    parameter n=50;
    reg [11:0] count;
    reg [4:0] count1;
    
// setting up counter count for counting from 0 to 49    
    always @(posedge clk_in, posedge reset)
    begin
        if(reset)
        begin
            count<=0;
        end  
        else
        begin
            count<=count+1;
            if(count==n-1)
            begin
                count<=0;
            end
        end  
    end
    
// enablng receiver based on count value
    always @(count)
    begin
        if(count==0)            clk_rx=1;       
        else if(count==(n>1))   clk_rx=0;
        else                    clk_rx=clk_rx;
    end

// setting up counter count1 for counting from 0 to 15    
    always @(posedge clk_in, posedge reset)
    begin
        if(reset)
            count1<=0;
        else
        begin
            count1 <= count1+1;
            if(count1==15)
            count1<=0;
        end    
    end

    always @(count1)
    begin
        if(count1==0)           clk_tx=1;       
        else if(count1==8)      clk_tx=0;
        else                    clk_tx=clk_tx;    
    end
endmodule
