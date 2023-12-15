# Result mux

This module does not have its own .sv file as it is simply a generic mux. However, it is of significant and so bears explanation. For clarification, the code for `result_mux` is copied here from `cpu.sv`:

```verilog
mux3 result_mux(
    .input0(aluresult),
    .input1(readdata),
    .input2(pcplus4),
    .input3(immext), 
    .input4(pctarget),
    .input5({32{1'b0}}), // not using input 5 - set to 0 by default
    .input6({32{1'b0}}), // not using input 6 - set to 0 by default
    .input7({32{1'b0}}), // not using input 7 - set to 0 by default
    .select(resultsrc),

    .out(result)
);
```

The output of the mux is `result`. This signal appears at the input of `reg_file` at `wd3`, meaning that the output of `result_mux` is typically what we want to write to some register. Each possible output corresponds to various instructions, as detailed below.

### aluresult

Many times, the ALU will perform some operation whose result we wish to store in a register. A common case may be with the execution of any R-Type instructions, as they all use the ALU. For example, executing `add x5, x6, x7` will set `aluresult = x6 + x7`. Then `result_mux` can output `aluresult` so that `x6 + x7` can be written to `x5`, as intended.

### readdata

Whenever executing a load instruction, data must be retrieved from data memory and stored in a register. To do this, the data is output from `data_mem` and sent to `result_mux`, which in turn outputs the output of `data_mem` so that it can be written to the `reg_file`.

### pcplus4

For instructions `JAL` and `JALR`, we wish to perform `rd = PC + 4`. `PC + 4` is calculated and output by PC module, and so can be used directly by `result_mux`, which can then feed it to the register file for storage as desired.

### immext

For instruction `LUI`, we wish to store in some register `{imm, 12'h000}` (i.e, the 5 byte immediate in the instruction followed by three zeros). `{imm, 12'h000}` is produced by the sign exend block already (see [sign extend](sign_extend.md)). In order to get this value stored in a register, we can make it a possible output of `result_mux`. Whenever we are executing `LUI`, `immext` is set as `result` and written to the appropriate register. In this way, `LUI` is implemented.

### pctarget

This is for instruction `AUIPC`. This is similar to instruction `LUI` [above](#immext), but now we want to write the sum of `{imm, 12'h000} = immext` and the PC to a register. `immext + pc` is already cacluated and output by the PC module via a signal called `pctarget` (just like how the PC outputs `pcplus4`). We just set this as input to `result_mux` and now we are able to perform `rd = {imm, 12'h000} + PC = immext + PC`. In this way `AUIPC` is implemented.
