# Data Memory 

### Purpose

To allow loading and storing of data in vavrious formats.

### Inputs

 - `clk`                            -  Writing to memory is synchronous
 - `[ADDRESS_WIDTH-1:0] a`          -  Address to store data to or load data from
 - `we`                             -  write enable
 - `[DATA_WIDTH-1:0] writedata`     -  Data to write to memoory
 - `[2:0] memcontrol`               -  Describes exact load/store instruction to execute (is equivalent to `funct3`)

### Outputs

- `[DATA_WIDTH-1:0] readdata` -  Data read from the memory in a load instruction

### Implementation notes

In order to store and retrieve data, the data memory uses a similar structure to the register file (but with only one read port). However, much of the complexity of the module comes from accomodating the various possible load/store instructions indicated by `memcontrol`. Deciding which particular addresses to store to and what format retreieved data should be in.

A large part of this module involves dealing with the bit manipulation required to correctly execute the various possible store and load instructions. In order to simplify this process, redundancy must be removed.



