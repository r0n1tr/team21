module top_alu #(
    parameter REG_FILE_ADDR_WIDTH = 5, 
              DATA_WIDTH = 32
)(
    input logic                         clk,
    input logic                         alusrc,
    input logic                         alucontrol,
    input logic signed [DATA_WIDTH-1:0] rd1,    // cpmes from reg_file
    input logic signed [DATA_WIDTH-1:0] rd2,    // comes from reg_file
    input logic signed [DATA_WIDTH-1:0] immext,

    output logic signed [DATA_WIDTH-1:0] aluresult, // output from alu
    output logic                         zero       // zero flag
);

logic signed [DATA_WIDTH-1:0] srcb;      // output from alu_mux

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
