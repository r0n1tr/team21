module pcsrc_logic (
    input logic should_branch, // should be asserted if branch instruction being executed AND branch condition met
    input logic should_jal,    // asserted if executing jal
    input logic should_jalr,   // asserted if executing jalr

    output logic [1:0] pcsrce 
);

always_comb begin
    // set pcsrce
    if      (should_jalr)                pcsrce = 2'b10;   // jalr                                                    
    else if (should_jal | should_branch) pcsrce = 2'b01;   // jal OR branch (with condition met)                          
    else                                 pcsrce = 2'b00;   // all other instructions (including branch with unmet condition)
end

endmodule

