// verilator lint_off UNUSED
module main_decoder(
    input  logic [6:0] op,     // 7-bit opcode
    input  logic       zero,   // Zero flag
    
    // control signals
    output logic       regwrite,
    output logic [2:0] immsrc,
    output logic       alusrc,
    output logic       memwrite,
    output logic [2:0] resultsrc,
    output logic       branch,
    output logic [1:0] aluop,  // aluop goes to alu_decoder
    output logic       jump,
    output logic       jalr
);

// Implementation of control logic (don't cares have been set to 0)
always_comb begin
    // set control signals (other than pcsrc --> look at pcsrc_logic module for that)
    case (op)               
        7'b000_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10001_0001_00000;  // load instructions
        7'b010_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b00011_1000_00000;  // store instructions
        7'b011_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10000_0000_01000;  // R-Type (all of which are arithmetic/logical)
        7'b110_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b00100_0000_10100;  // B-Type
        7'b001_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10001_0000_01000;  // I-Type (arithmetic/logical ones only)
        7'b110_1111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10110_0010_00010;  // jal
        7'b110_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b10001_0010_00001;  // jalr
        7'b011_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b11000_0011_00000;  // lui
        7'b001_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b11000_0100_00000;  // auipc

        default:     {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump, jalr} = 14'b11111_1111_11111;  // should never execute
    endcase
end

endmodule
// verilator lint_on UNUSED
