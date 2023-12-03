module top_alu #(
    parameter DATA_WIDTH = 32
)(
    input logic                         alusrc,
    input logic        [2:0]            alucontrol,
    input logic signed [DATA_WIDTH-1:0] rd1,    // comes from reg_file
    input logic signed [DATA_WIDTH-1:0] rd2,    // comes from reg_file
    input logic signed [DATA_WIDTH-1:0] immext,

    output logic signed [DATA_WIDTH-1:0] aluresult, // output from alu
    output logic                         zero       // zero flag
);

 // output from alu_mux
logic signed [DATA_WIDTH-1:0] srcb;     

alu_mux alu_mux(
    .input0(rd2),
    .input1(immext),
    .alusrc(alusrc),

    .out(srcb)
);

alu alu(
    .aluop1(rd1),
    .aluop2(srcb),
    .alucontrol(alucontrol),

    .aluresult(aluresult),
    .zero(zero)
);
    
endmodule
