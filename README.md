## Table of Contents

### Processor
- Single Cycle
	- F1 Program(Ronit)
	- Program Counter (Danial)
	- Instruction Memory (Ronit)
	- Control Unit (Ziean)
	- ALU (Ronit)
	- Data Memory (Danial and Ziean)

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

We designed our CPU in a hierarchical system as such: 

![[Pasted image 20231211172302.png]]

By allocating a folder for all relevant files for each separate 'module' within the system. This way we were able to keep an organized workspace and having updating the shell script to include folders in order for full compilation. 

### ALU

The ALU is broken down into 3 main files:
- alu_mux.sv
- alu.sv
- top_alu.sv

By having a top file for each sub-module we could call testbenches to validify functionality as well as have a concise top-most file when connecting all the modules together.



```verilog 
module top_alu #(
    parameter DATA_WIDTH = 32
)(
    input logic                         alusrc,
    input logic        [3:0]            alucontrol,
    input logic signed [DATA_WIDTH-1:0] rd1,    // comes from reg_file
    input logic signed [DATA_WIDTH-1:0] rd2,    // comes from reg_file
    input logic signed [DATA_WIDTH-1:0] immext,

    output logic signed [DATA_WIDTH-1:0] aluresult, // output from alu
    output logic                         zero       // zero flag
);
  
// output from alu_mux
logic signed [DATA_WIDTH-1:0] srcb;    

alu_mux alu_mux(
    .input0(rd2),
    .input1(immext),
    .alusrc(alusrc),
    
    .out(srcb)
);

alu alu(
    .aluop1(rd1),
    .aluop2(srcb),
    .alucontrol(alucontrol),

    .aluresult(aluresult),
    .zero(zero)
);
endmodule
```

```verilog

always_comb begin
    case(alucontrol)
        4'b0000: aluresult = aluop1  +  aluop2;       // add            
        4'b0001: aluresult = aluop1  -  aluop2;       // sub            
        4'b0010: aluresult = aluop1 <<  aluop2[4:0];  // shift left logic
        4'b0101: aluresult = aluop1  ^  aluop2;       // xor              
        4'b0110: aluresult = aluop1 >>  aluop2[4:0];  // shift right logical            
        4'b0111: aluresult = aluop1 >>> aluop2[4:0];  // shift right arithmetic         
        4'b1000: aluresult = aluop1  |  aluop2;       // or            
        4'b1001: aluresult = aluop1  &  aluop2;       // and  
        4'b0011: aluresult = (  $signed(aluop1) < $signed(aluop2)) ? 32'b1 : 32'b0; // set less than  
        4'b0100: aluresult = ($unsigned(aluop1) < $unsigned(aluop2)) ? 32'b1 : 32'b0;   // set less than unsigned    
        default: aluresult = {32{1'b1}}; // unrecognised alucontrol
    endcase
    zero = (aluresult == 32'b0); // zero flag check
end
```

The combinational block above shows all the instructions we implemented for our ALU as well as having our zero flag functionality concisely in one statement.

### Control Unit

The Control Unit is made of:
- alu_decoder.sv
- branch_decoder.sv
- main_decoder.sv
- pcsrc_logic.sv
- top_control_unit.sv

```verilog 
main_decoder main_decoder(
    .op(instr[6:0]),
    .zero(zero),  
  
    .regwrite(regwrite),
    .immsrc(immsrc),
    .alusrc(alusrc),
    .memwrite(memwrite),
    .resultsrc(resultsrc),
    .branch(branch),
    .aluop(aluop),  // aluop goes to alu_decoder
    .jump(jump),
    .jalr(jalr)
);

alu_decoder alu_decoder(
    .aluop(aluop),
    .funct3(instr[14:12]),
    .funct7(instr[31:25]),
  
    .alucontrol(alucontrol)
);

branch_decoder branch_decoder(
    .branch(branch),
    .zero(zero),  
    .funct3(instr[14:12]),

    .should_branch(should_branch)
);

pcsrc_logic pcsrc_logic(
    .should_branch(should_branch),
    .should_jal(jump),  
    .should_jalr(jalr),
    
    .pcsrc
);
```

Omitting the implicitly stated internal wires and input and output signals,. We designed the control unit in a way where we could separate decoding control signals and ALU operators into different blocks for simplicity, using combinational block as such:

