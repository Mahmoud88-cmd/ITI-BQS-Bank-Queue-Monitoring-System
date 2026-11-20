`timescale 1ns / 1ps
module ITI_BQS_TB();

wire E_FLAG,F_FLAG,E_ALARM,F_ALARM;
wire [6:0]PEOPLE,TIME1,TIME2;
reg CLK,RESN,B_S,F_S;
reg [1:0]T_COUNT;

ITI_BQS DUT (
.CLK(CLK),
.RESN(RESN),
.B_S(B_S),
.F_S(F_S),
.T_COUNT(T_COUNT),
.E_FLAG(E_FLAG),
.F_FLAG(F_FLAG),
.E_ALARM(E_ALARM),
.F_ALARM(F_ALARM),
.PEOPLE(PEOPLE),
.TIME1(TIME1),
.TIME2(TIME2)
);

initial CLK=1'b0;
always #5 CLK = ~CLK;

task enter_client ; begin
    @(posedge CLK);
    B_S <= 1'b0;
    @(posedge CLK);
    B_S <= 1'b1;
    @(posedge CLK); 
end           
endtask

task leave_client ; begin
    @(posedge CLK);
    F_S <= 1'b0;
    @(posedge CLK);
    F_S <= 1'b1;
    @(posedge CLK); 
end           
endtask

initial begin
    $timeformat(-9, 0, "", 6);
    $display ("===============================================================================================================");
    $display ("|  TIME  | RESN | B_S | F_S | T_CNT | P_CNT | W_TIME | E_FLG | F_FLG | E_ALM | F_ALM | PEOPLE | TIME1 | TIME2 |");
    $display ("===============================================================================================================");
    $monitor ("| %t |  %b   |  %b  |  %b  |   %0d   |   %0d   |   %h   |   %b   |   %b   |   %b   |   %b   | %7b | %7b | %7b |"
    ,$time,RESN,B_S,F_S,T_COUNT,DUT.count_signal,DUT.total_time,E_FLAG,F_FLAG,E_ALARM,F_ALARM,PEOPLE,TIME1,TIME2 );
end

initial begin
    RESN <= 0;
    B_S <= 1;
    F_S <= 1;
    T_COUNT <= 2'D1;
    
    repeat (2) @(posedge CLK);
    RESN <= 1;
    @(posedge CLK);
    
    leave_client;
    
    @(posedge CLK);
    B_S <= 0;
    repeat (4) @(posedge CLK);
    B_S <= 1;
    @(posedge CLK);
    
    repeat (6) enter_client;
    
    enter_client;
    
    @(posedge CLK);
    T_COUNT <= 2'D2;
    repeat (2) @(posedge CLK);
    
    T_COUNT <= 2'D3;
    repeat (2) @(posedge CLK);    
    
    repeat (2) leave_client;
    
    @(posedge CLK);
    B_S <= 0;
    F_S <= 0;
    @(posedge CLK);
    B_S <= 1;
    F_S <= 1;
    @(posedge CLK);    
    
   repeat (5) leave_client;
   
   $stop;
end    
endmodule
