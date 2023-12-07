module cache(

    parameter   DATA_WIDTH = 32,
                SET_WIDTH = 8,
                ADDRESS_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] din, // adress into cache from alu for sw or lw
    input logic [DATA_WIDTH-1:0] rd,  // the data that is inserted into cache from data memory
    input logic rst, // to reset v flag
    
    output logic [DATA_WIDTH-1:0] dout, // data out from the cache
    output logic hit
)

logic [26:0] din_tag = din[32:5];   // tag 
logic [2:0] din_set = din[4:2];  // sets 

logic [59:0] cache_memory [SET_WIDTH-1:0]; //initializing ram


initial begin
    $display("Loading ram...");
    $readmemh("cache_1w.mem", cache_memory);
end;

always_comb 
begin if (rst)
    logic [59:0] cache_rst = cache_memory[0];

    cache_rst = {1'b0,cache_rst[58:0]};
    cache_memory[0] = cache_rst;

    cache_rst = cache_memory[1];
    cache_rst = {1'b0,cache_rst[58:0]};
    cache_memory[0] = cache_rst;

    cache_rst = cache_memory[2];
    cache_rst = {1'b0,cache_rst[58:0]};
    cache_memory[0] = cache_rst;

    cache_rst = cache_memory[3];
    cache_rst = {1'b0,cache_rst[58:0]};
    cache_memory[0] = cache_rst;

    cache_rst = cache_memory[4];
    cache_rst = {1'b0,cache_rst[58:0]};
    cache_memory[0] = cache_rst;

    cache_rst = cache_memory[5];
    cache_rst = {1'b0,cache_rst[58:0]};
    cache_memory[0] = cache_rst;

    cache_rst = cache_memory[6];
    cache_rst = {1'b0,cache_rst[58:0]};
    cache_memory[0] = cache_rst;

    cache_rst = cache_memory[7];
    cache_rst = {1'b0,cache_rst[58:0]};
    cache_memory[0] = cache_rst;
    
end


logic [59:0] cache_set = cache_memory[din_set]; 

logic V = cache_set[59]; //v-flag
logic [26:0] cache_tag = cache_set[58:32]; // making the tag
logic [31:0] cache_data = cache_set[31:0]; // initialising the set

assign hit = V & (din_tag == cache_tag);



if (hit) assign dout = cache_data; 
else begin      
    dout = din; // since we have to go to memory 
    cache_set = {1'b1, din[31:5], rd}; // assign new memory to cache
    cache_memory[din_set] = cache_set; 
end

endmodule



