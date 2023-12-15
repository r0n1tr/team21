
module cpu #(
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 8
)(
    input logic clk,
    input logic rst,

    output logic [DATA_WIDTH-1:0] a0
);

// every *internal* output should be input to something else (i think)
// the outputs of each submodule are listed below
// and then connected accordingly when instantiating each module
  
// -- output from top_pc --
logic [ADDRESS_WIDTH-1:0] pc; // program counter 

// -- output from top_alu --
// don't list a0 here since that is output of entire cpu, hence not internal
logic EQ; // EQ flag
 
// -- output from instr_memv --
logic [DATA_WIDTH-1:0] RD; // instruction word from memory

// -- output from sign_extend --
logic [DATA_WIDTH-1:0] ImmOp; // 32-bit sign extended immediate operand 

// -- output from control unit --
// these are all control signals
logic RegWrite;
logic ALUctrl;
logic ALUsrc;
logic ImmSrc;
logic PCsrc; 
    

top_pc t_PC(
    .clk(clk),
    .rst(rst),
    .PCsrc(PCsrc),
    .ImmOp(ImmOp),

    .pc(pc)
);

top_alu t_ALU(
    .clk(clk),
    .ALUsrc(ALUsrc),
    .ALUctrl(ALUctrl),
    .AD1(RD[19:15]),
    .AD2(RD[24:20]),
    .AD3(RD[11:7]),
    .WE3(RegWrite),
    .ImmOp(ImmOp),

    .EQ(EQ),
    .a0(a0)
);

instr_mem instrMem(
    .A(pc),

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

endmodule
