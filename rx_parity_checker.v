module rx_parity_checker(
    input parity_load,
    input rx_datain,     // this is the parity bit generated
    input [7:0] rx_data,
    output reg parity_error );

    always @ (*)
    begin
       if (parity_load ==1)
       begin
            if (rx_datain == (^rx_data))
            parity_error <=0;
            else
            parity_error <=1;
       end 
       else
       parity_error <=0;
    end
endmodule
