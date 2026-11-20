module Edge_detector (
input clk,resn,signal,
output edge_value
);

wire delay_input;

Flip_Flop FF_detector (
.clk(clk),
.resn(resn),
.d(signal),
.q(delay_input)
);

assign edge_value = ~signal & delay_input;

endmodule