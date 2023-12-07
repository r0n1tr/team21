module pcsrc_logic(
    input logic jalr,
    input logic jump,
    input logic branch,
    input logic zero,

    output logic [1:0] pcsrce
);
// assign pcsrce[0] = ((branch & zeroe) | jump) &  ~jalr;
// assign pcsrce[1] = jalr;

always_comb begin
    // logic [3:0] hmm = {jalr, jump, branch, zero};

    // if      (hmm[3])                                             pcsrce = 2'b10;  // jalr   
    // else if (hmm[2] | (hmm[1] & hmm[0]))                         pcsrce = 2'b01;  // jal OR beq (with condition met)  
    // else if (hmm == 4'b0000 || hmm == 4'b0001 || hmm == 4'b0010) pcsrce = 2'b00;  // lw, sw, I-type(alu), R-type, beq with unmet condition
    // else                                                         pcsrce = 2'b11;  // unknown instruction

    if (jalr)                          pcsrce = 2'b10;   // jalr                                                    hmm = ????
    else if (jump | (branch & zero))   pcsrce = 2'b01;   // beq (with condition met) OR jal                         hmm = 0???
    else                               pcsrce = 2'b00;   // lw, sw, I-type(alu), R-type, beq with unmet condition:  hmm = 00-00 00-01 00-10

    // casez ({jump, branch, zero, jalr})

    //     4'b00?0: pcsrce = 2'b00; // pcplus4:  lw, sw, I-type(alu), R-type
    //     4'b?100: pcsrce = 2'b00; // pcplus4:  beq with unmet condition

    //     4'b?11?: pcsrce = 2'b01; // pc + immext (when beq with condition met)
    //     4'b1???: pcsrce = 2'b01; // pc + immext (when jal)


    //     default: pcsrce = 2'b11;
    // endcase
end
    
endmodule
