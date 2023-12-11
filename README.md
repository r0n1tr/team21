## Table of Contents

### Processor
- Single Cycle
	- F1 Program(Ronit)
	- Program Counter (Danial)
	- Instruction Memory (Ronit)
	- Control Unit (Ziean)
	- ALU (Ronit)
	- Data Memory (Danial)

- Pipeline 
	- Programs for Pipelined CPUs (Ronit, Danial and Ziean)

- Data Cache
	- Data Cache (Danial and Tayyab)

- Others
	- Result Verification (Tayyab, Ronit, Danial  Ziean)

- Top Level File
	- (Ziean, Ronit and Tayyab)

## Quick start

### Overview
#### Versions of CPU
- Single Cycle
- Pipeline
- Data Cache

**Add working evidence of each test program**


### Contribution Table

Note: 0 = Main Contributor, 1 = Co-Contributor

| Task | Files | Ziean | Ronit | Danial | Tayyab |
|-----|-------|---------------|-------|-------|---------|
|Repo Setup| .gitignore, .gitkeep...| 1 | 0|
|Entry Script| N/a| 
|F1 Program| f1_fsm.sv, load_42.fsm etc.| 1| 0||1|
|Program Counter| top_pc.sv, pcmux.sv, pcreg.sv| | 1| 0 |1|
|Instruction Memory| instr_mem.sv | 1| 0
|Control Unit | top_control.sv, main_decoder.sv, alu_decoder.sv| 0| 1|1
|ALU | top_alu.sv, alu.sv| 1| 0|
|Data Memory| data_mem.sv| ||0|
|Top Level Debugging| top.sv, cpu.sv |1|1|1|0
|**Pipeline** | ----|----|----|----|----
|Fetch Stage Register| pipe_fetch.sv| |1|0
|Decode Stage Register| pipe_decode.sv||1|0|
|Execute Stage Register| pipe_execute| |0|
|Memory Stage Register| pipe_memory.sv| |0|
|Hazard unit|Hazard_unit.sv||1||0|
|Top-Level Debugging| cpu.sv, cpu_tb.cpp|1|0|1
|**Data Cache**| ----|----|----|----|----|
|Data Cache (1-way)|cache_1w.mem, cache_1w.sv| ||1|0|
|Data Cache (2-way)| cache_2w.mem, cache_2w.sv|||0|1|
|Top-Level Debugging|

## Specifications

Implemented Specifications

|Type|Instructions|
|---|-----|
|R| add|
|B| beq, bne|
|I| addi|
|S| 
|U|
|J| jal, jalr|

General Specifications

|Property| Value|
|--|--|
|Instruction Memory size| 2^32|
|Instruction Width| 32-bit|
|Data Memory Size| |
|Data Width| 32-bit
|Data Cache Size| idk|
|Data Cache Sets| idk
|Data Cache ways| 2?
|Data Cache Block Size| idk

### File Structure

### Directories
- Folders containing files
- source files
- testbenches
- programs

### Notable Files

- README.md
- .gitignore
- shell scripts
- config file -- idk what for 
- top level file for design -> in our case cpu.sv



