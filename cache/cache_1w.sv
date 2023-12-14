module cache_1w#(

    parameter   DATA_WIDTH = 32,
                SET_WIDTH = 8,
                ADDRESS_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] din, // adress into cache from alu for sw or lw
    input logic [DATA_WIDTH-1:0] rd,  // the data that is inserted into cache from data memory
    input logic rst, // to reset v flag
    
    output logic [DATA_WIDTH-1:0] dout, // data out from the cache
    output logic hit
);

// input data's tag and set
logic [26:0] din_tag = din[31:5];   // tag 
logic [2:0] din_set = din[4:2];  // set

logic [59:0] cache_set; // cache set

logic V; // v-flag of set
logic [26:0] cache_tag; // tag of set
logic [31:0] cache_data; // data of set 


//logic [59:0] cache_rst;

logic [59:0] cache_memory [SET_WIDTH-1:0]; //initializing ram
initial begin
    $display("Loading ram...");
    $readmemh("cache/cache_1w.mem", cache_memory);
end

always_comb begin   
    if (rst) begin
        
        cache_memory[0] = 60'b0;
        cache_memory[1] = 60'b0;
        cache_memory[2] = 60'b0;
        cache_memory[3] = 60'b0;
        cache_memory[4] = 60'b0;
        cache_memory[5] = 60'b0;
        cache_memory[6] = 60'b0;
        cache_memory[7] = 60'b0;
        
    end
    else begin

        cache_set = cache_memory[din_set]; 
        V = cache_set[59]; 
        cache_tag = cache_set[58:32]; 
        cache_data = cache_set[31:0]; 

        hit = V && (din_tag == cache_tag);
        // fix hit logic
        if (hit) dout = cache_data; 
        else begin      
            dout = din; // since we have to go to memory 
            cache_set = {{1'b1}, {din_tag}, {rd}}; // assign new memory to cache
            //cache_memory[din_set] = cache_set; 
        end
    end
end

endmodule





