module instr_mem #(
    parameter ADDRESS_WIDTH = 32,
              INSTRUCTION_WIDTH = 32,
              MEM_SIZE = 256,
              BYTE_WIDTH = 8
)(
    input  logic [ADDRESS_WIDTH-1:0] a, // input address (comes from PC)
    
    output logic [INSTRUCTION_WIDTH-1:0] instr // output ROM data (is the instruction word)
);

// Declare rom as array
logic [BYTE_WIDTH-1:0] rom_array [MEM_SIZE-1:0];

// program rom with contents of .mem file
initial begin
    $display("Loading rom...");
    $readmemh("mem_files/load_42.mem", rom_array); // NOTE: include a blank line after final line of machine code (otherwise the last byte is not read- at least that's what the testbench for this module implies)
end;

// asynchronous output
// in this implementation, we assume that instruction memory address is always a multiple of 4, and that it is an error otherwise
assign instr = {rom_array[a+3] , rom_array[a+2] , rom_array[a+1] , rom_array[a] }; // Little endian

endmodule
