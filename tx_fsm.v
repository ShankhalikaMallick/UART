`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 16:33:43
// Design Name: 
// Module Name: tx_fsm
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


module tx_fsm(
    input clk,
    input reset,
    input tx_start,
    output reg [1:0] sel,       // control mux
    output reg load,            // control shift register
    output reg shift,
    output reg parity_load,     // control the parity
    output reg tx_busy    );
    
    reg [2:0] count;
    reg count_en;
    wire data_done;             // 1 when count=7, all 7 bits are shifted serially
    reg [2:0] state, next_state;
    
    parameter IDLE= 3'b000;
    parameter START= 3'b001;
    parameter DATA= 3'b010;
    parameter PARITY= 3'b011;   
    parameter STOP= 3'b100;
    
    assign data_done = (count==7);
    
// counter
    always @(posedge clk, posedge reset)
    begin
        if(reset==1)
            count <=0;
        else
        begin
            if(count_en==1)
                count <= count+1;           // count at data state
            else
                count <=0;
        end
    end 
    
// state updation
    always @(posedge clk, posedge reset)
    begin
        if(reset==1)
            state <= IDLE;
        else
            state <=next_state;
    end
    
 // detecting present state
    always @(*)
    begin 
        case (state)
        IDLE:
            if(tx_start==1)
                next_state = START;
            else
                next_state= IDLE;
                
        START:
                next_state= DATA;       // IN START STATE IT REAMINS FOR ONLY ONE CLOCK CYCLE FOR SENDING THE START BIT
        
        DATA:
            if(data_done==1)
                next_state = PARITY;    // IT WILL REMAIN HERE FOR 8 CLOCK CYCLES
            else
                next_state= DATA;
                
        PARITY:
                next_state= DATA;       // REMAIN HERE FOR 1 CLOCK CYCLE TO SEND THE PARITY BIT
                
        STOP:
             if(tx_start==1)
                next_state = START;
            else
                next_state= IDLE;
                
        endcase         
    end
    
    
// update constants depending on present state    
    always @(*)
    begin 
        case (state)
            IDLE:begin
                sel=2'b11;              // TO SEND 1 DURING IDLE STATE
                load=1'b0;
                shift=1'b0;
                parity_load=1'b0;
                tx_busy=1'b0;
                count_en=1'b0;
            end
            
            START:begin
                sel=2'b00;              // TO SEND 0 DURING START STATE
                load=1'b1;              // DURING THIS STATE DATA IS LOADED TO SHIFT
                shift=1'b0;
                parity_load=1'b1;       // PARITY LOAD IS CALCULATED
                tx_busy=1'b0;
                count_en=1'b0;
            end
            
            DATA:begin
                sel=2'b01;              // TO SEND SERIAL DATA_OUT DURING DATA STATE
                load=1'b0;
                shift=1'b1;
                parity_load=1'b0;
                tx_busy=1'b1;
                count_en=1'b1;
            end
            
            PARITY:begin
                sel=2'b10;              // TO SEND PARITY DURING PARITY STATE
                load=1'b0;
                shift=1'b0;
                parity_load=1'b0;
                tx_busy=1'b1;
                count_en=1'b0;
            end
            
            STOP: begin
                sel=2'b11;              // TO SEND 1 DURING STOP STATE
                load=1'b0;              // DURING THIS STATE DATA IS LOADED TO SHIFT
                shift=1'b0;
                parity_load=1'b0;       // PARITY LOAD IS CALULATED
                tx_busy=1'b1;           // TRANSMITTER IS BUSY
                count_en=1'b0;
            end
        endcase     
    end
      
endmodule
