module cache_2w #(

    parameter   DATA_WIDTH = 32,
                SET_WIDTH = 4
)(
    input logic [DATA_WIDTH-1:0] din,
    input logic [DATA_WIDTH-1:0] rd,
    input logic rst,


    output logic [DATA_WIDTH-1:0] dout,
    output logic hit 
);

logic [27:0] din_tag = din[31:4];   //tag is 28 bits 
logic [1:0] din_set = din[3:2];     // set is now bits 
logic u = 1'b0; // initialize to 0 at beginning to determine which item was least recently used 
logic [121:0] cache_memory [SET_WIDTH-1:0];


initial begin
    $display("Loading ram...");
    $readmemh("cache/cache_2w.mem", cache_memory);
end;

logic [121:0] cache_set = cache_memory[din_set];

logic V_way_1 = cache_set[121];
logic [27:0] cache_way_1_tag = cache_set[120:93];   
logic [31:0] cache_way_1_data = cache_set[92:61];

logic V_way_0 = cache_set[60];
logic [27:0] cache_way_0_tag = cache_set[59:32];
logic [31:0] cache_way_0_data = cache_set[31:0];

logic hit_1;
logic hit_0;

assign hit_1 = V_way_1 & (din_tag == cache_way_1_tag);
assign hit_0 = V_way_0 & (din_tag == cache_way_0_tag);

assign hit = hit_0 | hit_1;

always_comb begin
 if (rst) begin
        cache_memory[0] = 122'b0;
        cache_memory[1] = 122'b0;
        cache_memory[2] = 122'b0;
        cache_memory[3] = 122'b0;
 end 
 else if(hit_1) begin
    dout = cache_way_1_data;
    u = 1'b0;       // least recently used in set is way 0 
 end
 else if(hit_0) begin
    dout = cache_way_0_data;
    u = 1'b1;
 end
 else begin
    dout = din;
    if (u) begin 
        cache_set [121:61] = {1'b1,din[31:4], rd}; 
        cache_memory[din_set] = cache_set;
    end 
    else begin
    cache_set [60:0] = {1'b1,din[31:4], rd};
    cache_memory[din_set] = cache_set;
    end 
 end
end 

endmodule
