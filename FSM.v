module FSM(
input clk,resn,Bedge,Fedge,
input [2:0]Pcount,
output Falarm,Ealarm,Fflag,Eflag,
output reg enable,updown
);

parameter empty = 2'b00;
parameter count = 2'b01;
parameter full = 2'b10;

reg [1:0]state,nextstate;
 
always @(posedge clk or negedge resn) begin
    if (~resn)
        state <= empty;
    else 
        state <= nextstate;    
end

always @(*) begin
    nextstate = state;
    
    case (state)
        empty : begin
            if (Bedge & ~Fedge)
                nextstate = count;
            else 
                nextstate = empty;    
        end        
        
        count : begin
            if (Bedge & ~Fedge & Pcount==6)
                nextstate = full;
            else if (~Bedge & Fedge & Pcount==1) 
                nextstate = empty;
            else 
                nextstate = count;
        end
                
        full : begin
            if (~Bedge & Fedge)
                nextstate = count;
            else 
                nextstate = full;    
        end    
        
        default : nextstate = empty;
    endcase
end

always @(*) begin
    enable = 0;
    updown = 0;
    
    case (state)
        empty : begin
            if (Bedge & ~Fedge)
                begin enable = 1; updown = 1; end
        end
        
        count : begin
            if (Bedge & ~Fedge & Pcount < 7)
                begin enable = 1; updown = 1; end
            else if (~Bedge &Fedge & Pcount > 0)
                begin enable = 1; updown = 0; end  
            else 
                begin enable = 0; updown = 0; end       
        end
        
        full : begin
            if (~Bedge & Fedge)
                begin enable = 1; updown = 0; end    
        end
        
            default : begin enable = 0; updown = 0; end    
    endcase
end

assign Fflag = (Pcount[2] & Pcount[1] & Pcount[0]);
assign Eflag = (~Pcount[2] & ~Pcount[1] & ~Pcount[0]);
assign Falarm = (Bedge & ~Fedge & Fflag)? 1 : 0;
assign Ealarm = (~Bedge & Fedge & Eflag)? 1 : 0;

endmodule