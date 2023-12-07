module cache(

    parameter   DATA_WIDTH = 32,
                SET_WIDTH = 8
)(
    input logic [DATA_WIDTH-1:0] din,
    input logic [DATA_WIDTH-1:0] rd,


    output logic [DATA_WIDTH-1:0] dout,
    output logic hit
)

logic [26:0] din_tag = din[26:5];
logic [2:0] din_set = din[4:2];

logic [59:0] cache_memory [SET_WIDTH-1:0];


initial begin
    $display("Loading ram...");
    $readmemh("cache_1w.mem", cache_memory);
end;

logic [59:0] cache_set = cache_memory[din_set];

logic V = cache_set[59];
logic [26:0] cache_tag = cache_set[58:32];
logic [31:0] cache_data = cache_set[31:0];

assign hit = V & (din_tag == cache_tag);

if (hit) assign dout = cache_data;
else        
    assign dout = din;
    cache_set = {1'b1, din[31:5], rd};
    cache_memory[din_set] = cache_set;

endmodule


