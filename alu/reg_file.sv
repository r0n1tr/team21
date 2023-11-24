module reg_file #(
    parameter REG_FILE_ADDR_WIDTH = 5, 
              DATA_WIDTH = 32
)(
    input  logic                           clk,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] AD1,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] AD2,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] AD3, 
    input  logic                           WE3, // write enable 
    input  logic [DATA_WIDTH-1:0]          WD3,

    output logic [DATA_WIDTH-1:0]          RD1,
    output logic [DATA_WIDTH-1:0]          RD2,
    output logic [DATA_WIDTH-1:0]          a0
);
    
logic [DATA_WIDTH-1:0] ram_array [2**REG_FILE_ADDR_WIDTH-1:0];

always_ff @(posedge clk) begin
    RD1 <= ram_array[AD1];
    RD2 <= ram_array[AD2];

    if(WE3)
        ram_array[AD3] <= WD3;

    a0 <= WD3;
end
    
endmodule


