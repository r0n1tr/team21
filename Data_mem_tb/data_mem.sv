module data_mem #(

    parameter ADDRESS_WIDTH = 8, //it will come as 32 bits but we will only take the first 8
              DATA_WIDTH = 8 // this used to be 32
   
)(

    input  logic clk,   //only for Writing to Data Memory 
    input  logic   WE,   // Write Enable flag
    input  logic [DATA_WIDTH-1:0] WD,  //The Data we recieve from the rs2
    input  logic [DATA_WIDTH-1:0] A,   // The Adress that comes from ALU Result irrespective we are loading or stroring
    output logic [DATA_WIDTH-1:0] RD // Data read from the memory
);   


logic [DATA_WIDTH-1:0] data_memory [2**ADDRESS_WIDTH-1:0];

initial begin
    $display("Loading ram...");
    $readmemh("ram_array.mem", data_memory); 
end;




always_ff @(posedge clk) begin
    if (WE) 
        data_memory[A] <= WD; // we are storing word 
end

assign RD = data_memory[A]; // we are loading word 

endmodule
