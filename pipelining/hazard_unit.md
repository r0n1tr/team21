# Hazard Unit

```verilog 
always_comb begin
    // rs1 forwarding to avoid data hazards
    if (((rs1e == rdm) && regwritem) && (rs1e != 0)) forwardae = 2'b10; 
    else if ((rs1e == rdw) & regwritew)              forwardae = 2'b01; // forward (writeback stage)
    else                                             forwardae = 2'b00; // no hazard --> no forwarding needed
    // rs2 forwarding to avoid data hazards
    if (((rs2e == rdm) && regwritem) && (rs2e != 0)) forwardbe = 2'b10; // forward (memory stage)
    else if ((rs2e == rdw) & regwritew)              forwardbe = 2'b01; // forward (writeback stage)
    else                                             forwardbe = 2'b00; // no hazard --> no forwarding needed
    // stall if load instruction is executed when there's a data dependency on the next intruction (which is a hazard)
    loadstall = (resultsrce == 3'b001) && ((rs1d == rde) | (rs2d == rde));
    stallf  = loadstall;                      // stall program counter if a branch or load instrctuon is executed

    stalld  = ~(~loadstall | rst | ~trigger); 
    flushd  = (pcsrce == 2'b01 || pcsrce == 2'b10);              // Flush if branching
    flushe  = (pcsrce == 2'b01 || pcsrce == 2'b10) || loadstall; // Flush if branching or load instruction introduces a bubble

end
```

We took advice from the textbook:  Digital Design and Computer Architecture: RISC-V Edition by Sarah Harris, David Harris - Section 7.5.3 Hazards. This proved to be particularly useful as it demonstrated the different data and control hazards that could potentially come up on compilation. Hazards such as requiring stalls for the values to be computed in time for the next instruction to use it, which were the reasonings for the forwarding if/else logic. As well as using clear/flush signals to clear the pipeline of data in order to not accidentally use outdated information for the current instruction. Additional implementations to the pipeline were discussed such as adding a clear signals to the other two registers: execute and memory, but quickly realized they were redundant and all hazards could be avoided by simply reading in the current signals of each pipeline register and making sure the first two either stalled or flushed. 