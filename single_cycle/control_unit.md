# Control Unit

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


## Branch Decoder:

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