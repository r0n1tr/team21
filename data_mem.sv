module data_mem #(

    parameter ADDRESS_WIDTH = 8, //it will come as 32 bits but we will only take the first 8
              DATA_WIDTH = 32
   
)(

    input  logic clk,   //only for Writing to Data Memory 
    input  logic   WE,   // Write Enable flag
    input  logic signed [DATA_WIDTH-1:0] WD,  //The Data we recieve from the rs2
    input  logic [DATA_WIDTH-1:0] A,   // The Adress that comes from ALU Result irrespective we are loading or stroring
    output logic signed [DATA_WIDTH-1:0] RD // Data read from the memory
);   


logic [DATA_WIDTH-1:0] data_memory [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading ram...");
    $readmemh("ADD FILE ", ram_array); 
end;


always_ff @(posedge clk) begin
    if (WE == 1'b1) data_memory[A] <= WD; // we are storing word 
end

    if(WE == 1'b0) assign RD = data_memory[A]; // we are loading word 

endmodule
