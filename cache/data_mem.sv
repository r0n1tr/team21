// verilator lint_off UNUSED
module data_mem #(
    parameter ADDRESS_WIDTH = 32, // comes as 32 bits but we will only take the first 8
              DATA_WIDTH = 32,
              MEM_SIZE = 256    
)(
    input  logic                     clk, // only for writing to data_mem
    input  logic                     we,  // write enable flag
    input  logic [DATA_WIDTH-1:0]    wd,  // the data we receieve from rs2
    input  logic [ADDRESS_WIDTH-1:0] a,   // the address that comes from ALUResult irrespective we are loading or storing

    output logic [DATA_WIDTH-1:0] rd     // data read from the memory
);   


logic [DATA_WIDTH-1:0] data_memory [MEM_SIZE-1:0];

initial begin
    $display("Loading ram...");
    $readmemh("mem_files/data_mem.mem", data_memory); //ram array
end;

always_ff @(posedge clk) begin
    if (we) data_memory[a] <= wd; // storing word (only on clk rising edge)
end

assign rd = data_memory[a]; // loading word (asynchronously)

endmodule
// verilator lint_on UNUSED
