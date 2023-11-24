// verilator lint_off UNUSED
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
/*
assign RegWrite = (instr[6] ?  0 : 1); 
assign ALUctrl  = (instr[6] ?  1 : 0);
assign ALUsrc   = (instr[6] ?  0 : 1);
assign ImmSrc   = (instr[6] ?  1 : 0);
assign PCsrc    = (instr[6] ? ~EQ : 0);
*/

always_comb begin 
    if(instr[6:0]==7'b0010011) begin //this opcode specifies addi

        RegWrite=1;
        ALUctrl=1;
        ALUsrc=1;
        ImmSrc=0;
        PCsrc=0;
        //MemWrite =0;
        //ResultSrc=0;

    end 
   
    else if(instr[6:0]==7'b1100011) begin           //this opcode specifies bne
            ALUsrc=0;//We need to compare two registers
            ALUctrl=0; //subtraction
            RegWrite=0; //0 means don't write to the them
            //MemWrite =0; //not writing anything
           // ResultSrc=0;
            if(EQ) PCsrc=0; //if they are equal then just pc+=4
            else begin//if they are not equal then we need to use branched pc addr.
                ImmSrc=1;
                PCsrc=1;
            end
    end 
end



endmodule
// verilator lint_on UNUSED
