module pcsrc_logic(
    input logic jump,
    input logic branch,
    input logic zero,
    input logic jalr,

    output logic [1:0] pcsrce
);
    // assign pcsrce[0] = ((branch & zeroe) | jump) &  ~jalr;
    // assign pcsrce[1] = jalr;

always_comb begin

    if (jalr)                          pcsrce = 2'b10;  // jalr
    else if ((branch && zero) || jump) pcsrce = 2'b01;  // beq (with condition met) OR jal
    else                               pcsrce = 2'b00;  // lw, sw, I-type(alu), R-type, beq with unmet condition
    // casez ({jump, branch, zero, jalr})

    //     4'b00?0: pcsrce = 2'b00; // pcplus4:  lw, sw, I-type(alu), R-type
    //     4'b?100: pcsrce = 2'b00; // pcplus4:  beq with unmet condition

    //     4'b?11?: pcsrce = 2'b01; // pc + immext (when beq with condition met)
    //     4'b1???: pcsrce = 2'b01; // pc + immext (when jal)


    //     default: pcsrce = 2'b11;
    // endcase
end
    
endmodule
