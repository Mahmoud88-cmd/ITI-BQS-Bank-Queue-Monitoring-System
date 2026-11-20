module Waiting_Time_Rom (
input [4:0]address,
output [7:0]waiting_time
);

reg [7:0] arom [0:31];

initial 
$readmemb ("rom_initialization_file.mem",arom);

assign waiting_time = arom[address];

endmodule