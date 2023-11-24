module reg_file #(
    parameter REG_FILE_ADDR_WIDTH = 5, 
              DATA_WIDTH = 32
)(
    input  logic                           clk, 
    input  logic                           WE3, // write enable 
    input  logic [DATA_WIDTH-1:0]          WD3,
    input logic [REG_FILE_ADDR_WIDTH-1:0] AD1,
    input logic [REG_FILE_ADDR_WIDTH-1:0] AD2,
    input logic [REG_FILE_ADDR_WIDTH-1:0] AD3, 

    output logic signed [DATA_WIDTH-1:0]          RD1,
    output logic signed [DATA_WIDTH-1:0]          RD2,
    output logic signed [DATA_WIDTH-1:0]          a0,
    output logic signed [DATA_WIDTH-1:0]           t1,
    output logic signed [DATA_WIDTH-1:0] a1
);
    

logic [DATA_WIDTH-1:0] ram_array [2**REG_FILE_ADDR_WIDTH-1:0];



always_ff @(posedge clk) begin
    if(WE3 == 1'b1)
        ram_array[AD3] <= WD3;
end

    assign RD1 = ram_array[AD1];
    assign RD2 = ram_array[AD2];
    assign a0 = ram_array[10];
    assign t1 = ram_array[6];
    assign a1 = ram_array[11];

    
endmodule


