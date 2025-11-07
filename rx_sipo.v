module rx_sipo (
    input clk,
    input reset,
    input rx_datain,
    input shift,
    output [7:0] rx_dataout );

    reg [7:0] temp;

    always @ (posedge clk or posedge reset)
    begin
        if(reset==0)
            temp<=0;
        else if (shift == 1)
        begin
            // we shift temp right by one
            temp [7] <= rx_datain;
            temp [6] <= temp [7];
            temp [5] <= temp [6];
            temp [4] <= temp [5];
            temp [3] <= temp [4];
            temp [2] <= temp [3];
            temp [1] <= temp [2];
            temp [0] <= temp [1];
        end
        else
        temp <= temp;
    end 

    assign rx_dataout = temp ;
endmodule  
