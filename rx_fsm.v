`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 17:38:18
// Design Name: 
// Module Name: rx_fsm
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


module rx_fsm(
    input clk,
    input reset,
    input strt_bit,
    input parity_error,
    output reg run_shift,
    output reg parity_load,
    output reg chk_stop,
    output sample_done    );
    
    reg [3:0] bcount;       // to check the middle of data
    reg [3:0] count;        // to check how many data I have received
    wire data_done;
    reg count_en;           // to enable the count
    reg [1:0] state, next_state;
    
    parameter IDLE= 2'b00;
    parameter DATA= 2'b01;
    parameter PARITY= 2'b10;   
    parameter STOP= 2'b11;
    
    assign sample_done= (bcount==7);            // rx 8 clks have passed
    assign data_done=(count==11);               // when SIPO has received all 11 data , then receiver work is done
    always @(posedge clk, posedge reset)
    begin
            if(reset==1)
                bcount <=0;
        else
        begin
            if(state!=IDLE)
                bcount <= bcount+1;           // count at data state
            else
                bcount <=0;
        end
    end 
    
    always @(posedge clk, posedge reset)
    begin
        if(reset==1)
                count <=0;
        else
        begin
            if(count_en)
            begin
                if(sample_done) count <= count+1;         
                else            count <= count;
            end
            else
                count <=0;
        end
    end 
    
    always @(posedge clk, posedge reset)
    begin
        if(reset==1)
            state <= IDLE;
        else
            state <=next_state;
    end
    
    always @(*)
    begin 
        case (state)
        IDLE:
            if(strt_bit==1)
                next_state = DATA;
            else
                next_state= IDLE;
                        
        DATA:
            if(data_done==1)
                next_state = PARITY;    
            else
                next_state= DATA;
                
        PARITY:
            if(parity_error==1)
                next_state= IDLE; 
            else
                next_state= STOP;    
                
        STOP:
                next_state= IDLE;    
        endcase         
    end
    
    always @(state)
    begin 
        case (state)
            IDLE:begin
                count_en=0;
                run_shift=0;
                parity_load=0;
                chk_stop=0;
            end
            DATA:begin
                count_en=1;
                run_shift=1;
                parity_load=0;
                chk_stop=0;
            end
            PARITY:begin
                count_en=0;
                run_shift=0;
                parity_load=1;
                chk_stop=0;
            end
            STOP:begin
                count_en=0;
                run_shift=0;
                parity_load=0;
                chk_stop=1;
            end
       endcase
       end
endmodule
