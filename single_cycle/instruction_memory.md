# Instruction Memory

The instruction memory module is very simple. It is an asychronous ROM with `MEM_SIZE` bytes of storage. It takes as input address `a` and outputs a 32-bit instruction work `instr`. 

The inputted file is expected to be in little endian form, hence why we start with `a + 3` in the following line:

```verilog
assign instr = {rom_array[a+3] , rom_array[a+2] , rom_array[a+1] , rom_array[a] }; // Little endian
```
 In this way, the MSB of instr taken from rom_array at the expected address.

 We assume that address `a` is always a multiple of 4, so each byte cannot be accessed individually. It would not make sense otherwise, as we do not ever need e.g., the LSB of an instruction. Rather, an entire instruction word must be output at `instr`. If we were to have a shared instruction and data memory, this may change, but by having them separate we are allowed to make this simplifying assumption.