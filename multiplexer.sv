// verilator lint_off UNUSED
module multiplexer #(
    parameter ADDRESS_WIDTH = 8,
    DATA_WIDTH = 32
)(
    input  logic                        PCsrc,
    input  logic         [DATA_WIDTH-1:0]    ImmOp,
    input  logic         [ADDRESS_WIDTH-1:0]    PC,
    output logic         [ADDRESS_WIDTH-1:0]    next_PC 
);
logic [ADDRESS_WIDTH-1:0] branch_PC;
logic [ADDRESS_WIDTH-1:0] inc_PC;

always_comb begin
    if(PCsrc) begin
        branch_PC = PC + ImmOp[ADDRESS_WIDTH-1:0];
        next_PC = branch_PC[ADDRESS_WIDTH-1:0];
    end
    else begin
        inc_PC = PC + {{(ADDRESS_WIDTH-3){1'b0}}, 3'b100};
        next_PC = inc_PC;
    end
end


endmodule 
// verilator lint_on UNUSED

