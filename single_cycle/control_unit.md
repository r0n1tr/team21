# Control Unit

The control unit is tasked with taking in relevant parts of an instruction, and putting forth the correct control signals to other parts of the CPU. 
The control unit consists of several files under the ```control_unit``` folder. These files are for the following:

- [Main decoder](#main-decoder)
- [ALU decoder](#alu-decoder)
- [Branch decoder](#branch-decoder)
- [PCsrc logic](#pcsrc-logic)
- [Top control unit](#top-control-unit)

The implementation of each is detailed as follows.

## Main decoder

### Purpose

### Inputs

- `[6:0] op` - 7-bit opcode. Tells us which family of instructions are being executed.
- `zero` - The zero flag. Is asserted by the ALU when `aluresult == 0`. 

### Outputs

- `      regwrite`  - Write enable for register file
- `[2:0] immsrc`    - Tells sign extend block how the immediate is encoded in the instruction (is different for `I`, `S`, `B`, `J`, and `U` type instrutions)
- `      alusrc`    - Tells the ALU whether to use (i) two register operands or (ii) a register operand and an immediate operand
- `      memwrite`  - Write enable for memory
- `[2:0] resultsrc` - Which item the result mux should output to the result line (refer to [result mux](result_mux.md))
- `      branch`    - Whether we are executing a B-Type instruction (i.e., a branch) (refer to [branch decoder](#branch-decoder))
- `[1:0] aluop`     - Refer to [ALU decoder](#alu-decoder)
- `      jump`      - Whether we are executing a J-Type instruction (i.e., `JAL`) (refer to [branch decoder](#branch-decoder))
- `      jalr`      - Whether we are executing instruction `JALR` (refer to [branch decoder](#branch-decoder))

### Implementation notes

The main decoder simply takes the 



## ALU decoder

The zero flag can be used in interesting ways. Certain ALU operations have special meaning when the result is 0. 

For instance, if we subtract two numbers and the result is 0, we know those two numbers are equal. This is useful for instructions `BEQ` and `BNE`, as we can just tell the ALU to perform a subtraction and branch depending on the value of `zero`. This is done in the [`branch decoder`](#branch-decoder).

## Branch decoder

## PCsrc logic

## Top control unit



