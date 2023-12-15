# Data cache

When we started the implementation of cache, irrespective of which cache we picked, we first designed how it would fit into the pipelined CPU to decrease the data retrieval time. By inserting it between the memory and the writeback registers and adding the following mux and demux, it made sure we would skip the data memory if the hit flag is high.

<img width="1094" alt="top_memory" src="https://github.com/r0n1tr/team21/assets/133985295/7f94f8e2-bba2-4259-ad00-d208838ba8f2">


### One Way Cache

Since the cache involves comparing the set of the cache to the input of the cache, not to mention the hit-or-miss scenarios, we declared different logic signals to split everything from the cache set and make it easier use in logical operations, as shown below.

### Cache Read and Writeback

#### cache_1w.sv

```verilog

        cache_set = cache_memory[din_set]; 
        V = cache_set[59]; 
        cache_tag = cache_set[58:32]; 
        cache_data = cache_set[31:0]; 

        hit = V && (din_tag == cache_tag) && (resulltsrcm == 3'b001) && ~we;
        // fix hit logic
        if (hit) assign dout = cache_data; 
        else begin
            assign dout = din; // since we have to go to memory 
            assign cache_set = {1'b1, din[31:5], rd}; // assign new memory to cache
            assign cache_memory[din_set] = cache_set; 
        end
```
The (resultsrcm == 3'b001) && ~we being added to the hit signal ensures that we're only using the cache when a store word or load word instruction is being executed by the CPU.

### Cache Reset

If rst is asserted, then all the data in the cache is now useless. Initially, we just set the V flag to 0. However, to do that, you'd have to access the data, set the V flag to 0 through concatenation, and then write back to the memory, 8 times! 
Since the data is now useless, we can just set everything to 0, because resetting the CPU means all the bits in the sets of the cache are now 0XXXXX.........X, where X is a don't care. 

#### cache_1w.sv

```verilog
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
```

### Top Fle

By drawing out the circuit diagram, it made assembling the top file easier. A multiplexer and demultiplexer were used in tandem, with the hit signal controlling them both and hence controlling the output of the top_memory block that orriginated from the cache , a hit, or from the data memory, a miss.

#### top_memory.sv

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


### Cache integration in the CPU top file

When integrating cache into the pipelined CPU, we just replaced the data memory block with the top_memory.sv file. In principle, we just unplugged the  wires and plugged them back into another block.

```verilog
top_memory Memory(
    .clk(clk),
    .rst(rst),
    .we(memwritem),
    .wd(writedatam),
    .alu_result(aluresultm),
    .memcontrol(funct3m),

    .read_data(readdatam)
);
```
