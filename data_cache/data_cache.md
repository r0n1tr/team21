# Data cache

*Perhaps have sepate files for one-way and two-way cache? idk cache*

### Cache 

### Cache 
When we started the implementation of cache, irrespective of which cache we picked, we first designed how it would fit into the pipelined CPU to increase the data retrieval time. By inserting it between the memory and the writeback registers and adding the following mux and demux, it made sure we would skip the data memory if the Hit flag is high.

<img width="1094" alt="top_memory" src="https://github.com/r0n1tr/team21/assets/133985295/7f94f8e2-bba2-4259-ad00-d208838ba8f2">


### One Way Cache

```verilog
module cache_1w#(

    parameter   DATA_WIDTH = 32,
                SET_WIDTH = 8
)(
    input logic [DATA_WIDTH-1:0] din, // adress into cache from alu for sw or lw
    input logic [DATA_WIDTH-1:0] rd,  // the data that is inserted into cache from data memory
    input logic rst, // to reset v flag
    input logic [2:0] resultsrcm,
    input logic we,

    output logic [DATA_WIDTH-1:0] dout, // data out from the cache
    output logic hit
);

// input data's tag and set
logic [26:0] din_tag = din[32:5];   // tag 
logic [2:0] din_set = din[4:2];  // set

logic [59:0] cache_set; // cache set

logic V; // v-flag of set
logic [26:0] cache_tag; // tag of set
logic [31:0] cache_data; // data of set 


logic [59:0] cache_rst;

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

        hit = V && (din_tag == cache_tag) && (resultsrcm == 001) && ~we;
        // fix hit logic
        if (hit) assign dout = cache_data; 
        else begin
            assign dout = din; // since we have to go to memory 
            assign cache_set = {1'b1, din[31:5], rd}; // assign new memory to cache
            assign cache_memory[din_set] = cache_set; 
        end
    end
end
```
To make it easier to integrate into the cpu top file, we mde a top file called memory.sv and connected the cache to the data memory.

### Memory.sv

```verilog
module memory#(
    parameter       ADDRESS_WIDTH = 32,
                    DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic we,
    input logic [DATA_WIDTH-1:0] wd,
    input logic [ADDRESS_WIDTH-1:0] alu_result,
    input logic [2:0] memcontrol,
    
    output logic [DATA_WIDTH-1:0] read_data
    
);

logic hit;
logic [DATA_WIDTH-1:0] a;
logic [DATA_WIDTH-1:0] demux_input;
logic [DATA_WIDTH-1:0] mux_input0;
logic [DATA_WIDTH-1:0] mux_input1;

cache_1w cache_test(
    .din(alu_result),
    .rd(mux_input0),
    .rst(rst),   

    .dout(demux_input),
    .hit(hit)
);

demux cache_demux(
    .input_data(demux_input),
    .select(hit),

    .output0(a),
    .output1(mux_input1)
);

data_mem data_memory(
    .a(a),
    .clk(clk),
    .we(we),
    .writedata(wd),
    .memcontrol(memcontrol),

    .readdata(mux_input0)

);

mux memory_mux(
    .input0(mux_input0),
    .input1(mux_input1),
    .select(hit),

    .out(read_data)
);

endmodule
```
When integrating cache into the pipelined CPU, it was just a matter of unplugging wires and plugging it back into another block.

### Cache integration in the CPU top file

```verilog
memory top_data_mem(
    .clk(clk),
    .rst(rst),
    .we(memwritem),
    .wd(writedatam),
    .alu_result(aluresultm),
    .memcontrol(funct3m),

    .readdata(readdatam)
);
```
