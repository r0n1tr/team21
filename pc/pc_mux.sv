// verilator lint_off UNUSED
module pc_mux #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input logic       rst,      
    input logic       trigger,
    input logic [1:0] pcsrc,
    
    input logic        [DATA_WIDTH-1:0]    aluresult,  // output from alu
    input logic        [ADDRESS_WIDTH-1:0] pc,         // current value of pc (in pc_reg)
    input logic signed [DATA_WIDTH-1:0]    immexte,    // immediate offset (e.g. for branch instruction)
    input logic signed [ADDRESS_WIDTH-1:0] pce,

    output logic [ADDRESS_WIDTH-1:0] pcplus4,
    output logic [ADDRESS_WIDTH-1:0] next_pc // new value of pc (to be written to pc_reg)
);


always_comb begin
    pcplus4 = pc + {29'b0, 3'b100}; // add 4

    casez ({pcsrc, trigger , rst})
        4'b???1: next_pc = {32{1'b0}};    // set pc to 0
        4'b??00: next_pc = {32{1'b0}};    // set pc to 0
        4'b0010: next_pc = pcplus4;       // next instruction in memory
        4'b0110: next_pc = pce + immexte; // branch, jal
        4'b1010: next_pc = aluresult;     // jalr
        default: next_pc = {32{1'b1}};
    endcase
end

endmodule 
// verilator lint_on UNUSED

