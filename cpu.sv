
module cpu #(
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 8
)(
    input logic clk,
    input logic rst,
    input logic trigger,   // this is the trigger 
    output logic [DATA_WIDTH-1:0] a0
);

// every *internal* output should be input to something else (i think)
// the outputs of each submodule are listed below
// and then connected accordingly when instantiating each module
  
// -- output from top_pc --
logic [ADDRESS_WIDTH-1:0] pc; // program counter 

// -- output from top_alu --
// don't list a0 here since that is output of entire cpu, hence not internal
// logic zero; // EQ flag
 
// -- output from instr_memv --
logic [DATA_WIDTH-1:0] instr; // instruction word from instruction memory

// -- output from data_mem
logic [DATA_WIDTH-1:0] rd_dm; // instruction word from data memory

// -- output from sign_extend --
logic signed [DATA_WIDTH-1:0] immext; // 32-bit sign extended immediate operand 

logic signed [DATA_WIDTH-1:0] result; // 32-bit sign extended immediate operand 

logic signed [DATA_WIDTH-1:0] rd1;    // output from reg_file
logic signed [DATA_WIDTH-1:0] rd2;    // output from reg_file
logic signed [DATA_WIDTH-1:0] aluop2; // output from alu_mux
logic signed [DATA_WIDTH-1:0] aluout; // output from alu



// -- output from control unit --
// these are all control signals
logic regwrite;
logic [2:0] alucontrol;
logic alusrc;
logic [1:0] immsrc;
logic resultsrc;
logic pcsrc; 
logic memwrite;
logic zero;

top_pc t_PC(
    .clk(clk),
    .rst(rst),
    .pcsrc(pcsrc),
    .immext(immext),
    .trigger(trigger),
    .pc_out(pc)
);

instr_mem instrMem(
    .a(pc),

    .rd(instr)
);

reg_file myregfile(
    .ad1(instr[19:15]),
    .ad2(instr[24:20]),
    .ad3(instr[11:7]),
    .we3(regwrite),
    .wd3(result), //
    .clk(clk),

    .rd1(rd1),
    .rd2(rd2),
    .a0(a0)
);

mux alu_mux(
    .input0(rd2),
    .input1(immext),
    .src(alusrc),
    .out(aluop2)
);

alu myalu(
    .aluop1(rd1),
    .aluop2(aluop2),
    .aluout(aluout),
    .alucontrol(alucontrol),
    
    .zero(zero)
);



top_control_unit controlUnit(
    .instr(instr),
    .zero(zero),

    .pcsrc(pcsrc),
    .resultsrc(resultsrc),
    .memwrite(memwrite),
    .alucontrol(alucontrol),
    .alusrc(alusrc),
    .immsrc(immsrc),
    .regwrite(regwrite)
);

sign_extend signExtend(
    .instr(instr),
    .immsrc(immsrc),

    .immop(immext)
);

data_mem DataMemory(
    .a(aluout),
    .wd(rd2),
    .we(memwrite),
    .clk(clk),

    .rd(rd_dm)
);

mux data_mem_mux(
    .input0(aluout),
    .input1(rd_dm),
    .src(resultsrc),
    .out(result)
);

endmodule

