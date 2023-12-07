// verilator lint_off UNUSED
module main_decoder(
    input  logic [6:0] op,     // 7-bit opcode
    input  logic       zero,   // Zero flag
    
    // control signals
    output logic [1:0] resultsrc,
    output logic       memwrite,
    output logic       jump,
    output logic       branch,
    output logic       alusrc,
    output logic [1:0] immsrc,
    output logic       regwrite,
    output logic       jalr,

    // aluop goes to alu_decoder and is internal to top_control_unit
    output logic [1:0] aluop
);
   
// Implementation of control logic (as defined in Lecture 7 Slide 18; dont cares have been set to 0)
always_comb begin
    case (op)               
        7'b000_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b100100100000; // lw                                                              
        7'b001_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b100100001000; // I-Type (arithmetic/logical)
        7'b110_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b100100010001; // jalr
        7'b010_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b001110000000; // sw
        7'b011_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b100000001000; // R-Type (all of which are arithmetic/logical)
        7'b110_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b010000010100; // beq
        7'b110_1111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b111001000010; // jal // jump set to high

        default:     {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b111111111111;
    endcase
end

endmodule
// verilator lint_on UNUSED
