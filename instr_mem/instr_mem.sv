module instr_mem #(
    parameter ADDRESS_WIDTH = 32,
              INSTRUCTION_WIDTH = 32,
              MEM_SIZE = 256,
              BYTE_WIDTH = 8
)(
    input  logic [ADDRESS_WIDTH-1:0]     a, // input address (comes from PC)
    
    output logic [INSTRUCTION_WIDTH-1:0] rd // output ROM data (is the instruction word)
);

// Declare rom as array
logic [BYTE_WIDTH-1:0] rom_array [MEM_SIZE-1:0];

// program rom with contents in counter_rom.mem.
initial begin
    $display("Loading rom...");

    $readmemh("mem_files/f1_test.mem", rom_array);

end;

// output is asynchronous
assign rd = {rom_array[a] , rom_array[a+1] , rom_array[a+2] , rom_array[a+3] }; // TODO: Reverse order (+3,+2,+1,+0) to make little endian (i think) (as specified in brief)

endmodule
