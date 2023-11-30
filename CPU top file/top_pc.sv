module top_pc #(
    parameter ADDRESS_WIDTH = 8,
              DATA_WIDTH = 32
)(
    input  logic                     clk,
    input  logic                     rst,
    input  logic                     PCsrc,
    input  logic [DATA_WIDTH-1:0]    ImmExt,
    input  logic                     int, //trigger 
    output logic [ADDRESS_WIDTH-1:0] pc_out
);

logic [ADDRESS_WIDTH-1:0] next_pc;
logic [ADDRESS_WIDTH-1:0] trig_mux_out;
logic [ADDRESS_WIDTH-1:0] pc;
pc_mux my_mux (
    .PCsrc(PCsrc),
    .ImmExt(ImmExt),
    .pc(pc),
    .next_pc(next_pc)
);



pc_reg my_reg(
    .clk(clk),
    .rst(rst),
    .next_pc(next_pc),
    .pc(pc)
);

mux trig_mux(

    .input0({ADDRESS_WIDTH{1'b0}}),
    .input1(pc),
    .src(int),

    .out(trig_mux_out)
);

mux rst_mux(
    .input0(trig_mux_out),
    .input1({ADDRESS_WIDTH{1'b1}}),
    .src(rst),

    .out(pc_out)
);

endmodule
