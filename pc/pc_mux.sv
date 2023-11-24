// verilator lint_off UNUSED
module pc_mux #(
    parameter ADDRESS_WIDTH = 8,
              DATA_WIDTH = 32
)(
    input  logic                     PCsrc,  // select line for mux
    input  logic [DATA_WIDTH-1:0]    ImmOp,  // immediate offset (e.g. for branch instruction)
    input  logic [ADDRESS_WIDTH-1:0] pc,     // current value of pc (in pc_reg)

    output logic [ADDRESS_WIDTH-1:0] next_pc // new value of pc (to be written to pc_reg)
);

logic [DATA_WIDTH-1:0] branch_PC;

always_comb begin
    if(PCsrc) begin // next_PC = ImmOp + PC
        branch_PC = ( ImmOp + { {(DATA_WIDTH-ADDRESS_WIDTH){1'b0}} , pc } ); // zero extend PC to 32 bit --> Add 32-bit PC and 32 bit ImmOp --> select lower 8 bits of the sum. This wayy branch_PC is an 8 bit value representing the sum of PC and ImmOp *without bit width problems hopefully*
        next_pc = branch_PC[ADDRESS_WIDTH-1:0];
    end
    else begin // next_PC = PC + 4
        branch_PC = 32'hFFFFFFFF; // dummy value to get rid of warning
        next_pc = pc + {{(ADDRESS_WIDTH-3){1'b0}}, 3'b100};
    end
end


endmodule 
// verilator lint_on UNUSED

