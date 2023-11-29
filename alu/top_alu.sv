module top_alu #(
    parameter REG_FILE_ADDR_WIDTH = 5, 
              DATA_WIDTH = 32
)(
    input  logic                           clk,
    input  logic                           ALUsrc,
    input  logic                           ALUctrl,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] AD1,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] AD2,
    input  logic [REG_FILE_ADDR_WIDTH-1:0] AD3,
    input  logic                           WE3,
    input  logic signed [DATA_WIDTH-1:0]   ImmOp,

    output logic                         Zero,
    output logic signed [DATA_WIDTH-1:0] a0  //output to check correct values
);

logic signed [DATA_WIDTH-1:0] RD1;    // output from reg_file
logic signed [DATA_WIDTH-1:0] RD2;    // output from reg_file
logic signed [DATA_WIDTH-1:0] ALUop2; // output from alu_mux
logic signed [DATA_WIDTH-1:0] ALUout; // output from alu


reg_file myregfile(
    .AD1(AD1),
    .AD2(AD2),
    .AD3(AD3),
    .WE3(WE3),
    .WD3(ALUout),
    .RD1(RD1),
    .RD2(RD2),
    .clk(clk),
    .a0(a0)
);

alu_mux mymux(
    .input0(RD2),
    .input1(ImmOp),
    .ALUsrc(ALUsrc),
    .out(ALUop2)
);

alu myalu(
    .ALUop1(RD1),
    .ALUop2(ALUop2),
    .ALUout(ALUout),
    .ALUctrl(ALUctrl),
    .Zero(Zero)
);
    
endmodule
