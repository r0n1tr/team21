module pcsrc_logic(
    input logic jump,
    input logic branch,
    input logic zeroe,
    input logic jalr,

    output logic [1:0] pcsrce
);
    // assign pcsrce[0] = ((branch & zeroe) | jump) &  ~jalr;
    // assign pcsrce[1] = jalr;

always_comb begin
    casez ({jump, branch, zeroe, jalr})
        4'b00?0: pcsrce = 2'b00; // pcplus4:  lw, sw, I-type(alu), R-type
        4'b?10?: pcsrce = 2'b00; // pcplus4:  beq with unmet condition

        4'b?11?: pcsrce = 2'b01; // pc + immext (when beq with condition met)
        4'b1???: pcsrce = 2'b01; // pc + immext (when jal)

        4'b00?1: pcsrce = 2'b10; // jalr

        default: pcsrce = 2'b11;
    endcase
end
    
endmodule
