`timescale 1ps / 1ps
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
    input  clk,
    input  reset,
    input  strt_bit,
    input  data_valid,
    input parity_error,
    input stop_error,
    output reg start,              // indicates if we have to check for start bit
    output reg shift,          // one-cycle shift pulse
    output reg parity_load,   // one-cycle parity check
    output reg chk_stop       // one-cycle stop check
);

    // control lines
    reg [2:0] state, next_state;

    // FSM states
    localparam IDLE   = 3'b000;
    localparam DATA   = 3'b001;
    localparam PARITY = 3'b010;
    localparam STOP   = 3'b011;

    // ---------------- STATE REGISTER ----------------
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ---------------- FSM COMBINATIONAL ----------------
    always @(*) begin
        start=0;
        parity_load = 0;
        chk_stop = 0;
        shift = 0;
        
        case (state)
            IDLE: begin
                start=1;
                chk_stop = 0;
                parity_load = 0;
                shift = 0;
                if (strt_bit)
                begin
                    next_state = DATA;
                    start <=0;
                end
                else
                    next_state = IDLE;
            end

            DATA: begin
                start=0;
                parity_load = 0;
                shift = 1'b1;              // pulse once per clock
                chk_stop = 0;
                if (data_valid == 1'b1)   // EXACTLY 8 bits but at receiver frequency
                 begin   
                    shift = 1'b0;
                    next_state = PARITY;
                 end
            end

            PARITY: begin
                shift        = 1'b0; 
                start        = 1'b0;
                parity_load  = 1'b1; 
                chk_stop     = 1'b0; 
                if(parity_error == 1)
                begin
                    next_state   = IDLE;
                end
                else if (parity_error == 0)
                begin
                    next_state = STOP;
                end
            end

            STOP: begin
                shift      = 1'b0;
                start      = 1'b0;
                parity_load = 1'b0;
                chk_stop   = 1'b1; 
                if(stop_error == 1)
                begin
                    next_state   = IDLE;
                end
                else if (stop_error == 0)
                begin
                    $display("successful receiving");
                    next_state   = IDLE;
                end
            end

            default: 
            begin
                start        = 1'b0;
                next_state   = IDLE;
                state        = IDLE;
                shift        = 1'b0;
                parity_load = 1'b0;
                chk_stop     = 1'b0;
            end
        endcase
    end

endmodule
