# Mohammed Tayyab's Personal Statement

## Singl-cycle Processor

### F1 lighting machine code

To write the machine code for the F1 lighting sequence, I took inspiration from the finite state machine from lab 3

![Picture1](https://github.com/r0n1tr/team21/assets/133985295/99ac7227-d10d-43d9-88a2-8c25e61edff8)

Image taken from https://github.com/EIE2-IAC-Labs/Lab3-FSM/blob/main/images/state_diag.jpg

One would think to do a loop where you do 

SLLI a0,a0,1

ADDI a0,a0,1

And repeat, no! After the left shift, the LSB of a0 is now 0, meaning the light at the very end of the f1 light is now closed. Sure, a clock cycle is short so no one would notice the difference. However, if this were implemented on a real f1 traffic light, and someone noticed the light turning off, they’d think the problem is with the light itself. To avoid this, the following measures were taken.

<img width="436" alt="Picture2" src="https://github.com/r0n1tr/team21/assets/133985295/db31e364-511f-465a-ade6-2c1303c2c125">

As you can see above, a temporary register, t1, was used. This way, the LSB of a0 won’t be after consecutive left shifts. The LSB of t1 will be 0, but that doesn’t matter since the f1 lights are connected to register a0. This was my contribution. My teammates may have used different instructions for the final CPU.

### Trigger and Reset

<img width="490" alt="Picture3" src="https://github.com/r0n1tr/team21/assets/133985295/5047ff36-411a-4192-9f02-622f96c5dc7d">

With how the trigger and reset (rst) signals were defined, I felt that the best way to implement it was by manipulating what instruction word gets executed by the CPU. 

For the trigger signal, we want the F1 machine code to be executed, so with the aid of a multiplexer, the trigger enables the CPU to execute instructions as normal when it's high, and executes NOP when trigger is low. 

For the CPU to execute instructions as normal, rst must be low. If rst is high, we continuously run " li a0,0 " until it's low. Since rst is defined to reset the processor and start the f1 programme again, the CPU will execute the f1 programme after rst is deasserted. ( with trigger being asserted)

This was the original idea. To make it more simple, the PC_mux is now a 4-input mux to accomodate the rst and trigger signals.

## Pipelined CPU

### Hazard Unit

With the CPU now pipelined, we had to implement a hazard unit to combat any data or control hazards. For the data hazards, we simply had to compare the source registers to the destination registers. We also have to check if the destination register is being written to. I thought that was it and I wrote logic that forwarded data from the memory or write back stage of the pipelined CPU. I forgot to factor one important thing, what if the destination register is the zero register? Then no forwarding would be needed. I only realised this after referring to Digital Design and Computer Architecture: RISC-V Edition by Sarah Harris, David Harris. 
#### Hazard_unit.sv
```verilog
always_comb begin
    // rs1 forwarding to avoid data hazards
    if ((rs1e == rdm) && regwritem && (rs1e != 0))          forwardae = 2'b10; 
    else if ((rs1e == rdw) && regwritew && (rs1e != 0))     forwardae = 2'b01; // forward (writeback stage)
    else                                                    forwardae = 2'b00; // no hazard --> no forwarding needed
    // rs2 forwarding to avoid data hazards
    if (((rs2e == rdm) && regwritem) && (rs2e != 0))        forwardbe = 2'b10; // forward (memory stage)
    else if ((rs2e == rdw) & regwritew && (rs2e != 0))      forwardbe = 2'b01; // forward (writeback stage)
    else                                                    forwardbe = 2'b00; // no hazard --> no forwarding needed
```
To handle a load word hazard, I stalled the fetch and decode stages of the pipelined CPU the data can be forwarded once it reached the write back stage. 

```verilog
    // stall if load instruction is executed when there's a data dependency on the next intruction (which is a hazard)
    loadstall = (resultsrce == 3'b001) && ((rs1d == rde) | (rs2d == rde));
    stallf  = loadstall;                      // stall program counter if a branch or load instrctuon is executed

    stalld  = ~(~loadstall | rst | ~trigger);
```
Note: stalld = loadstall was my contribution , and resultsrce == 3'b001 replaced ResultSrcE[0] . These changes made by the my teammates were neccesary to ensure the CPU worked efficiently. 

For control hazards, we flush the decode and execute stages of the pinelined CPU. Originally, flushd and flushe were as follows
``` verilog
flushd = PCSrc;
flushe = loadstall | PCSrc;
```
However, these have then been modified to work with our CPU.
``` verilog
    flushd  = (pcsrce == 2'b01 || pcsrce == 2'b10);              // Flush if branching
    flushe  = (pcsrce == 2'b01 || pcsrce == 2'b10) || loadstall; // Flush if branching or load instruction introduces a bubble

end
```
## Pipelined CPU with Cache

To decide on what type of cache to implement, I felt that we need to first get a one way cache working before getting two way working. With the help of Daniel, I got to implement the one way cache and sucessfully test it on it's on and with the pipelined CPU. When Peter Cheung taught us about cache, he used an exambple of taking a book from a shelf. I used that example to design the one way cache. To describe what my cache does, you're taking a row of books ( a set) from a designated shelf ( from the cache memory) and are comparing it to anther set of books, i.e when comparing tags and checking the V flag. If it's a hit, you send a copy of books ( not including the tag or V flag) out. If it's a miss, you buy the correct books, replace them in your set and but the set back on the shelf. 

One issue would've been readability, so I split the data up. 
``` verilog
// logic declared before this part of the code
        cache_set = cache_memory[din_set]; 
        V = cache_set[59]; 
        cache_tag = cache_set[58:32]; 
        cache_data = cache_set[31:0]; 

        hit = V && (din_tag == cache_tag) && (resultsrcm == 3'b001) && ~we;
        if (hit) assign dout = cache_data; 
        else begin
            assign dout = din; // since we have to go to memory 
            assign cache_set = {1'b1, din[31:5], rd}; // assign new memory to cache
            assign cache_memory[din_set] = cache_set; 
        end
```
The (resultsrcm == 3'b001) && ~we being added to the hit signal ensures that we're only using the cache when a store word or load word instruction is being executed by the CPU.

The idea of resetting the cache memory came from Daniel. If rst is asserted, the processor restarts and the data in the cache memory is now useless. Initially, we just set the V flag to zero for all sets in the cache, but if that stops the hit from being asserted, then we can set all sets in the cache memory to 60'b0 as all the 60 bits of the sets of the cache are now 0XXXXX.........X, where X is a don't care. Credit to Ronit for pointing that out.

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

<img width="547" alt="top_memory" src="https://github.com/r0n1tr/team21/assets/133985295/65bc2f61-6ff7-4edd-81c8-610baffb31ed">

Circuit designed by Daniel.

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

With the cache ready, we can now test it.



<img width="978" alt="jpepkfpwkf wlf" src="https://github.com/r0n1tr/team21/assets/133985295/846a558e-f02e-4c66-a1d1-a736185fbaf6">

Color codes:
- Clock: Yellow
- top_memory.sv input/output: Red
- Cache signals: Green
- Demultiplexer input/output(excluding select): Orange
- Data Memory input/output: Blue
- Multiplexer input/output(excluding select): Purple

Above are the waveforms you’d get as a result of running the cahce_1wtb.cpp testbench. Initially, the testbench was made to test the reset of the cache, but it also demonstrated the cache working with all possible scenarios, a hit and a miss alongside a reset.

#### Scenario 1: A Miss

<img width="406" alt="khiho" src="https://github.com/r0n1tr/team21/assets/133985295/35262436-c9a0-46d8-b107-7010d041351f">

Initially, din is 0x0. The tags of din and the cache match, but V=0 in set 000, so it’s a miss. Therefore, the output of the cache is the input, i.e.  dout = din. 
That’s fed into the demultiplexer, which directs the data to the data memory since the hit signal controls it. Data memory retrieves 0XF4F3F2F1 and is sent to input0 of the multiplexer, which outputs output0 since the hit signal also controls the multiplexer. Therefore, read_data = mem[0x0] from the data memory.

At the same time, the output of data memory, readdata, is fed back to the cache. rd = readdata.
Because of the miss, mem[0x0] of the cache gets overwritten to 0x8000000F4F3F2F1. Data is written back by the following concatenation. 

``` verilog  
cache_set = {1'b1, din[31:5], rd};
cache_memory[din_set_sel] = cache_set;
```

#### Scenario 2: A Hit

<img width="904" alt="fjoejfow" src="https://github.com/r0n1tr/team21/assets/133985295/9830da9c-f16e-4274-b946-f691d5ca650c">

Let's focus on the second clock cycle when alu_result = 0x4, the cache checks mem[0x1], the respective set of alu_result. The tags match and V = 1, so the hit signal stays high. Hit is high in the first cycle because after the miss, the correct data got written to the cache and all the conditions are satisfied for hit to go high. 

``` verilog
hit = (din_tag == cache_tag) & V;
```
The cache outputs the data from its memory, i.e dout = mem[0x1] = 0x000000C1. The demultiplexer outputs this to output1, which is connected to the multiplexer at the end. The mux outputs this, giving us read_data = 0x000000C1, which was retrieved from the cache.

#### Scenario 3: A Reset

<img width="1037" alt="Screenshot 2023-12-15 012008" src="https://github.com/r0n1tr/team21/assets/133985295/ed44ad94-7c3a-4f08-bc1e-f8a0aaae8687">


The reset just sets V = 0 for all sets in the cache. As you can see, cache_memory[0], cache_memory[1], cache_memory[3], and cache_memory[5] have have been reset. The rest of the sets had V = 0 before the reset, hence no change. Note: The above reset result was done by setting the V flag of each set of the cache to 0. This has been changed to setting all 60 bits of the sets of the cache memory to zero, as mentioned earlier. The test for that reset mechanism working wasn't documented.

You may notice that cache_memory[0] gets overwritten to 0x8000000F4F3F2F1. alu_result = 0x0 after the second clock cycle. This is scenario 1 happening.

### Additional Contributions

- Helped debug the lab 4 cpu
- Generalised a multiplexer and made a demultiplexer
- Used my one-way cache as the basis for the two-way cache, which Daniel then completed.

## Conclusion

I enjoyed working with the RISCV CPU and with my team. Even though I got stuck with the test bench in Lab 4, it didn't stop me from doing more in the actual project. This project enabled me to improve my skills in System Verilog and debugging code. It also allowed me to prove that when it comes to writing code, a messy, inefficient but working code can always be re-formatted and made efficient, whereas an efficient, properly formatted code that doesn't run, can't be fixed until you do it the first way. That is how I got the one-way cache working, and it's how I'll encourage others to tackle problems in writing code. I'll also continue to draw out logical circuits, making it easier to implement on System Verilog.   

