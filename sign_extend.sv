module sign_extend(
    input  logic [31:0] instr,  // 32-bit instruction word
    input  logic        ImmSrc, // Flag to tell this module which isntruction type is being executed (and hence which bits form the immediate and whether they need to be sign extended)
    output logic [31:0] ImmOp   // Immediate operand - is the sign extended output of this module
);

always_comb begin
    if (ImmSrc) // executing addi
        ImmOp = { {20{instr[31]}} , instr[31:12] }; // sign extend 12-bit immediate value to give 32-bit output
    else        // executing bne
        ImmOp = { {22{1'b0}}      , instr[30:25], instr[11:8] }; // bne has an address as its immediate, so zero-extend it instead of sign-extending
end

endmodule
