// verilator lint_off UNUSED
module sign_extend(
    input  logic        [31:0] instr,  // 32-bit instruction word
    input  logic        [2:0]  immsrc, // Indicates instruction type, and hence which bits of the instruction contain the immediate
    output logic signed [31:0] immext  // Immediate operand - is the sign extended output of this module
);

// Sign extension implementation (as defined in lecture 7, slide 15)
always_comb begin
    case (immsrc)
        3'b000:   immext = { {20{instr[31]}} , instr[31:20] };                                        // I-TYPE; sign extend 12-bit imm
        3'b001:   immext = { {20{instr[31]}} , instr[31:25] , instr[11:7] };                          // S-TYPE; sign extend 12-bit imm
        3'b010:   immext = { {20{instr[31]}} , instr[7]     , instr[30:25] , instr[11:8]  , {1'b0} }; // B-TYPE; sign extend 13-bit imm; immext used as offset to PC (so can be -ve or +ve, so needs to be sign extended)
        3'b011:   immext = { {12{instr[31]}} , instr[19:12] , instr[20]    , instr[30:21] , {1'b0} }; // J-TYPE; sign extend 21-bit imm
        3'b100:   immext = { instr[31:12], {12'b0} };                                                 // U-TYPE; set 20-bit imm as upper 20 bits, and set lower 12 bits to 0

        default:  immext = 32'hdeadbeef;   // should never execute; set imm to 'deadbeef'
    endcase
end

endmodule
// verilator lint_on UNUSED

// NOTE ON `Verilator lint_on/off UNUSED` - we would receive a warning if compiling without these lines#
// the warning was that we had unused bits
// the warning links to this page: https://verilator.org/guide/latest/warnings.html#cmdoption-arg-UNUSED
// on the same page, it is said (here: https://verilator.org/guide/latest/warnings.html#disabling-warnings) to add these comments to disable the warning
