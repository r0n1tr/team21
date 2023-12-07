// verilator lint_off UNUSED
module top_control_unit (
    input  logic [31:0] instr,  // 32-bit instruction
    input  logic        zero,   // zero flag

    // output control signals
    output logic       regwrite,
    output logic [1:0] resultsrc,
    output logic       memwrite,
    output logic       jump,
    output logic       branch,
    output logic [2:0] alucontrol,
    output logic       alusrc,
    output logic [1:0] immsrc,
    output logic       jalr  // custom signal to indicate if executing jalr
);
  
logic [1:0] aluop;
    
main_decoder main_decoder(
    .op(instr[6:0]),
    .zero(zero),  

    .regwrite(regwrite),
    .resultsrc(resultsrc),
    .memwrite(memwrite),
    .jump(jump),
    .branch(branch),
    .alusrc(alusrc),
    .immsrc(immsrc),
    .jalr(jalr),

    .aluop(aluop)
);

alu_decoder alu_decoder(
    .op(instr[6:0]),
    .aluop(aluop),
    .funct3(instr[14:12]), 
    .funct7(instr[31:25]),

    .alucontrol(alucontrol)
);

endmodule
// verilator lint_on UNUSED

