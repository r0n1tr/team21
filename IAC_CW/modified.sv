module top #(
    parameter   DATA = 32,
                ADDRESS_WIDTH = 8
)(
    // PROGRAM COUNTER MODULE

    input logic clk,
    input logic rst,
    output [DATA-1:0] a0

);

//control unit
    logic [DATA-1:0] RD,
    logic [DATA-1:0] ImmOp,
    logic [DATA-1:0] PC,
    logic RegWrite,
    logic ALUctrl,
    logic ALUsrc,
    logic Immsrc,
    logic PCsrc,
    logic EQ
    

Program_counter Program_Counter(
    .PC(PC), //sort out feedbakc loop
    .ImmOp(ImmOp),
    .clk(clk),
    .rst(rst),
    .PCsrc(PCsrc)
    

)

instr_mem instrMem(
    .A(PC),
    .RD(RD)

)

control_unit controlUnit(
    .instr(RD),
    .EQ(EQ),
    .RegWrite(RegWrite),
    .ALUctrl(ALUctrl),
    .ALUsrc(ALUsrc),
    .Immsrc(Immsrc),
    .PCsrc(PCsrc)
)

sign_extend signExtend(
    .instr(RD),
    .Immsrc(Immsrc),
    .ImmOp(ImmOp)
)

topalu ALU(
    .AD1(RD[19:15]),
    .AD2(RD[24:20]),
    .AD3(RD[11:7]),
    .WE3(RegWrite),
    .WD3(ALUout),
    .clk(clk)
    .ALUsrc(ALUsrc),
    .ALUctrl(ALUctrl),
    .ImmOp(ImmOp),
    .EQ(EQ),
    .a0(a0)

)





    




endmodule
