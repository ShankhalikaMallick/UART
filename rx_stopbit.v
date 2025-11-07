module rx_stopbit(
    input clk,
    input rx_datain,
    input [7:0] rx_data,
    input checkstop,
    output reg stop_error,
    output reg [7:0] rx_dataout );

    reg [2:0] count;

    always @ (posedge clk)
    begin
        if (checkstop == 1) 
        begin
            if (rx_datain == 1)
            begin
                if (count == 7)
                begin
                    count <=0;
                    stop_error <=0;
                    rx_dataout= rx_data;
                end
                else
                begin
                    count <= count +1;
                end
            end
            else 
            begin
                stop_error <=1;
                rx_dataout= 8'h0;
            end
        end
        else
        begin
            stop_error <= 0;
            rx_dataout <= rx_data;
        end
    end
endmodule
