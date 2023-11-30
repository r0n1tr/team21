// verilator lint_off UNUSED
module sign_extend(
    input  logic [31:0] instr,  // 32-bit instruction word
    input  logic [1:0]  immsrc, // Indicates instruction type, and hence which bits of the instruction contain the immediate
    output logic [31:0] immop   // Immediate operand - is the sign extended output of this module
);

// Sign extension implementation (as defined in lecture 7, slide 15)
always_comb begin
    case (immsrc)
        2'b00:   immop = { {20{instr[31]}} , instr[31:20] };                                      // I-TYPE; sign extend 12-bit imm
        2'b01:   immop = { {20{instr[31]}} , instr[31:25] , instr[11:7] };                        // S-TYPE; sign extend 12-bit imm
        2'b10:   immop = { {20{instr[31]}} , instr[7]     , instr[30:25] , instr[11:8], {1'b0} }; // B-TYPE; sign extend 13-bit imm; immop used as offset to PC (so can be -ve or +ve, so needs to be sign extended)
        default: immop = { 32{1'b0} }; // e.g. for R-TYPE (as it has no immediate)
    endcase
end

endmodule
// verilator lint_on UNUSED

// NOTE ON `Verilator lint_on/off UNUSED` - we would receive a warning if compiling without these lines#
// the warning was that we had unused bits
// the warning links to this page: https://verilator.org/guide/latest/warnings.html#cmdoption-arg-UNUSED
// on the same page, it is said (here: https://verilator.org/guide/latest/warnings.html#disabling-warnings) to add these comments to disable the warning
