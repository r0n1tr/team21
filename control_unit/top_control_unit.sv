// verilator lint_off UNUSED
module top_control_unit (
    input  logic [31:0] instr,  // 32-bit instruction
    input  logic        zero,   // zero flag

    output logic [1:0] pcsrc,
    output logic [1:0] resultsrc,
    output logic       memwrite,
    output logic       alusrc,
    output logic [1:0] immsrc,
    output logic       regwrite,
    output logic branch,
    output logic jump,
    output logic jalr,

    output logic [2:0] alucontrol
);
  
logic [1:0] aluop;
    
main_decoder main_decoder(
    .op(instr[6:0]),
    .zero(zero),  

    .branch(branch),
    .jump(jump),
    .jalr(jalr),
    .resultsrc(resultsrc),
    .memwrite(memwrite),
    .alusrc(alusrc),
    .immsrc(immsrc),
    .regwrite(regwrite),
    .aluop(aluop)
);

alu_decoder alu_decoder(
    .op(instr[6:0]),     // 7-bit opcode
    .aluop(aluop),
    .funct3(instr[14:12]), 
    .funct7(instr[31:25]), 
    .alucontrol(alucontrol)
);

endmodule
// verilator lint_on UNUSED

