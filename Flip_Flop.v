module Flip_Flop(
input clk,resn,d,
output reg q
);

always @(posedge clk or negedge resn) begin
    if (~resn)
        q <= 0;
    else 
        q <= d;    
end
endmodule
