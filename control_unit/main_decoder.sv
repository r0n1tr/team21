// verilator lint_off UNUSED
module main_decoder(
    input  logic [6:0] op,     // 7-bit opcode
    input  logic       zero,   // Zero flag
    
    // control signals
    output logic       pcsrc,
    output logic [1:0] resultsrc,
    output logic       memwrite,
    output logic       alusrc,
    output logic [1:0] immsrc,
    output logic       regwrite,

    // aluop goes to alu_decoder
    output logic [1:0] aluop
);

// Implementation of control logic (as defined in Lecture 7 Slide 18; dont cares have been set to 0)
always_comb begin
    case (op)               
        7'b000_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, pcsrc, aluop} = 10'b1001001000;             // lw                                                              
        7'b001_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, pcsrc, aluop} = 10'b1001000010;             // I-Type (arithmetic/logical)
        7'b010_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, pcsrc, aluop} = 10'b0011100000;             // sw
        7'b011_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, pcsrc, aluop} = 10'b1000000010;             // R-Type (all of which are arithmetic/logical)
        7'b110_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, pcsrc, aluop} = {7'b0100000 , zero, 2'b01}; // beq
        7'b110_1111: {regwrite, immsrc, alusrc, memwrite, resultsrc, pcsrc, aluop} = 10'b1110010100;             // jal

        default:     {aluop, pcsrc, resultsrc, memwrite, alusrc, immsrc, regwrite} = 10'b1111111111;
    endcase
end

endmodule
// verilator lint_on UNUSED
