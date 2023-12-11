// verilator lint_off UNUSED
module top_control_unit (
    input  logic [31:0] instr,  // 32-bit instruction
    input  logic        zero,   // zero flag

    output logic [1:0] pcsrc,
    output logic [2:0] resultsrc,
    output logic       memwrite,
    output logic       alusrc,
    output logic [2:0] immsrc,
    output logic       regwrite,
    output logic [2:0] memop,

    output logic [3:0] alucontrol
);
  
logic [1:0] aluop;
logic       branch;        // whether we are currently executing a branch instruction
logic       should_branch; // whether we are currently executing a branch instruction AND that instruction's condition has been met
logic       jump; 
logic       jalr;

assign memop = instr[14:12]; // memop = funct3. (placing here rather than linking memory directly to funct3 to make pipelining easier. not placing in main decoder as this will only ever be used if executong a load/store instruction, so it doesnt matter if this is set when not doing load/store instructions)
    
main_decoder main_decoder(
    .op(instr[6:0]),
    .zero(zero),  

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

endmodule
// verilator lint_on UNUSED

