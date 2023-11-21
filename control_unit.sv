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

// Implementation of control logic.
//   (the opcodes for instructions addi and bne are 0b0010011 and 0b1100011 respectively
//   but since there are only two instructions, it is sufficient just to check the MSB of the opcodes
//   which is found in instr[6])
assign RegWrite = (instr[6] ?  0 : 1); 
assign ALUctrl  = (instr[6] ?  1 : 0);
assign ALUsrc   = (instr[6] ?  0 : 1);
assign ImmSrc   = (instr[6] ?  1 : 0);
assign PCsrc    = (instr[6] ? EQ : 0);

endmodule
