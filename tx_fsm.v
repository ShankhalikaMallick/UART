`timescale 1ps/1ps

module tx_fsm(
    input clk,
    input reset,
    input tx_start,          // NEW: start transmission
    output reg [1:0] sel,    // control mux
    output reg load,         // load data into piso
    output reg shift,        // piso shift data
    output reg parity_load   // control parity
);

    reg [3:0] count;
    reg [2:0] state, next_state;

    // FSM states
    parameter IDLE   = 3'b000;
    parameter START  = 3'b001;
    parameter DATA   = 3'b010;
    parameter PARITY = 3'b011;
    parameter STOP   = 3'b100;

    // DATA done after 8 shifts
    wire data_done = (count == 7);

    // ---------------- COUNTER ----------------
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;
        else if (state == DATA)
            count <= count + 1;
        else
            count <= 0;
    end

    // ---------------- STATE REGISTER ----------------
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ---------------- FSM COMBINATIONAL ----------------
    always @(*) begin
        // defaults
        sel         = 2'b11;   // line idle HIGH
        load        = 1'b0;
        shift       = 1'b0;
        parity_load = 1'b0;
        next_state  = state;

        case (state)

            IDLE: begin
                sel = 2'b11;             // idle = stop bit (HIGH)
                if (tx_start)
                    next_state = START;
            end

            START: begin
                sel         = 2'b00;     // start bit
                load        = 1'b1;      // load PISO
                parity_load = 1'b1;      // compute parity
                next_state  = DATA;
            end

            DATA: begin
                sel   = 2'b01;           // data bits
                shift = 1'b1;
                if (data_done)
                    next_state = PARITY;
            end

            PARITY: begin
                sel        = 2'b10;      // parity bit
                next_state = STOP;
            end

            STOP: begin
                sel        = 2'b11;      // stop bit
                next_state = IDLE;
            end

        endcase
    end

endmodule
