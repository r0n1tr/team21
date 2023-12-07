module cache(

    parameter   DATA_WIDTH = 32,
                SET_WIDTH = 4
)(
    input logic [DATA_WIDTH-1:0] din,
    input logic [DATA_WIDTH-1:0] rd,


    output logic [DATA_WIDTH-1:0] dout,
    output logic hit
);

logic [26:0] din_tag = din[26:5];
logic [2:0] din_set = din[4:2];

logic [59:0] cache_memory [SET_WIDTH-1:0];


initial begin
    $display("Loading ram...");
    $readmemh("cache_2w.mem", cache_memory);
end;

logic [123:0] cache_set = cache_memory[din_set];

logic V_way_1 = cache_set[123:122];
logic [26:0] cache_way_1_tag = cache_set[121:94];
logic [31:0] cache_way_1_data = cache_set[93:62];

logic V_way_0 = cache_set[61:60];
logic [26:0] cache_way_0_tag = cache_set[59:32];
logic [31:0] cache_way_0_data = cache_set[31:0];

logic hit_1;
logic hit_0;

assign hit_1 = V_way_1[1] & (din_tag == cache_way_1_tag);
assign hit_0 = V_way_0[1] & (din_tag == cache_way_0_tag);
assign hit = hit_0 | hit_1;


if (hit_1)          assign dout = cache_way_1_data;
else if (hit_0)     assign dout = cache_way_0_data;
else
    assign dout = din;
    cache_set = {1'b1,din[31:5], rd};
    cache_memory[din_set] = cache_set;

endmodule