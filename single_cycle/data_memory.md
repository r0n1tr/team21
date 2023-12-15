# Data Memory 

### Purpose

To allow loading and storing of data in various formats.

### Inputs

 - `clk`                            -  Writing to memory is synchronous
 - `[ADDRESS_WIDTH-1:0] a`          -  Address to store data to or load data from
 - `we`                             -  write enable
 - `[DATA_WIDTH-1:0] writedata`     -  Data to write to memoory
 - `[2:0] memcontrol`               -  Describes exact load/store instruction to execute (is equivalent to `funct3`)

### Outputs

- `[DATA_WIDTH-1:0] readdata` -  Data read from the memory in a load instruction

### Implementation notes

In order to store and retrieve data, the data memory uses a similar structure to the register file (but with only one read port). The data memory has a capacity of `MEM_SIZE` bytes, with each byte having its own address.

However, much of the complexity of the module comes from accomodating the various possible load/store instructions indicated by `memcontrol`, as well as dealing with endiannes. Different instructions affect the particular addresses to store to and what format loaded data should be in. We go through these possibilities below.

#### Loading data

Instruction `LB` simply takes the byte at the provided address, and outputs a 32-bit sign-extended version of it.

Instruction `LBU` is similar to `LB`, but instead zero-extends the loaded byte.

Instruction `LH` loads either the upper half or lower half of a 32-bit word. In order to ensure we only retrieve the upper or lower half, we calculate a base addres as follows:

```verilog
assign baseaddress_half = a & ~(ADDRESS_WIDTH'('b1));
```

This ensures that e.g. for a word spanning addresses 0, 1, 2, 3, that addresses 1 and 3 become 0 and 2 respectively (i.e, the nearest multiple of 2 less than `a`). From there we can treat `baseaddress_half` as the address of the upper byte of the half, and `baseaddress_half + 1` as the address of the lower byte of the half (bearing in mind this is little endian). We then sign extend the resulting 2 byte word to 4 bytes, ready for output. 

Instruction `LHU` is similar to `LH` but instead of sign extension, we perform zero extension.

Instruction `LW` uses a similar to `LH` and `LHU` to decide on a base address:

```verilog
assign `baseaddress_half` = a & ~(ADDRESS_WIDTH'('b11));
```

Here, however, we ensure that e.g. 0, 1, 2, 3 all get mapped to 0 (i.e, the nearest multiple of 4 less than `a`).

We can then load the entire word starting with `baseaddress_word + 3` as the most significant byte, and `baseaddress_word + 0` as the least significant byte.

#### Storing data

Since we have already calculated `baseaddress_half` and `baseaddress_word`, the store instructions are much less involved.

Instruction `SB` simply writes a byte to the provided address.

Instruction `SH` writes the lowest byte of the provded `writedata` to address `baseaddress_half + 1`, and the byte above the lowest byte to `baseaddress_word`. This is in accordance with little endian.

Instruction `SW` writes the entirety of `writedata` to addresses `baseaddress_word + 0...3`, but once again reverses the order of the bytes so that the stored data in little endian.



