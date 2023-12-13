## Table of Contents

### Processor
- Single Cycle
	- F1 Program(Ronit)
	- Program Counter (Danial)
	- Instruction Memory (Ziean)
	- Control Unit (Ziean)
	- ALU (Ronit)
	- Register File (Ronit)
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

![Hierarchical Design](https://github.com/r0n1tr/team21/blob/main/hierarchy.png)

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

```systemverilog 
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

![mem_files](https://github.com/r0n1tr/team21/blob/main/mem_files.png)

By organizing our instruction memory files in a separate folder with corresponding .mem and .asm files it was easy to navigate to different test assembly programs to check different functionalities. 

### Program Counter

The PC was designed as such:
- pc_mux.sv
- pc_reg.sv
- top_pc.sv



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

By adding a trigger signal to our program counter we could control the CPU's ON/OFF state with a click of a button so that in the test bench unless the trigger was high the CPU would not execute the instructions/assembly.

When we were looking to implement the jump instructions, instead of adding another multiplexer to decide if we are jumping we decided it would be more efficient to implement PCSRC in a way where it was a 2-bit signal and increased the inputs into PC mux. This meant we could choose whether we wanted to take the input of the next instruction within the memory(pcplus4 ), the target program(for jump and branch or the address directly from the output of our ALU.

![image](https://github.com/r0n1tr/team21/assets/147700987/87b04ed4-74a7-41d8-a449-4ef101e42f94)

### Data Memory 





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

## Single Cycle CPU: F1

<iframe width="560" height="315" src="https://youtube.com/shorts/pcnGlPFE5ms?feature=share" frameborder="0" allowfullscreen></iframe>

![F1 Waveform](https://github.com/r0n1tr/team21/blob/main/f1_waveform.png)

## Single Cycle CPU: PDFs


**insert evidence**


## Pipelining with Hazard Unit

Added Files:
- pipe_fetch.sv
- pipe_decode.sv
- pipe_execute.sv
- pipe_memory.sv
- hazard_unit.sv

```verilog 
// pipe fetch
always_ff @ (posedge clk) begin
    if(clr) begin
        instrd   <= 32'b0;
        pcd      <= 32'b0;
        pcplus4d <= 32'b0;
    end
    else if(~en_b) begin
        instrd   <= instrf;
        pcd      <= pcf;
        pcplus4d <= pcplus4f;
    end
end

// pipe decode
always_ff @ (posedge clk) begin
    if(clr) begin
        regwritee   <= 1'b0;
        resultsrce  <= 2'b0;
        memwritee   <= 1'b0;
        jumpe       <= 1'b0;
        branche     <= 1'b0;
        alucontrole <= 3'b0;
        alusrce     <= 1'b0;
        jalre       <= 1'b0;
  
        rd1e     <= 32'b0;
        rd2e     <= 32'b0;
        rs1e     <=  5'b0;
        rs2e     <=  5'b0;
        pce      <= 32'b0;
        rde      <=  5'b0;
        immexte  <= 32'b0;
        pcplus4e <= 32'b0;
    end

    else begin
        regwritee   <= regwrited;
        resultsrce  <= resultsrcd;
        memwritee   <= memwrited;
        jumpe       <= jumpd;
        branche     <= branchd;
        alucontrole <= alucontrold;
        alusrce     <= alusrcd;

        rd1e     <= rd1d;
        rd2e     <= rd2d;
        rs1e     <= rs1d;
        rs2e     <= rs2d;
        pce      <= pcd;
        rde      <= rdd;
        jalre    <= jalrd;
        immexte  <= immextd;
        pcplus4e <= pcplus4d;
    end
end

// pipe execute
always_ff @(posedge clk) begin
    regwritem  <= regwritee;
    resultsrcm <= resultsrce;
    memwritem  <= memwritee;
    
    aluresultm <= aluresulte;
    writedatam <= writedatae;
    rdm        <= rde;
    pcplus4m   <= pcplus4e;
end

// pipe memory
always_ff @(posedge clk) begin  
    regwritew  <= regwritem;
    resultsrcw <= resultsrcm;

    aluresultw <= aluresultm;
    readdataw  <= readdatam;
    rdw        <= rdm;
    pcplus4w   <= pcplus4m;
end
```

Our implemented synchronous block with implicit signals omitted. This is to show the logic within each register at each stage of the pipeline in order to reduce time taken for programs to run. We have added a 'clear' signal to our first two registers as they are controlled by the hazard unit to either stall or flush the register of its information stored.


#### Hazard Unit:

```verilog 
always_comb begin
    // rs1 forwarding to avoid data hazards
    if (((rs1e == rdm) && regwritem) && (rs1e != 0)) forwardae = 2'b10; 
    else if ((rs1e == rdw) & regwritew)              forwardae = 2'b01; // forward (writeback stage)
    else                                             forwardae = 2'b00; // no hazard --> no forwarding needed
    // rs2 forwarding to avoid data hazards
    if (((rs2e == rdm) && regwritem) && (rs2e != 0)) forwardbe = 2'b10; // forward (memory stage)
    else if ((rs2e == rdw) & regwritew)              forwardbe = 2'b01; // forward (writeback stage)
    else                                             forwardbe = 2'b00; // no hazard --> no forwarding needed
    // stall if load instruction is executed when there's a data dependency on the next intruction (which is a hazard)
    loadstall = (resultsrce == 3'b001) && ((rs1d == rde) | (rs2d == rde));
    stallf  = loadstall;                      // stall program counter if a branch or load instrctuon is executed

    stalld  = ~(~loadstall | rst | ~trigger); 
    flushd  = (pcsrce == 2'b01 || pcsrce == 2'b10);              // Flush if branching
    flushe  = (pcsrce == 2'b01 || pcsrce == 2'b10) || loadstall; // Flush if branching or load instruction introduces a bubble

end
```

We took advice from the textbook:  Digital Design and Computer Architecture: RISC-V Edition by Sarah Harris, David Harris - Section 7.5.3 Hazards. This proved to be particularly useful as it demonstrated the different data and control hazards that could potentially come up on compilation. Hazards such as requiring stalls for the values to be computed in time for the next instruction to use it, which were the reasonings for the forwarding if/else logic. As well as using clear/flush signals to clear the pipeline of data in order to not accidentally use outdated information for the current instruction. Additional implementations to the pipeline were discussed such as adding a clear signals to the other two registers: execute and memory, but quickly realized they were redundant and all hazards could be avoided by simply reading in the current signals of each pipeline register and making sure the first two either stalled or flushed. 


#### Branch Decoder:

```verilog
always_comb begin
    should_branch = 1'b0; // init to 0

    if (branch) begin
        if (funct3 == 3'b000 && zero ) should_branch = 1'b1; // beq
        if (funct3 == 3'b001 && ~zero) should_branch = 1'b1; // bne

        if (funct3 == 3'b100 && ~zero) should_branch = 1'b1; // blt  
        if (funct3 == 3'b101 && zero ) should_branch = 1'b1; // bge

        if (funct3 == 3'b110 && ~zero) should_branch = 1'b1; // bltu
        if (funct3 == 3'b111 && zero ) should_branch = 1'b1; // bgeu
    end
end
```

**Ziean add explanation to this cos i have no idea**

## Pipelining with Data Cache: PDFs

**insert evidence**


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
|R| add, sub, sll, xor, slt,srl, sra, or, and| 
|B| beq, bne, blt, bge, bltu, bgeu|
|I| addi, jalr, lw, slli, slti |
|S| sw
|U| lui, auipc
|J| jal|

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



