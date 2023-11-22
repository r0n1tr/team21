module top #(
    parameter DATA = 32,
    ADDRESS_WIDTH = 8
)
(
    // PROGRAM COUNTER MODULE
    input logic [DATA-1:0] PC,
    //input logic [DATA-1:0] Immop,
    input logic clk,
    input logic rst,
    //

    // ALU
    output logic ALUout,
    output logic a0
    //

);

//control unit
    //logic [ADDRESS_WIDTH-1:0] A,
    logic [DATA-1:0] RD;
    logic [ADDRESS_WIDTH-1:0] PC_INTERNAL;
    logic [DATA-1:0] ImmOp;
    logic EQ;
    logic RegWrite;
    logic ALUctrl;
    logic ALUsrc;
    logic ImmSrc;
    logic PCsrc;
    

Program_Counter myPC(
    .PC(PC_INTERNAL), //sort out feedbakc loop
    .ImmOp(ImmOp),
    .PCsrc(PCsrc),
    .clk(clk),
    .rst(rst)

);

instr_mem instrMem(
    .A(PC_INTERNAL),
    .RD(RD)

);

control_unit controlUnit(
    .instr(RD),
    .EQ(EQ),
    .RegWrite(RegWrite),
    .ALUctrl(ALUctrl),
    .ALUsrc(ALUsrc),
    .ImmSrc(ImmSrc),
    .PCsrc(PCsrc)
);

sign_extend signExtend(
    .instr(RD),
    .ImmSrc(ImmSrc),
    .ImmOp(ImmOp)
);

topalu ALU(
    .AD1(RD[19:15]),
    .AD2(RD[24:20]),
    .AD3(RD[11:7]),
    .WE3(RegWrite),
    .WD3(ALUout),
    .clk(clk),
    .ALUsrc(ALUsrc),
    .ALUctrl(ALUctrl),
    .ImmOp(ImmOp),
    .EQ(EQ),
    .a0(a0),
    .ALUout(ALUout)

);

endmodule

