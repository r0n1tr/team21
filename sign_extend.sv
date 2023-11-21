module sign_extend(
    input  logic [31:0] instr,  // 32-bit instruction word
    input  logic        ImmSrc, // Flag to tell this module which isntruction type is being executed (and hence which bits form the immediate and whether they need to be sign extended)
    output logic [31:0] ImmOp   // Immediate operand - is the sign extended output of this module
);

endmodule