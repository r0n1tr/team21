module topalu #(
    
) (
    input logic [4:0] AD1,
    input logic [4:0] AD2,
    input logic [4:0] AD3,
    input logic WE3,
    input logic [31:0] WD3,
    input logic clk,
    input logic ALUsrc,
    input logic ALUctrl,
    input logic [31:0] ImmOp,
    output logic EQ,
    output logic [31:0] a0  //output to check correct values
);

logic [31:0] RD1;
logic [31:0] RD2;
logic [31:0] ALUop2;

regfile myregfile(
    .AD1(AD1),
    .AD2(AD2),
    .AD3(AD3),
    .WE3(WE3),
    .WD3(WD3),
    .RD1(RD1),
    .RD2(RD2),
    .clk(clk),
    .a0(a0)
);

mux mymux(
    .input0(RD2),
    .input1(ImmOp),
    .ALUsrc(ALUsrc),
    .out(ALUop2)
);

alu myalu(
    .ALUop1(RD1),
    .ALUop2(ALUop2),
    .ALUout(ALUout),
    .ALUctrl(ALUctrl)
    .EQ(EQ)
);
    
endmodule
