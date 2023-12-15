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

To be a high level starting point of decoding instructions.

### Inputs

- `[6:0] op` - 7-bit opcode. Tells us which family of instructions are being executed.

### Outputs

- `      regwrite`  - Write enable for register file
- `[2:0] immsrc`    - Tells sign extend block how the immediate is encoded in the instruction (is different for `I`, `S`, `B`, `J`, and `U` type instrutions)
- `      alusrc`    - Tells the ALU whether to use (i) two register operands or (ii) a register operand and an immediate operand
- `      memwrite`  - Write enable for data memory
- `[2:0] resultsrc` - Which item the result mux should output to the result line (refer to [result mux](result_mux.md))
- `      branch`    - Whether we are executing a B-Type instruction (i.e., a branch) (refer to [branch decoder](#branch-decoder))
- `[1:0] aluop`     - Refer to [ALU decoder](#alu-decoder)
- `      jump`      - Whether we are executing a J-Type instruction (i.e., `JAL`) (refer to [branch decoder](#branch-decoder))
- `      jalr`      - Whether we are executing instruction `JALR` (refer to [branch decoder](#branch-decoder))

### Implementation notes

The main decoder simply takes the opcode of the instruction we are trying to execute, and sets the appropriate signals.
What took more care was how to organise these signals. The [top control unit's](#top-control-unit) outputs can be split into two categories:

1. those that depend wholely on `op`
2. those that depend partially on `op`, and partially on some other signals

For those in category 1, we can send the outputs straight to the outputs of [top control unit](#top-control-unit).

For those in category 2, we output those signals to other modules, which make further decisions based on those other signals. The benefit of this structuring is that no single module is making massive amounts of decision making, which makes it easier to follow the logic and debug. 

These other modules are the [ALU decoder](#alu-decoder), [branch decoder](#branch-decoder) and [PCsrc logic](#pcsrc-logic), describes below.

## ALU decoder

### Purpose

To decide what operation the ALU should be carrying out on its operands depending on which particular instruction is being executed.

### Inputs

- `[6:0] op`     - 7-bit opcode. Tells us which family of instructions are being executed
- `[1:0] aluop`  - 2-bit ALU opcode. Tells us which family of instructions are being executed (in most instances we just use this 2-bit value rather than the 7-bit `op`)
- `[2:0] funct3` - Further defines which instruction is being executed
- `[6:0] funct7` - Further defines which instruction is being executed
 

### Outputs

- `[3:0] alucontrol` - Control signal that tells the ALU which operation to execute

### Implementation notes

In order to allow us to be particular about which instruction is being decoded, we have multiple inputs specifying the instruction underway. Breaking ip the inputs this way allows us to only decode based on them when necessary, otherwise they can just be set to `?` (don't care).

`aluop == 2'b0` is the default value of `aluop` output by the [main decoder](#main-decoder). This is because we also decided any don't cares will be set to 0 in the [main decoder](#main-decoder) output, hence `aluop` is all zeros when we dont care what it is. 

When `aluop == 2'b00`: We set `alucontrol = 4'b0000` by default, as not all instructions need to use ALU. Since the ALU is not used, the value `4'b0000` is arbitrary.

When `aluop == 2'b01`: We set `alucontrol` such that the ALU carries out an operation relevant to the particular branch intruction we are executing (see [branch decoder](#branch-decoder)). The particular branch being executed is indicated by `funct3`. However, the least significant bit of `funct3` is ignored. This is because the two branch instructions given when `funct3 == 0` versus when `funct3 == 1` have compliment conditions, meaning they require the same ALU operation (again, see [branch decoder](#branch-decoder)).

When `aluop == 2'b10`: We are executing an arithmetic or logical instruction. This makes setting the value of `alucontrol` straightforward, as we just set it top carry out the desired arithmetic or logical operation. The particular operation is defined by `funct3`. However for two values of `funct3`, `funct7[5]` is also used:

1. When `funct3 = 3'b000`, `funct7[5] == 1` indicates a `SUB` instruction **if we are not using an immediate operand** (which we check for using `op`). Else we are doing `ADD` or `ADDI`.
2. When `funct3 = 3'b101`, `funct7[5] == 1` indicates `SRA`, else `SRL`.

We need to be careful about whether we are using an immediate in (1) as `funct7` is not usable when we are executing an I-Type instruction. But `aluop == 2'b10` is used for all arithmetic/logical instructions, regardless of if they are I- or R-Type.

`aluop == 2'b11` is unused.

## Branch decoder

### Purpose

To decide whether we should branch based on the current instruction.

### Inputs

- `      branch` - Whether we are currently executing a branch instruction
- `      zero`   - The zero flag. Is asserted by the ALU when `aluresult == 0`. 
- `[2:0] funct3` - Used to define exactly which branch instruction is executed (if any)

### Outputs

- `should_branch` - Indicates whether we should branch based on the provided inputs.

### Implementation notes

The logic for this module first checks whether we are branching. If not, `should_branch` is 0 and we should not branch.

Otherwise, we look at which branch instruction is being executed. If it's condition is met then we indicate we should branch by asserting `should_branch`.

All branch condtions only need the `zero` flag. The zero flag can be used this way as certain ALU operations have special meaning when the `aluresult == 0`. 

For instance, if we subtract two numbers and the result is 0, we know those two numbers are equal. This is useful for instructions `BEQ` and `BNE`, as we can just tell the ALU to perform a subtraction and branch depending on the value of `zero`.

Likewise, if we tell the ALU to perform operation `SLT` then the `zero` flag is low if `rs1 < rs2`. Otherwise, `rs1 >= rs2` and the `zero` flag is high. In this way, the zero flag can also be checked for instructions `BLT` and `BGE`.

Instructions `BLTU` and `BGEU` follow a similar process to the above, using `SLTU` in the ALU.

## PCsrc logic

### Purpose

To decide on a value for `pcsrc`.

### Inputs

`should_branch` - Asserted if branch instruction being executed AND branch condition met
`should_jal`    - Asserted if executing `JAL`
`should_jalr`   - Asserted if executing `JALR`

### Outputs

`[1:0] pcsrc` - Indicates what value the PC shoud next take on

### Implementation notes

This branch simply encapsulates the decisions needed to decide on PC in a separate module. This allows us to just input the relevant signals and get `pcsrc`, rather than trying to force this logic in another module where it would'nt make sense to put it.



## Top control unit

### Purpose

To act as the interface of the control unit for the rest of the CPU. To connect together all the aforemention control unit subcomponents.

### Inputs

- `[31:0] instr`    - 32-bit instruction
- `       zero`     - The zero flag. Is asserted by the ALU when `aluresult == 0`. 

### Outputs

- `[1:0] pcsrc`     - Indicates what value the PC shoud next take on
- `[2:0] resultsrc` - Which item the result mux should output to the result line (refer to result mux)
- `      memwrite`  - Write enable for data memory
- `      alusrc`    - Tells the ALU whether to use (i) two register operands or (ii) a register operand and an immediate operand
- `[2:0] immsrc`    - Tells sign extend block how the immediate is encoded in the instruction (is different for `I`, `S`, `B`, `J`, and `U` type instrutions)
- `      regwrite`  - Write enable for register file
- `[2:0] funct3`    - Only used externally by data memory as `memcontrol` (to know what kind of load/store operation to perform)
- `[3:0] alucontrol`- Control signal that tells the ALU which operation to execute

### Implementation notes

This module is modtly straightforard. Like most other 'top files' in this CPU, we are just encapsulating the behaviour of the control unit in an easy to use manner. All submodueles are connected together, and the relevant outputs of each are set as outputs for the entire control unit. 

One signal that has not been mention above is `memcontrol`. this is equivalent to `funct3`, but we just forward that to the data memory so that it can know what particular load/store instruction is being executed. 


