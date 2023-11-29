// verilator lint_off UNUSED
module main_decoder(
    input  logic [6:0] op,     // 7-bit opcode
    input  logic       zero,   // Zero flag
    
    // control signals
    output logic       PCsrc,
    output logic       ResultSrc,
    output logic       MemWrite,
    output logic       ALUSrc,
    output logic [1:0] ImmSrc,
    output logic       RegWrite,

    // ALUOp goes to alu_decoder
    output logic [1:0] ALUOp
);

// Implementation of control logic (as defined in Lecture 7 Slide 18; dont cares have been set to 0)
always_comb begin
    case (op)               
        7'b000_0011: {ALUOp, PCsrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite} = 9'b00_0101_00_1; // lw                                                              
        7'b001_0011: {ALUOp, PCsrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite} = 9'b10_0001_00_1; // I-Type (arithmetic/logical)
        7'b010_0011: {ALUOp, PCsrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite} = 9'b00_0011_01_0; // sw
        7'b011_0011: {ALUOp, PCsrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite} = 9'b10_0000_00_1; // R-Type (arithmetic/logical)
        7'b110_0011: {ALUOp, PCsrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite} = {2'b01, zero, 6'b000_10_0}; // beq
        
        default:     {ALUOp, PCsrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite} = 9'b11_1111_11_1;
    endcase
end

endmodule
// verilator lint_on UNUSED
