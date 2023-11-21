module top (
    parameter DATA = 32,
    ADDRESS_WIDTH = 8;
)
(
    // PROGRAM COUNTER MODULE
    input logic [DATA-1:0] PC,
    input logic [DATA-1:0] Immop,
    input logic clk,
    input logic rst,
    input logic PCsrc,
    //

    // ALU
    output logic ALUout,
    output logic EQ, 
    output logic a0
    //

)

//control unit
    logic [ADDRESS_WIDTH-1:0] A,
    logic [ADDRESS_WIDTH-1:0] RD,
    logic [ADDRESS_WIDTH-1:0] PC_INTERNAL,
    logic RegWrite,
    logic ALUctrl,
    logic ALUsrc,
    logic Immsrc,
    logic PCsrc
    

Program_counter myPC(
    .PC(PC_INTERNAL), //sort out feedbakc loop
    .ImmOp(ImmOp),
    .clk(clk),
    .rst(rst)

)

instr_mem instrMem(
    .*

)

control_unit controlUnit(
    .instr(RD),
    .EQ(EQ)
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