// verilator lint_off UNUSED
module sign_extend(
    input  logic [31:0] instr,  // 32-bit instruction word
    input  logic        ImmSrc, // Flag to tell this module which isntruction type is being executed (and hence which bits in instr form the immediate)
    output logic [31:0] ImmOp   // Immediate operand - is the sign extended output of this module
);

always_comb begin
    if (ImmSrc) // executing bne
        ImmOp = { {22{instr[30]}} , instr[30:25] , instr[11:8] }; // sign extend 10-bit immediate value to give 32-bit output; bne's immediate value is used as an offset for the PC (so can be negative or positive, so needs to be sign extended) 
    else        // executing addi
        ImmOp = { {12{instr[31]}} , instr[31:12] }; // sign extend 12-bit immediate value to give 32-bit output
end

endmodule
// verilator lint_on UNUSED

// NOTE ON `Verilator lint_on/off UNUSED` - we would receive a warning if compiling without these lines#
// the warning was that we had unused bits
// the warning links to this page: https://verilator.org/guide/latest/warnings.html#cmdoption-arg-UNUSED
// on the same page, it is said (here: https://verilator.org/guide/latest/warnings.html#disabling-warnings) to add these comments to disable the warning
