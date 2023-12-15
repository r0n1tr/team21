module branch_decoder(
    input logic       branch,
    input logic       zero,   
    input logic [2:0] funct3, 

    output logic should_branch // whether or not we should branch
);

// Only need zero flag (and no others): 
// For B_type instructions we either need to branch, or don't. 
// These two outcomes can be expressed with a single bit. This bit is the zero flag,
// and is set by the alu to be meaningful to the branch (meaningful = it tells  
// us whether the branch condition is met).
// The zero flag is set is a meaningful way by doing a meaningful operation on the 
// branch's operands --> see aludecoder's comments for which meaningful operation
// correspond to which branch instruction)

always_comb begin
    
    should_branch = 1'b0; // init to 0

    // only set should_branch to 1 if we are branching, and that particular branch's condition is met
    if (branch) begin
        if (funct3 == 3'b000 && zero ) should_branch = 1'b1; // beq
        if (funct3 == 3'b001 && ~zero) should_branch = 1'b1; // bne

        if (funct3 == 3'b100 && ~zero) should_branch = 1'b1; // blt     (e.g. if a<b then slt rd, a, b sets aluresult=1, which means zero=0. we want to branch when a<b, so when zero=0.)
        if (funct3 == 3'b101 && zero ) should_branch = 1'b1; // bge

        if (funct3 == 3'b110 && ~zero) should_branch = 1'b1; // bltu
        if (funct3 == 3'b111 && zero ) should_branch = 1'b1; // bgeu
    end 
end

endmodule
