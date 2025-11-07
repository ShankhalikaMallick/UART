module rx_detect_start(
    input clk,
    input rx_datain,
    output de_strtbit );

    reg [3:0] count=0;

    always @ (posedge clk)
    begin
        if (rx_datain==0)
        begin
            if (count == 4'd15)
            begin
                count=0;
                de_strtbit=1;               
            end
            else
            begin
                count= count+1;
                de_strtbit=0;
            end
        end
        else
        begin
            count = 0;
            de_strtbit =0;                 
        end
    end
    
endmodule
