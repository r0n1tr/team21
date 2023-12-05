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
//logic [WRITE_WIDTH-1:0] rdf;
// pipeline registers

// pipeline internal wires

// fetch output wires
logic signed [DATA_WIDTH-1:0]       instrd;
logic [ADDRESS_WIDTH-1:0]    pcd;
logic [ADDRESS_WIDTH-1:0]    pcplus4d;

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

//pipeline control signal wires
logic regwritem;
logic [1:0] resultsrcm;
logic memwritem;
logic regwritee;
logic [1:0] resultsrce;
logic memwritee;
logic jumpe;
logic branche;
logic [2:0] alucontrole;
logic alusrce;
logic regwritew;
logic [1:0] resultsrcw;
logic [1:0] pcsrce;


// hazard unit wires
logic stallf;
logic stalld;
logic flushd;
logic flushe;
logic [1:0] forwardae;
logic [1:0] forwardbe;
logic [WRITE_WIDTH-1:0] rs1e;
logic [WRITE_WIDTH-1:0] rs2e;

pipe_fetch fetch(
    .clk(clk),
    .rd(instr),
    .pcf(pc),
    .pcplus4f(pcplus4),
    .en_n(stalld),
    .clr(flushd),

    .instrd(instrd),
    .pcd(pcd),
    .pcplus4d(pcplus4d)

);



logic jalre;
pipe_decode decode(
    .clk(clk),
    .rd1d(rd1),
    .rd2d(rd2),
    .pcd(pcd),
    .rdd(instrd[11:7]),
    .immextd(immext),
    .pcplus4d(pcplus4d),
    .clr(flushe),
    .rs1d(instrd[19:15]),
    .rs2d(instrd[24:20]),
    .jalrd(jalr),

    .regwrited(regwrite),
    .resultsrcd(resultsrc),
    .memwrited(memwrite),
    .jumpd(jump), //this might not work
    .branchd(branch), //this too
    .alucontrold(alucontrol),
    .alusrcd(alusrc),
    .jalre(jalre),

    .regwritee(regwritee),
    .resultsrce(resultsrce),
    .memwritee(memwritee),
    .jumpe(jumpe),
    .branche(branche),
    .alucontrole(alucontrole),
    .alusrce(alusrce),

    .rd1e(rd1e),
    .rd2e(rd2e),
    .rs1e(rs1e),
    .rs2e(rs2e),
    .pce(pce),
    .rde(rde),
    .immexte(immexte),
    .pcplus4e(pcplus4e)

);


pc_logic pc_logic(
    .jump(jumpe),
    .branch(branche),
    .zeroe(zero),
    .jalr(jalre),

    .pcsrce(pcsrce)
);
   

pipe_execute execute(
    .clk(clk),
    .aluresulte(aluresult),
    .writedatae(srcbe),
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
    .select(resultsrcw),

    .out(result)
);

logic [DATA_WIDTH-1:0] srcae;
logic [DATA_WIDTH-1:0] srcbe;

mux2 rd1_mux(
    .input0(rd1e),
    .input1(result),
    .input2(aluresultm),
    .select(forwardae),

    .out(srcae)
);

mux2 rd2_mux(
    .input0(rd2e),
    .input1(result),
    .input2(aluresultm),
    .select(forwardbe),

    .out(srcbe)
);


top_alu top_alu(
    .alusrc(alusrce),
    .alucontrol(alucontrole),
    .rd1(srcae),
    .rd2(srcbe),
    .immext(immexte),
    
    .aluresult(aluresult),
    .zero(zero)
);
 logic jalr;
top_control_unit control_unit(
    .instr(instrd),
    .zero(zero),

    .jump(jump),
    .branch(branch),
    .jalr(jalr),
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

logic [DATA_WIDTH-1:0] pctargete;

instr_mem instr_mem(
    .a(pc),

    .rd(instr)
);

pc_target target(
    .pce(pce),
    .immexte(immexte),

    .pctargete(pctargete)
);


top_pc top_PC(
    .clk(clk),
    .rst(rst),
    .trigger(trigger),
    .pcsrc(pcsrce),
    .immext(pctargete),
    .en_n(stallf),
    .result(result),

    .pcplus4(pcplus4),
    .pc(pc)
);

hazard_unit hazard(
    .rs1d(instrd[19:15]),
    .rs2d(instrd[24:20]),
    .rde(rde),
    .rs1e(rs1e),
    .rs2e(rs2e),
    .rdm(rdm),
    .rdw(rdw),
    .regwritem(regwritem),
    .regwritew(regwritew),
    .pcsrce(pcsrce[0]),
    .resultsrce(resultsrce[0]),

    .forwardae(forwardae),
    .forwardbe(forwardbe),
    .stallf(stallf),
    .stalld(stalld),
    .flushd(flushd),
    .flushe(flushe)

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
    .instr(instrd),
    .immsrc(immsrc),

    .immext(immext)
);

endmodule

