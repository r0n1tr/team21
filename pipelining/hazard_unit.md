# Hazard Unit

We took advice from the textbook:  Digital Design and Computer Architecture: RISC-V Edition by Sarah Harris, David Harris - Section 7.5.3 Hazards. This proved to be particularly useful as it demonstrated the different data and control hazards that could potentially come up on compilation.

For the data dependencies, we do the obvious thing, check if any of the source registers, rs1 and rs2, were the same as the destination registers in the pipeline stages ahead. We also check if data is being written to the destination registers. However, if any of the source registers is 0, i.e the zero register, then no forwarding is needed since it's hardwired to 0.

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

However, the load word instruction required us to stall the decode and fetch stage for the pipelined CPU, allowing data to be forwarded when it reaches the write back stage.

```verilog
    // stall if load instruction is executed when there's a data dependency on the next intruction (which is a hazard)
    loadstall = (resultsrce == 3'b001) && ((rs1d == rde) | (rs2d == rde));
    stallf  = loadstall;                      // stall program counter if a branch or load instrctuon is executed

    stalld  = ~(~loadstall | rst | ~trigger);
```

FInally, the control hazard. If we branch, the decode and fetch stages of the pipelined CPU have to be flushed as the instruction after the branch instruction in the instruction memory is deemed useless. The reason we flush the execute stage of the pipelined CPU when doing a load word instruction is " to prevent bogus
information from propagating forward " (Digital Design and Computer Architecture: RISC-V Edition by Sarah Harris, David Harris)

```verilog
    flushd  = (pcsrce == 2'b01 || pcsrce == 2'b10);              // Flush if branching
    flushe  = (pcsrce == 2'b01 || pcsrce == 2'b10) || loadstall; // Flush if branching or load instruction introduces a bubble

end
```
