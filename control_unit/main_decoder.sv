// verilator lint_off UNUSED
module main_decoder(
    input  logic [6:0] op,     // 7-bit opcode
    input  logic       zero,   // Zero flag
    
    // control signals
    output logic [1:0] pcsrc,
    output logic [1:0] resultsrc,
    output logic       memwrite,
    output logic       alusrc,
    output logic [1:0] immsrc,
    output logic       regwrite,

    // aluop goes to alu_decoder
    output logic [1:0] aluop
);

logic branch;
logic jump;

// Implementation of control logic (as defined in Lecture 7 Slide 18; dont cares have been set to 0)
always_comb begin
    // set control signals (other than pcsrc)
    case (op)               
        7'b000_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = 11'b1001001_0000;  // lw 
        7'b010_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = 11'b0011100_0000;  // sw    
        7'b011_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = 11'b1000000_0100;  // R-Type (all of which are arithmetic/logical)
        7'b110_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = 11'b0100000_1010;  // beq
        7'b001_0011: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = 11'b1001000_0100;  // I-Type (arithmetic/logical)
        7'b110_1111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = 11'b1110010_0001;  // jal
        7'b110_0111: {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = 11'b1001000_0001;  // jalr

        default:     {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = 11'b1111111_1111;
    endcase

    // set pcsrc
    if      (op == 7'b110_0111)      pcsrc = 2'b10;   // jalr                                                    
    else if (jump | (branch & zero)) pcsrc = 2'b01;   // beq (with condition met) OR jal                         
    else                             pcsrc = 2'b00;   // lw, sw, I-type(alu), R-type, beq with unmet condition
end

endmodule
// verilator lint_on UNUSED
