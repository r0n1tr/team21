// verilator lint_off UNUSED
module main_decoder(
    input  logic [6:0] op,     // 7-bit opcode
    input  logic       zero,   // Zero flag
    
    // control signals
    output logic       regwrite,
    output logic [1:0] immsrc,
    output logic       alusrc,
    output logic       memwrite,
    output logic [1:0] resultsrc,
    output logic       branch,
    output logic [1:0] aluop,  // aluop goes to alu_decoder
    output logic       jump,
    output logic       jalr
);

// Implementation of control logic (don't cares have been set to 0)
always_comb begin
    // set control signals (other than pcsrc --> look at pcsrc_logic module for that)
    case (op)               
        7'b000_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b1001001_00000;  // load instructions
        7'b010_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b0011100_00000;  // store instructions
        7'b011_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b1000000_01000;  // R-Type (all of which are arithmetic/logical)
        7'b110_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b0100000_10100;  // B-Type
        7'b001_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b1001000_01000;  // I-Type (arithmetic/logical ones only)
        7'b110_1111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b1110010_00010;  // jal
        7'b110_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b1001010_00001;  // jalr

        default:     {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 12'b1111111_11111;  // should never execute
    endcase
end

endmodule
// verilator lint_on UNUSED
