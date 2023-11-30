module cpu #(
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 8
)(
    input logic clk,
    input logic rst,
    input logic trigger,

    output logic [DATA_WIDTH-1:0] a0
);

// every *internal* output should be input to something else (i think)
// the outputs of each submodule are listed below
// and then connected accordingly when instantiating each module
  
// -- output from top_alu --
// don't list a0 here since that is output of entire cpu, hence not internal
logic zero;      // zero flag
logic aluresult;

// -- output from top_pc --
logic [ADDRESS_WIDTH-1:0] pc; // program counter 

// -- output from control unit --
// these are all control signals
logic pcsrc; 
logic resultsrc;
logic memwrite;
logic alusrc;
logic [1:0] immsrc;
logic regwrite;
logic [2:0] alucontrol;
 
// -- output from data_mem --
logic [DATA_WIDTH-1:0] rd_dm; // instruction word from data memory

// -- output from instr_mem --
logic [DATA_WIDTH-1:0] instr; // instruction word from instruction memory

// -- output from reg_file
logic signed [DATA_WIDTH-1:0] rd1;   
logic signed [DATA_WIDTH-1:0] rd2;    

// -- output from sign_extend --
logic signed [DATA_WIDTH-1:0] immext; // 32-bit sign extended immediate operand 

// -- outputs from muxes --
logic signed [DATA_WIDTH-1:0] aluop2;    // output from alu_mux
logic signed [DATA_WIDTH-1:0] aluresult; // output from alu

top_alu topalu(
    .aluop1(rd1),
    .aluop2(aluop2),
    .aluresult(aluresult),
    .alucontrol(alucontrol),
    
    .zero(zero)
);

top_control_unit control_unit(
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

data_mem DataMemory(
    .a(aluresult),
    .wd(rd2),
    .we(memwrite),
    .clk(clk),

    .rd(rd_dm)
);

mux data_mem_mux(
    .input0(aluresult),
    .input1(rd_dm),
    .src(resultsrc),
    .out(result)
);

instr_mem instrMem(
    .a(pc),

    .rd(instr)
);

top_pc t_PC(
    .clk(clk),
    .rst(rst),
    .pcsrc(pcsrc),
    .immext(immext),
    .trigger(trigger),
    .pc_out(pc)
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

sign_extend signExtend(
    .instr(instr),
    .immsrc(immsrc),

    .immop(immext)
);



endmodule

