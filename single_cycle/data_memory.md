# Data Memory 

### Purpose

To allow loading and storing of data in vavrious formats.

### Inputs

 - `logic                     clk`        -  Writing to memory is synchronous
 - `logic [ADDRESS_WIDTH-1:0] a`          -  Address to store data to or load data from
 - `logic                     we`         -  write enable
 - `logic [DATA_WIDTH-1:0]    writedata`  -  Data to write to memoory
 - `logic [2:0]               memcontrol` -  Describes exact load/store instruction to execute (is equivalent to `funct3`)

### Outputs

- `logic [DATA_WIDTH-1:0] readdata` -  Data read from the memory in a load instruction

