
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
logic [DATA_WIDTH-1:0] instr; // instruction word from instruction memory

// -- output from data_mem
logic [DATA_WIDTH-1:0] RD_DM; // instruction word from data memory

// -- output from sign_extend --
logic signed [DATA_WIDTH-1:0] ImmExt; // 32-bit sign extended immediate operand 

logic signed [DATA_WIDTH-1:0] Result; // 32-bit sign extended immediate operand 

logic signed [DATA_WIDTH-1:0] RD1;    // output from reg_file
logic signed [DATA_WIDTH-1:0] RD2;    // output from reg_file
logic signed [DATA_WIDTH-1:0] ALUop2; // output from alu_mux
logic signed [DATA_WIDTH-1:0] ALUout; // output from alu



// -- output from control unit --
// these are all control signals
logic RegWrite;
logic [2:0] ALUctrl;
logic ALUSrc;
logic [1:0] ImmSrc;
logic PCSrc; 
logic MemWrite;
logic zero;

top_pc t_PC(
    .clk(clk),
    .rst(rst),
    .PCSrc(PCSrc),
    .ImmExt(ImmExt),

    .pc(pc)
);

instr_mem instrMem(
    .A(pc),

    .RD(instr)
);

reg_file myregfile(
    .AD1(instr[19:15]),
    .AD2(instr[24:20]),
    .AD3(instr[11:7]),
    .WE3(RegWrite),
    .WD3(Result), //
    .clk(clk),

    .RD1(RD1),
    .RD2(RD2),
    .a0(a0)
);

mux alu_mux(
    .input0(RD2),
    .input1(ImmExt),
    .Src(ALUSrc),
    .out(ALUop2)
);

alu myalu(
    .ALUop1(RD1),
    .ALUop2(ALUop2),
    .ALUout(ALUout),
    .ALUctrl(ALUctrl),
    
    .zero(zero)
);



top_control_unit controlUnit(
    .instr(instr),
    .zero(zero),

    .PCSrc(PCSrc),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .ALUctrl(ALUctrl),
    .ALUSrc(ALUSrc),
    .ImmSrc(ImmSrc),
    .RegWrite(RegWrite)
);

sign_extend signExtend(
    .instr(RD_IM),
    .ImmSrc(ImmSrc),

    .ImmExt(ImmExt)
);

data_mem DataMemory(
    .A(ALUout),
    .WD(RD2),
    .WE(MemWrite),
    .clk(clk)

    .RD(RD_DM)
)

mux data_mem_mux(
    .input0(ALUout),
    .input1(RD_DM),
    .src(ResultSrc),
    .out(Result)
);

endmodule

