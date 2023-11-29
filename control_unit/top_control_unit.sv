// verilator lint_off UNUSED
module top_control_unit (
    input  logic [31:0] instr,  // 32-bit instruction
    input  logic        zero,   // zero flag

    output logic       PCsrc,
    output logic       ResultSrc,
    output logic       MemWrite,
    output logic       ALUSrc,
    output logic [1:0] ImmSrc,
    output logic       RegWrite,

    output logic [2:0] ALUControl
);
  
logic [1:0] ALUOp;
    
main_decoder main_decoder(
    .op(instr[6:0]),
    .zero(zero),  

    .PCsrc(PCsrc),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .ImmSrc(ImmSrc),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp)
);

alu_decoder alu_decoder(
    .op(instr[6:0]),     // 7-bit opcode
    .ALUOp(ALUOp),
    .funct3(instr[14:12]), 
    .funct7(instr[31:25]), 
    .ALUControl(ALUControl)
);

endmodule
// verilator lint_on UNUSED

