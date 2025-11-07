module tx_piso(
    input clk,
    input reset,
    input [7:0] tx_data,
    input shift,
    input load_data,
    output reg data_bit );

    reg [7:0] temp;         // temporary counter

   always @ (posedge clk or posedge reset)
   begin
        if (reset ==0)
        begin
            data_bit=0;
            temp <=0;
        end
        else if (load_data == 1)
        begin
            temp <= tx_data;
        end
        else if (shift == 1) 
        begin           
        // data has already been loaded, now we convert parallel data to serial data
        data_bit= temp[0];
        temp <= temp>>1; 
        end
   end
endmodule
