// verilator lint_off UNUSED
module top_control_unit (
    input  logic [31:0] instr,  // 32-bit instruction

    // output control signals
    output logic [2:0] resultsrc,
    output logic       memwrite,
    output logic       alusrc,
    output logic [2:0] immsrc,
    output logic       regwrite,
    output logic [2:0] funct3,
    output logic       jump,
    output logic       branch,
    output logic       jalr,    // custom signal to indicate if executing jalr
    output logic [3:0] alucontrol
);
  
logic [1:0] aluop;

assign funct3 = instr[14:12]; // used by branch_decoder, data_mem
    
main_decoder main_decoder(
    .op(instr[6:0]),

    .regwrite(regwrite),
    .immsrc(immsrc),
    .alusrc(alusrc),
    .memwrite(memwrite),
    .resultsrc(resultsrc),
    .branch(branch),
    .aluop(aluop),  // aluop goes to alu_decoder
    .jump(jump),
    .jalr(jalr)
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

