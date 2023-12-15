module top_alu #(
    parameter DATA_WIDTH = 32
)(
    input logic                         alusrc,
    input logic        [3:0]            alucontrol,
    input logic signed [DATA_WIDTH-1:0] rd1,    // comes from reg_file
    input logic signed [DATA_WIDTH-1:0] rd2,    // comes from reg_file
    input logic signed [DATA_WIDTH-1:0] immext,

    input logic        [1:0]            forwardae,
    input logic        [1:0]            forwardbe,
    input logic signed [DATA_WIDTH-1:0] aluresultm,
    input logic signed [DATA_WIDTH-1:0] resultw,

    output logic signed [DATA_WIDTH-1:0] writedatae,// goes between forward_b_mux and alu_srcb_mux
    output logic signed [DATA_WIDTH-1:0] aluresult, // output from alu
    output logic                         zero       // zero flag
);

logic signed [DATA_WIDTH-1:0] srcb;  // aluop1

logic signed [DATA_WIDTH-1:0] forward_a_out;  // aluop2

mux2 forward_a_mux(
    .input0(rd1),
    .input1(resultw),
    .input2(aluresultm),
    .input3(DATA_WIDTH'('b0)),

    .select(forwardae),

    .out(forward_a_out)
);

mux2 forward_b_mux(
    .input0(rd2),
    .input1(resultw),
    .input2(aluresultm),
    .input3(DATA_WIDTH'('b0)),

    .select(forwardbe),

    .out(writedatae)
);

mux alu_srcb_mux(
    .input0(writedatae),
    .input1(immext),
    .select(alusrc),

    .out(srcb)
);

alu alu(
    .aluop1(forward_a_out),
    .aluop2(srcb),
    .alucontrol(alucontrol),

    .aluresult(aluresult),
    .zero(zero)
);

endmodule
