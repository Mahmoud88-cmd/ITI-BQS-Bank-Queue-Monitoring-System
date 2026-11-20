module Up_Down_Counter #(parameter counterwidth =3)(
input clk,resn,updown,enable,
output reg [counterwidth-1:0]pcount
);


always @(posedge clk or negedge resn) begin
    if (~resn)
        pcount <= 3'd0;
    else begin
        if (enable) begin
            if (updown)
                pcount <= pcount+1;
            else
                pcount <= pcount-1;
        end
        else pcount <= pcount;   
    end         
end
endmodule 