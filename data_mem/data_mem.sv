module data_mem #(
    parameter ADDRESS_WIDTH = 8, // comes as 32 bits but we will only take the first 8
              DATA_WIDTH = 8     // this used to be 32
)(
    input  logic                  clk, // only for writing to data_mem
    input  logic                  WE,  // write enable flag
    input  logic [DATA_WIDTH-1:0] WD,  // the data we receieve from rs2
    input  logic [DATA_WIDTH-1:0] A,   // the address that comes from ALUResult irrespective we are loading or storing

    output logic [DATA_WIDTH-1:0] RD   // data read from the memory
);   


logic [DATA_WIDTH-1:0] data_memory [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading ram...");
    $readmemh("ram_array.mem", data_memory); 
end;

always_ff @(posedge clk) begin
    if (WE) data_memory[A] <= WD; // storing word (only on clk rising edge)
end

assign RD = data_memory[A]; // loading word (asynchronously)

endmodule
