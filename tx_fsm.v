module tx_fsm(
    input clk,
    input reset,
    input tx_en,
    output reg load_data,
    output reg shift,
    output reg s0,
    output reg s1);

    parameter IDLE= 3'b000;
    parameter START_BIT= 3'b001;
    parameter DATA_BIT=3'b010;
    parameter PARITY_BIT=3'b011;
    parameter STOP_BIT=3'b100;

    reg [2:0] state, next_state;
    reg flag1, flag2, temp, temp1;
    reg [3:0] x1;              // counter variable counting 0-8
    reg [4:0] x2;              // counter variable counting 0-15

    always@(*)
    begin
        case (state)
        IDLE:
        begin          
            load_data=0;       // idle condition: no data loaded
            shift=0;           // no need to shift 
            s0=1;              // select lines for mux
            s1=1;              // select lines for mux: 11 is for stop_bit
            temp=0;             // indicates operation going on in data_bit state
            temp1=1;            // idk what they are for    
            if (tx_en ==1)
                next_state= START_BIT;
            else 
                next_state= IDLE;
        end

        START_BIT:
        begin
            load_data=1;        // start loading data into packet
            shift=0;            // no need to shift 
            s0=0;               // select lines for mux
            s1=0;               // select lines for mux: 00 is for start_bit
            temp=0;
            temp1=1;            // idk what they are for  
            if(flag1==0)
                next_state= START_BIT;
            else
                next_state= DATA_BIT;
        end

        DATA_BIT:
        begin
            load_data=0;        // no data need to be loaded
            shift=1;            // shift data bits
            s0=0;               // select lines for mux
            s1=1;               // select lines for mux: 01 is for data_bit
            temp=1;             // indicates operation going on in data_bit state
            temp1=0;
            if (flag2==0)
                next_state= DATA_BIT;
            else
                next_state= PARITY_BIT;
        end
        
        PARITY_BIT:
        begin
            load_data=0;        // no data need to be loaded
            shift=0;            // no need to shift 
            s0=1;               // select lines for mux
            s1=0;               // select lines for mux: 10 is for parity_bit
            temp=0;
            temp1=1;
            if (flag1==0)
                next_state= PARITY_BIT;
            else 
                next_state= STOP_BIT;  
        end

        STOP_BIT:
        begin
            load_data=0;        // no data need to be loaded
            shift=0;            // no need to shift 
            s0=1;               // select lines for mux
            s1=1;               // select lines for mux: 11 is for stop_bit
            temp=0;
            temp1=0;
            if (flag1==0)
                next_state= STOP_BIT;
            else
                next_state= IDLE;
        end
        endcase
    end

    always @ (posedge clk)
    begin
        if (temp==1)            // operating in data bit state
        begin
            if (x1==4'd8)       // x1 is a counter variable counting 8 times
            begin
                flag2=1;         // data is now loaded completely, goto parity_bit state now 
                x1=0;
            end
            else 
            begin
                flag2=0;
                x1= x1 + 1'b1;
            end
        end
        else                       // temp is not 1 ie. not in data_bit state
        begin
            flag2=0;            
        end
    end

    always @ (posedge clk)
    begin
        if(temp1==1)
        begin
            if(x2==5'd15)
            begin
                flag1=1;
                x2=0;
            end
            else
            begin
                flag1=0;
                x2=x2+1;
            end
        end
        else
        flag1=0;
    end   

    always @(posedge clk or posedge reset) 
    begin
        if (reset == 1)
        state <= IDLE;
        else
        state <= next_state;
    end

endmodule
