// verilator lint_off UNUSED
module pc_mux #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    // mux select lines
    input  logic                     rst,
    input  logic                     trigger,
    input  logic [1:0]               pcsrc,   
    
    // used for mux inputs (pc_mux has adders for pctarget and pcplus4 baked into it rather than as external modules)
    input logic signed [DATA_WIDTH-1:0]    aluresulte, // output from alu
    input logic        [ADDRESS_WIDTH-1:0] pc,         // current value of pc (in pc_reg)
    input logic signed [DATA_WIDTH-1:0]    immexte,    // immediate offset (e.g. for branch instruction)
    input logic        [ADDRESS_WIDTH-1:0] pce,        // pc in execute stage. this is needed for pipelined B and U type instructions

    // output of pctarget and pcplus4 adders (used in othe parts of the cpu)
    output logic [ADDRESS_WIDTH-1:0] pcplus4,
    output logic [ADDRESS_WIDTH-1:0] pctargete,
    output logic [ADDRESS_WIDTH-1:0] next_pc // new value of pc (to be written to pc_reg)
);

logic [DATA_WIDTH-1:0] branch_pc;

assign pcplus4 = pc + 32'd4; // add 4
assign pctargete = pce + immexte;

always_comb begin
    casez ({pcsrc , trigger , rst})
        4'b???1: next_pc = {32{1'b0}};   // if rst     = 1: remain at instruction 0 
        4'b??00: next_pc = {32{1'b0}};   // If trigger = 0: remain at instruction 0 
        4'b0010: next_pc = pcplus4;      // go to next intruction in memory
        4'b0110: next_pc = pctargete;    // jal, branch (with condition met)
        4'b1010: next_pc = aluresulte;   // jalr
        default: next_pc = {32{1'b1}};   // should never execute (if pc ever becomes odd, this may be why)
    endcase
end

endmodule 
// verilator lint_on UNUSED
