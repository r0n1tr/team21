module cpu #(
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 32,
              REG_FILE_ADDR_WIDTH = 5
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
logic       regwrite;
logic [1:0] resultsrc;
logic       memwrite;
logic       jump;
logic       branch;
logic [2:0] alucontrol;
logic       alusrc;
logic [1:0] immsrc;
logic       jalr;  // custom signal to indicate if executing jalr

// -- output from data_mem --
logic [DATA_WIDTH-1:0] readdata; // data word from data memory

// -- output from instr_mem --
logic [DATA_WIDTH-1:0] instr; // instruction word from instruction memory

// -- output from top_pc --
logic [ADDRESS_WIDTH-1:0] pc; 
logic [ADDRESS_WIDTH-1:0] pcplus4;

// -- output from reg_file --
logic signed [DATA_WIDTH-1:0] rd1;   
logic signed [DATA_WIDTH-1:0] rd2;    

// -- output from sign_extend --
logic signed [DATA_WIDTH-1:0] immext; // 32-bit sign extended immediate operand 

// --output from result_mux -- (the mux that has select == resultsrc)
logic signed [DATA_WIDTH-1:0] result;

// ----- pipelining signals -----

// -- output from pipeline register: decode --
    logic [DATA_WIDTH-1:0]    instrd;    
    logic [ADDRESS_WIDTH-1:0] pcd;
    logic [ADDRESS_WIDTH-1:0] pcplus4d;

// -- output from pipeline register: execute --
    // control path output
    logic       regwritee;
    logic [1:0] resultsrce;
    logic       memwritee;
    logic       jumpe;
    logic       branche;
    logic [2:0] alucontrole;
    logic       alusrce;
    logic       jalre;

    // data path output
    logic [DATA_WIDTH-1:0]          rd1e;
    logic [DATA_WIDTH-1:0]          rd2e;
    logic [ADDRESS_WIDTH-1:0]       pce;
    logic [REG_FILE_ADDR_WIDTH-1:0] rs1e;
    logic [REG_FILE_ADDR_WIDTH-1:0] rs2e;
    logic [REG_FILE_ADDR_WIDTH-1:0] rde;
    logic [DATA_WIDTH-1:0]          immexte;
    logic [ADDRESS_WIDTH-1:0]       pcplus4e;

// -- output from pipeline register: memory --
    // control path output
    logic       regwritem;
    logic [1:0] resultsrcm;
    logic       memwritem;

    // data path output
    logic [DATA_WIDTH-1:0]          aluresultm;
    logic [DATA_WIDTH-1:0]          writedatam;
    logic [REG_FILE_ADDR_WIDTH-1:0] rdm;
    logic [DATA_WIDTH-1:0]          pcplus4m;

// -- output from pipeline register: writeback --
    // control path output
    logic       regwritew;
    logic [1:0] resultsrcw;
    
    // data path output
    logic [DATA_WIDTH-1:0]          aluresultw;
    logic [DATA_WIDTH-1:0]          readdataw;
    logic [REG_FILE_ADDR_WIDTH-1:0] rdw;
    logic [DATA_WIDTH-1:0]          pcplus4w;


// -- output from pcsrcs_logic --
logic [1:0] pcsrce;

// -- output from hazard unit --
logic [1:0] forwardae;
logic [1:0] forwardbe;
logic       stallf;
logic       stalld;
logic       flushd;
logic       flushe;

// -------------------------------

top_alu top_alu(
    .alusrc(alusrce),
    .alucontrol(alucontrole),
    .rd1(srcae),
    .rd2(srcbe),
    .immext(immexte),
    
    .aluresult(aluresult),
    .zero(zero)
);

top_control_unit top_control_unit(
    .instr(instrd),
    .zero(zero),

    .regwrite(regwrite),
    .resultsrc(resultsrc),
    .memwrite(memwrite),
    .jump(jump),
    .branch(branch),
    .alucontrol(alucontrol),
    .alusrc(alusrc),
    .immsrc(immsrc),
    .jalr(jalr)  // custom control signal to indicate if executing jalr
);

data_mem data_mem(
    .clk(clk),
    .we(memwritem),
    .wd(writedatam),
    .a(aluresultm),

    .rd(readdata)
);

instr_mem instr_mem(
    .a(pc),

    .rd(instr)
);

top_pc top_PC(
    .clk(clk),
    .rst(rst),
    .trigger(trigger),
    .pcsrc(pcsrce),
    .pce(pce),
    .immexte(immexte),
    .en_b(stallf),
    .aluresult(aluresult),

    .pcplus4(pcplus4),
    .pc(pc)
);

