module ITI_BQS(
input CLK,RESN,B_S,F_S,
input [1:0]T_COUNT,
output E_FLAG,F_FLAG,E_ALARM,F_ALARM,
output [6:0]PEOPLE,TIME1,TIME2
);

wire link1,link2;
wire en_signal,updown_signal;
wire [2:0]count_signal;
wire [7:0]total_time;


Edge_detector EDGE_DETETOR1 (
.clk(CLK),
.resn(RESN),
.signal(B_S),
.edge_value(link1)
);

Edge_detector EDGE_DETETOR2 (
.clk(CLK),
.resn(RESN),
.signal(F_S),
.edge_value(link2)
);

FSM CONTROLLER (
.clk(CLK),
.resn(RESN),
.Bedge(link1),
.Fedge(link2),
.Pcount(count_signal),
.Falarm(F_ALARM),
.Ealarm(E_ALARM),
.Fflag(F_FLAG),
.Eflag(E_FLAG),
.enable(en_signal),
.updown(updown_signal)
);

Up_Down_Counter COUNTER (
.clk(CLK),
.resn(RESN),
.enable(en_signal),
.updown(updown_signal),
.pcount(count_signal)
);

Waiting_Time_Rom CALCULATION (
.address({T_COUNT,count_signal}),
.waiting_time(total_time)
);

seven_segment_decoder custmers_decoder (
.bcd({1'b0,count_signal}),
.seven_segment_code(PEOPLE)
);

seven_segment_decoder tens_decoder (
.bcd(total_time[7:4]),
.seven_segment_code(TIME1)
);

seven_segment_decoder ones_decoder (
.bcd(total_time[3:0]),
.seven_segment_code(TIME2)
);


endmodule