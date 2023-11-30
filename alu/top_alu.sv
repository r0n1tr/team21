module top_alu #(
    parameter REG_FILE_ADDR_WIDTH = 5, 
              DATA_WIDTH = 32
)(
    input  logic                           clk,
    input  logic                           alusrc,
    input  logic                           alucontrol,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] ad1,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] ad2,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] ad3,
    input  logic                           we3,
    input  logic signed [DATA_WIDTH-1:0]   immop,

    output logic                         zero,
    output logic signed [DATA_WIDTH-1:0] a0  //output to check correct values
);

logic signed [DATA_WIDTH-1:0] rd1;    // output from reg_file
logic signed [DATA_WIDTH-1:0] rd2;    // output from reg_file
logic signed [DATA_WIDTH-1:0] aluop2; // output from alu_mux
logic signed [DATA_WIDTH-1:0] aluout; // output from alu


reg_file myregfile(
    .ad1(ad1),
    .ad2(ad2),
    .ad3(ad3),
    .we3(we3),
    .WD3(aluout),
    .rd1(rd1),
     rd2),
    .clk(clk),
    .a0(a0)
);

alu_mux mymux(
    .input0 rd2),
    .input1(immop),
    .alusrc(alusrc),
    .out(aluop2)
);

alu myalu(
    .ALUop1(rd1),
    .aluop2(aluop2),
    .aluout(aluout),
    .alucontrol(alucontrol),
    .zero(zero)
);
    
endmodule