```verilog

case (op)              
        7'b000_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10001_0001_00000;  // load instructions
        7'b010_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b00011_1000_00000;  // store instructions
        7'b011_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10000_0000_01000;  // R-Type (all of which are arithmetic/logical)
        7'b110_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b00100_0000_10100;  // B-Type
        7'b001_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10001_0000_01000;  // I-Type (arithmetic/logical ones only)
        7'b110_1111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10110_0010_00010;  // jal
        7'b110_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10001_0010_00001;  // jalr
        7'b011_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b11000_0011_00000;  // lui
        7'b001_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b11000_0100_00000;  // auipc
        default:     {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b11111_1111_11111;  // should never execute
    endcase
```

By adding an extra 'jalr' flag to our decoder, this allowed us to control when we wanted to store the program counter into a register ready for the return from a subroutine.

### Instruction Memory

Our instruction memory acted as an asynchronous ROM.

![[Pasted image 20231211173956.png]]

By organizing our instruction memory files in a separate folder with corresponding .mem and .asm files it was easy to navigate to different test assembly programs to check different functionalities. 

### Program Counter

The PC was designed as such:
- pc_mux.sv
- pc_reg.sv
- top_pc.sv

```verilog 
pc_reg pc_reg(
    .clk(clk),
    .next_pc(next_pc),
    
    .pc(pc)
);

pc_mux pc_mux (
    .aluresult(aluresult),
    .immext(immext),
    .pc(pc),
    .pcsrc(pcsrc),
    .rst(rst),
    .trigger(trigger),
    
    .pcplus4(pcplus4),
    .pctarget(pctarget),
    .next_pc(next_pc)
);
```

Once again omitting our wires and I/O the program counter was designed around the register and input mux and designed the adders within the logic of the pc_mux to optimize simplicity in the top file, shown below: 

```verilog
always_comb begin
    casez ({pcsrc , trigger , rst})
        4'b???1: next_pc = {32{1'b0}};   // if rst     = 1: remain at instruction 0
        4'b??00: next_pc = {32{1'b0}};   // If trigger = 0: remain at instruction 0
        4'b0010: next_pc = pcplus4;      // go to next intruction in memory
        4'b0110: next_pc = pctarget;  // jal, beq (with condition met)
        4'b1010: next_pc = aluresult;    // jalr
        default: next_pc = {32{1'b1}};   // should never execute (if pc ever becomes odd, this may be why)
    endcase
end
```

By adding a trigger signal to our program counter we could control the CPU's ON/OFF state by a click of a button so that in the test bench unless the trigger was high the CPU would not execute the instructions/assembly.

We implemented PCSRC in a way where it was a 2-bit signal as we required a 3 input PC mux. This meant we could choose whether we wanted to take the input of the next instruction within the memory, the target program or the address from the output of our ALU after using a branch or jump instruction.

### Regfile

```verilog
always_ff @(posedge clk) begin
    if(we3 && ad3 != 5'b0) ram_array[ad3] <= wd3;
end

assign ram_array[5'b0] = 32'b0; // x0 is always zero
assign rd1 = ram_array[ad1];
assign rd2 = ram_array[ad2];
assign a0  = ram_array[5'd10];
```

The regfile was designed to have 3 read ports and two write ports as usual. However, an important design was overlooked which was making register 0 (x0) immutable and set to zero. As a result, this required hours of debugging when using that register as we could not deduce the root cause.

### Sign Extend

```verilog
always_comb begin
    case (immsrc)
        3'b000:   immext = { {20{instr[31]}} , instr[31:20] };                                        // I-TYPE; sign extend 12-bit imm
        3'b001:   immext = { {20{instr[31]}} , instr[31:25] , instr[11:7] };                          // S-TYPE; sign extend 12-bit imm
        3'b010:   immext = { {20{instr[31]}} , instr[7]     , instr[30:25] , instr[11:8]  , {1'b0} }; // B-TYPE; sign extend 13-bit imm; immext used as offset to PC (so can be -ve or +ve, so needs to be sign extended)
        3'b011:   immext = { {12{instr[31]}} , instr[19:12] , instr[20]    , instr[30:21] , {1'b0} }; // J-TYPE; sign extend 21-bit imm
        3'b100:   immext = { instr[31:12], {12'b0} };                                                 // U-TYPE; set 20-bit imm as upper 20 bits, and set lower 12 bits to 0
        default:  immext = 32'hdeadbeef;   // should never execute; set imm to 'deadbeef'
    endcase
end
```

Standard combinational block to extend sign extend a 32 bit integer.


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
|Data Memory| data_mem.sv|1 ||0|
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



