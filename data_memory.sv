module data_memory #(
    parameters DATA_WIDTH = 32,
    ADDRESS_WIDTH = 10 //although it is a 32 bit address, we wont use all of it
)(
    input logic clk,
    input logic [DATA_WIDTH-1:0] WD,
    input logic WE,
    input  logic [DATA_WIDTH-1:0]     A, // input address (comes from PC)
    output logic [DATA_WIDTH-1:0] RD // output ROM data (is the instruction word)
);

// Declare rom as array
logic [DATA_WIDTH-1:0] memory [2**ADDRESS_WIDTH-1:0]; // 1024 addresses

// program rom with contents in counter_rom.mem.
initial begin
    $display("Loading rom...");
    $readmemh("ADD ACTUAL DATA FILE", rom_array); 
end;

always_ff @(posedge clk)
    if(WE) 
        memory[A] <= RD; // only clocked action

assign RD = A;


endmodule
  
