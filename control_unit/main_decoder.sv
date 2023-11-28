// verilator lint_off UNUSED
module main_decoder(
    input  logic [6:0] op,     // 7-bit opcode
    input  logic       zero,   // Zero flag
    
    // control signals
    output logic       PCsrc,
    output logic       ResultSrc
    output logic       ALUSrc,
    output logic [1:0] ImmSrc,
    output logic       RegWrite,

    // ALUOp goes to alu_decoder
    output logic [1:0] ALUOp
);

endmodule
// verilator lint_on UNUSED
