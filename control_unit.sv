module control_unit(
    input  logic [31:0] instr,  // 32-bit instruction word
    input  logic        EQ,     // Flag for equality of operands
    
    // control signals
    output logic RegWrite,
    output logic ALUctrl,
    output logic ALUsrc,
    output logic ImmSrc,
    output logic PCsrc
);

endmodule