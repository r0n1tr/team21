module top_pc #(
    parameter ADDRESS_WIDTH = 8,
              DATA_WIDTH = 32
)(
    input  logic                     clk,
    input  logic                     rst,
    input  logic                     PCsrc,
    input  logic [DATA_WIDTH-1:0]    ImmOp,

    output logic [ADDRESS_WIDTH-1:0] pc
);

logic [ADDRESS_WIDTH-1:0] next_pc;

pc_mux my_mux (
    .PCsrc(PCsrc),
    .ImmOp(ImmOp),
    .pc(pc),
    .next_pc(next_pc)
);

pc_reg my_reg(
    .clk(clk),
    .rst(rst),
    .next_pc(next_pc),
    .pc(pc)
);

endmodule