reg_file reg_file(
    .clk(clk),
    .we3(regwritew),
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

mux2 result_mux(
    .input0(aluresultw),
    .input1(readdataw),
    .input2(pcplus4w),
    .select(resultsrcw),

    .out(result)
);

pipeline_reg_decode pipeline_reg_decode(
    .clk(clk),
    .en_b(stalld),
    .clr(flushd),

    .instrf(instr),
    .pcf(pc),
    .pcplus4f(pcplus4),

    .instrd(instrd),
    .pcd(pcd),
    .pcplus4d(pcplus4d)
);

pipeline_reg_execute pipeline_reg_execute(
    .clk(clk),
    .clr(flushe),

    .regwrited(regwrite),
    .resultsrcd(resultsrc),
    .memwrited(memwrite),
    .jumpd(jump),     //this might not work
    .branchd(branch), //this too
    .alucontrold(alucontrol),
    .alusrcd(alusrc),
    .jalrd(jalr),

    .rd1d(rd1),
    .rd2d(rd2),
    .pcd(pcd),
    .rs1d(instrd[19:15]),
    .rs2d(instrd[24:20]),
    .rdd(instrd[11:7]),
    .immextd(immext),
    .pcplus4d(pcplus4d),

    .regwritee(regwritee),
    .resultsrce(resultsrce),
    .memwritee(memwritee),
    .jumpe(jumpe),
    .branche(branche),
    .alucontrole(alucontrole),
    .alusrce(alusrce),
    .jalre(jalre),

    .rd1e(rd1e),
    .rd2e(rd2e),
    .pce(pce),
    .rs1e(rs1e),
    .rs2e(rs2e),
    .rde(rde),
    .immexte(immexte),
    .pcplus4e(pcplus4e)
);

pipeline_reg_memory pipeline_reg_memory(
    .clk(clk),

    .regwritee(regwritee),
    .resultsrce(resultsrce),
    .memwritee(memwritee),

    .aluresulte(aluresult),
    .writedatae(srcbe),
    .rde(rde),
    .pcplus4e(pcplus4e),

    .regwritem(regwritem),
    .resultsrcm(resultsrcm),
    .memwritem(memwritem),

    .aluresultm(aluresultm),
    .writedatam(writedatam),
    .rdm(rdm),
    .pcplus4m(pcplus4m)
);

pipeline_reg_writeback pipeline_reg_writeback(
    .clk(clk),

    .regwritem(regwritem),
    .resultsrcm(resultsrcm),

    .aluresultm(aluresultm),
    .readdatam(readdata),
    .rdm(rdm),
    .pcplus4m(pcplus4m),

    .regwritew(regwritew),
    .resultsrcw(resultsrcw),

    .aluresultw(aluresultw),
    .readdataw(readdataw),
    .rdw(rdw),
    .pcplus4w(pcplus4w)
);

pcsrc_logic pcsrc_logic(
    .jump(jumpe),
    .branch(branche),
    .zero(zero),
    .jalr(jalre),

    .pcsrce(pcsrce)
);
   
hazard_unit hazard(
    .rst(rst),
    .trigger(trigger),

    .rs1d(instrd[19:15]),
    .rs2d(instrd[24:20]),
    .rde(rde),
    .rs1e(rs1e),
    .rs2e(rs2e),
    .rdm(rdm),
    .rdw(rdw),
    .regwritem(regwritem),
    .regwritew(regwritew),
    .pcsrce(pcsrce),
    .resultsrce(resultsrce[0]),

    .forwardae(forwardae),
    .forwardbe(forwardbe),
    .stallf(stallf),
    .stalld(stalld),
    .flushd(flushd),
    .flushe(flushe)
);

// -----------------------------------
// TODO: would it not be cleaner if we...

// ...integrate into pcmux?
///////////////////////////
// logic [DATA_WIDTH-1:0] pctargete;
// pc_target target(
//     .pce(pce),
//     .immexte(immexte),

//     .pctargete(pctargete)
// );
//////////////////////////

// ...integrate into alu?
//////////////////////////
logic [DATA_WIDTH-1:0] srcae;
mux2 rd1_mux(
    .input0(rd1e),
    .input1(result),
    .input2(aluresultm),
    .select(forwardae),

    .out(srcae)
);
//////////////////////////

// ...integrate into alu?
//////////////////////////
logic [DATA_WIDTH-1:0] srcbe;
mux2 rd2_mux(
    .input0(rd2e),
    .input1(result),
    .input2(aluresultm),
    .select(forwardbe),

    .out(srcbe)
);
//////////////////////////

// ...idk


endmodule

