module reg_file #(
    parameter REG_FILE_ADDR_WIDTH = 5, 
              DATA_WIDTH = 32
)(
    input logic                           clk, 
    input logic                           we3, // write enable 
    input logic [DATA_WIDTH-1:0]          wd3,
    input logic [REG_FILE_ADDR_WIDTH-1:0] ad1,
    input logic [REG_FILE_ADDR_WIDTH-1:0] ad2,
    input logic [REG_FILE_ADDR_WIDTH-1:0] ad3, 

    output logic signed [DATA_WIDTH-1:0] rd1,
    output logic signed [DATA_WIDTH-1:0] rd2,
    output logic signed [DATA_WIDTH-1:0] a0
);

logic [DATA_WIDTH-1:0] ram_array [2**REG_FILE_ADDR_WIDTH-1:0];

always_ff @(negedge clk) begin
    if(we3 && ad3 != REG_FILE_ADDR_WIDTH'('b0)) ram_array[ad3] <= wd3;
end

assign ram_array[REG_FILE_ADDR_WIDTH'('b0)] = 32'b0; // x0 is always zero
assign rd1 = ram_array[ad1];
assign rd2 = ram_array[ad2];
assign a0  = ram_array[REG_FILE_ADDR_WIDTH'('d10)]; // a0 = register 10

endmodule


