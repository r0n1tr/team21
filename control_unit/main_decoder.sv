// verilator lint_off UNUSED
module main_decoder(
    input  logic [6:0] op,     // 7-bit opcode
    input  logic       zero,   // Zero flag
    
    // control signals
    
    output logic [1:0] resultsrc,
    output logic       memwrite,
    output logic jump,
    output logic branch,
    output logic       alusrc,
    output logic [1:0] immsrc,
    output logic       regwrite,

    // aluop goes to alu_decoder
    output logic [1:0] aluop
);

// Implementation of control logic (as defined in Lecture 7 Slide 18; dont cares have been set to 0)
always_comb begin
    case (op)               
        7'b000_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, jump, aluop} = 11'b10010010000;             // lw                                                              
        7'b001_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, jump, aluop} = 11'b10010000010;             // I-Type (arithmetic/logical)
        7'b110_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, jump, aluop} = 11'b10010001000;             // jalr
        7'b010_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, jump, aluop} = 11'b00111000000;             // sw
        7'b011_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, jump, aluop} = 11'b10000000010;             // R-Type (all of which are arithmetic/logical)
        7'b110_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, jump, aluop} = {8'b01000000 , zero, 2'b01}; // beq
        7'b110_1111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, jump, aluop} = 11'b11100100100;             // jal

        default:     {aluop, branch, jump, resultsrc, memwrite, alusrc, immsrc, regwrite} = 11'b11111111111;
    endcase
end

endmodule
// verilator lint_on UNUSED
