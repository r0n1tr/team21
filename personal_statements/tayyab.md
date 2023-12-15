# Mohammed Tayyab's Personal Statement

## Singl-cycle Processor

### F1 lighting machine code

To write the machine code for the F1 lighting sequence, I took inspiration from the finite state machine from lab 3

![Picture1](https://github.com/r0n1tr/team21/assets/133985295/99ac7227-d10d-43d9-88a2-8c25e61edff8)

One would think to do a loop where you do 

SLLI a0,a0,1

ADDI a0,a0,1

And repeat, no! After the left shift, the LSB of a0 is now 0, meaning the light at the very end of the f1 light is now closed. Sure, a clock cycle is short so no one would notice the difference. However, if this were implemented on a real f1 traffic light, and someone noticed the light turning off, they’d think the problem is with the light itself. To avoid this, the following measures were taken.

<img width="436" alt="Picture2" src="https://github.com/r0n1tr/team21/assets/133985295/db31e364-511f-465a-ade6-2c1303c2c125">

As you can see on the left, a temporary register, t1, was used. This way, the LSB of a0 won’t be after consecutive left shifts. The LSB of t1 will be 0, but that doesn’t matter since the f1 lights are connected to register a0.

### Trigger and Reset

<img width="490" alt="Picture3" src="https://github.com/r0n1tr/team21/assets/133985295/5047ff36-411a-4192-9f02-622f96c5dc7d">

With how the trigger and reset (rst) signals were defined, I felt that the best way to implement it was by manipulating what instruction word gets executed by the CPU. 

For the trigger signal, we want the F1 machine code to be executed, so with the aid of a multiplexer, the trigger enables the CPU to execute instructions as normal when it's high, and executes NOP when trigger is low. 

For the CPU to execute instructions as normal, rst must be low. If rst is high, we continuously run " li a0,0 " until it's low. Since rst is defined to reset the processor and start the f1 programme again, the CPU will execute the f1 programme after rst is deasserted. ( with trigger being asserted)

## Pipelined CPU

### Hazard Unit

With the CPU now pipelined, we had to implement a hazard unit to combat any data or control hazards. For the data hazards, we simply had to compare the source registers to the destination registers. We also have to check if the destination register is being written to. I thought that was it and I wrote logic that forwarded data from the memory or write back stage of the pipelined CPU. I forgot to factor one important thing, what if the destination register is the zero register? Then no forwarding would be needed. I only realised this after referring to Digital Design and Computer Architecture: RISC-V Edition by Sarah Harris, David Harris. 
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











