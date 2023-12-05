module cpu #(
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 32,
              WRITE_WIDTH = 5
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
logic signed [DATA_WIDTH-1:0] aluresult;
logic                         zero;      // zero flag

// -- output from control unit --
// these are all control signals
logic [1:0] pcsrc; 
logic [1:0] resultsrc;
logic memwrite;
logic alusrc;
logic [1:0] immsrc;
logic regwrite;
logic [2:0] alucontrol;
 
// -- output from data_mem --
logic [DATA_WIDTH-1:0] rd_dm; // instruction word from data memory

// -- output from instr_mem --
logic [DATA_WIDTH-1:0] instr; // instruction word from instruction memory

// -- output from top_pc --
logic [ADDRESS_WIDTH-1:0] pc; // program counter 
logic [ADDRESS_WIDTH-1:0] pcplus4;

// -- output from reg_file --
logic signed [DATA_WIDTH-1:0] rd1;   
logic signed [DATA_WIDTH-1:0] rd2;    

// -- output from sign_extend --
logic signed [DATA_WIDTH-1:0] immext; // 32-bit sign extended immediate operand 

// --output from result_mux -- (the mux that has select == resultsrc)
logic signed [DATA_WIDTH-1:0] result;
logic [WRITE_WIDTH-1:0] rdf;
// pipeline registers

// pipeline internal wires

// fetch output wires
logic signed [DATA_WIDTH-1:0]       instrd;
logic [ADDRESS_WIDTH-1:0]    pcd;
logic [ADDRESS_WIDTH-1:0]    pcplus4d;
logic [WRITE_WIDTH-1:0]      rdd;

//decode output wires
logic signed [DATA_WIDTH-1:0] rd1e;
logic signed [DATA_WIDTH-1:0] rd2e;
logic [ADDRESS_WIDTH-1:0] pce;
logic [WRITE_WIDTH-1:0] rde;
logic signed [DATA_WIDTH-1:0] immexte;
logic [ADDRESS_WIDTH-1:0] pcplus4e;


//execute output wires
logic signed[DATA_WIDTH-1:0] aluresultm;
logic signed[DATA_WIDTH-1:0] writedatam;
logic [WRITE_WIDTH-1:0] rdm;
logic signed[DATA_WIDTH-1:0] pcplus4m;

// memory output wires
logic signed [DATA_WIDTH-1:0] aluresultw;
logic signed [DATA_WIDTH-1:0] readdataw;
logic  [WRITE_WIDTH-1:0] rdw;
logic signed [DATA_WIDTH-1:0] pcplus4w;

pipe_fetch fetch(
    .clk(clk),
    .rd(instr),
    .pcf(pc),
    .pcplus4f(pcplus4),

    .instrd(instrd),
    .pcd(pcd),
    .pcplus4d(pcplus4d),
    .rdd(rdd)

);

pipe_decode decode(
    .clk(clk),
    .rd1d(rd1),
    .rd2d(rd2),
    .pcd(pcd),
    .rdd(instrd[11:7]),
    .immextd(immext),
    .pcplus4d(pcplus4d),

    .rd1e(rd1e),
    .rd2e(rd2e),
    .pce(pce),
    .rde(rde),
    .immexte(immexte),
    .pcplus4e(pcplus4e)

);

pipe_execute execute(
    .clk(clk),
    .aluresulte(aluresult),
    .writedatae(rd2e),
    .rde(rde),
    .pcplus4e(pcplus4e),

    .aluresultm(aluresultm),
    .writedatam(writedatam),
    .rdm(rdm),
    .pcplus4m(pcplus4m)
);

pipe_memory memory(
    .clk(clk),
    .aluresultm(aluresultm),
    .readdatam(rd_dm),
    .rdm(rdm),
    .pcplus4m(pcplus4m),

    .aluresultw(aluresultw),
    .readdataw(readdataw),
    .rdw(rdw),
    .pcplus4w(pcplus4w)
);

mux2 result_mux(
    .input0(aluresultw),
    .input1(readdataw),
    .input2(pcplus4w),
    .input3({32{1'b0}}), // not using input 3 - set to 0 by default
    .select(resultsrc),

    .out(result)
);



top_alu top_alu(
    .alusrc(alusrc),
    .alucontrol(alucontrol),
    .rd1(rd1e),
    .rd2(rd2e),
    .immext(immexte),
    
    .aluresult(aluresult),
    .zero(zero)
);

top_control_unit control_unit(
    .instr(instr),
    .zero(zero),

    .pcsrc(pcsrc),
    .resultsrc(resultsrc),
    .memwrite(memwrite),
    .alusrc(alusrc),
    .immsrc(immsrc),
    .regwrite(regwrite),
    .alucontrol(alucontrol)
);

data_mem data_mem(
    .clk(clk),
    .we(memwrite),
    .wd(writedatam),
    .a(aluresultm),

    .rd(rd_dm)
);



instr_mem instr_mem(
    .a(pc),

    .rd(instr)
);

top_pc top_PC(
    .clk(clk),
    .rst(rst),
    .trigger(trigger),
    .pcsrc(pcsrc),
    .immext(immexte),
    .result(result),

    .pcplus4(pcplus4),
    .pc(pce)
);

reg_file reg_file(
    .clk(clk),
    .we3(regwrite),
    .wd3(result),
    .ad1(instrd[19:15]),
    .ad2(instrd[24:20]),
    .ad3(rdw),

    .rd1(rd1),
    .rd2(rd2),
    .a0(a0)
);

sign_extend signExtend(
    .instr(instrd[31:7]),
    .immsrc(immsrc),

    .immext(immext)
);

endmodule

