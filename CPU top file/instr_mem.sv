module instr_mem #(
    parameter ADDRESS_WIDTH = 8,
              INSTRUCTION_WIDTH = 32
)(
    input  logic [ADDRESS_WIDTH-1:0]     A, // input address (comes from PC)
    
    output logic [INSTRUCTION_WIDTH-1:0] RD // output ROM data (is the instruction word)
);

// Declare rom as array
logic [INSTRUCTION_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

// program rom with contents in counter_rom.mem.
initial begin
    $display("Loading rom...");
    $readmemh("instr_mem/counter_rom.mem", rom_array); // Each word appears 4 times, so that e.g. accessing any address from 0 to 3 means accessing the first instruction. 
                                                       // TODO: NOT SURE IF THIS IS HOW IT'S MEANT TO BE DONE. CHECK IF CORRECT.
end;

// output is asynchronous
assign RD = rom_array[A];

endmodule
