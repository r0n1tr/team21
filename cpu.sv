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
logic signed [DATA_WIDTH-1:0]  aluresulte;
logic                          zeroe;      // zero flag
logic signed [DATA_WIDTH-1:-0] writedatae;

// -- output from control unit --
// these are all control signals
logic [2:0] resultsrcd;
logic       memwrited;
logic       alusrcd;
logic [2:0] immsrcd;
logic       regwrited;
logic [2:0] funct3d;
logic       jumpd;
logic       branchd;
logic       jalrd;  // Indicates if executing jalr
logic [3:0] alucontrold;

// -- output from data_mem --
logic [DATA_WIDTH-1:0] readdatam; // data word from data memory

// -- output from instr_mem --
logic [DATA_WIDTH-1:0] instrf; // instruction word from instruction memory

// -- output from top_pc --
logic [ADDRESS_WIDTH-1:0] pcf;
logic [ADDRESS_WIDTH-1:0] pcplus4f;
logic [ADDRESS_WIDTH-1:0] pctargete;

// -- output from reg_file --
logic signed [DATA_WIDTH-1:0] rd1d;   
logic signed [DATA_WIDTH-1:0] rd2d;    

// -- output from sign_extend --
logic signed [DATA_WIDTH-1:0] immextd; // 32-bit sign extended immediate operand 

// --output from result_mux -- (the mux that has select == resultsrc)
logic signed [DATA_WIDTH-1:0] resultw;

// ----- pipelining signals -----

// -- output from pipeline register: decode --
    logic        [DATA_WIDTH-1:0]    instrd;    
    logic        [ADDRESS_WIDTH-1:0] pcd;
    logic        [ADDRESS_WIDTH-1:0] pcplus4d;

// -- output from pipeline register: execute --
    // control path output
    logic       regwritee;
    logic [2:0] resultsrce;
    logic       memwritee;
    logic       jumpe;
    logic       branche;
    logic [3:0] alucontrole;
    logic       alusrce;
    logic       jalre;
    logic [2:0] funct3e;

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
    logic [2:0] resultsrcm;
    logic       memwritem;
    logic [2:0] funct3m;

    // data path output
    logic [DATA_WIDTH-1:0]          aluresultm;
    logic [DATA_WIDTH-1:0]          writedatam;
    logic [REG_FILE_ADDR_WIDTH-1:0] rdm;
    logic [DATA_WIDTH-1:0]          pcplus4m;
    logic [DATA_WIDTH-1:0]          immextm;
    logic [ADDRESS_WIDTH-1:0]       pctargetm;

// -- output from pipeline register: writeback --
    // control path output
    logic       regwritew;
    logic [2:0] resultsrcw;
    
    // data path output
    logic [DATA_WIDTH-1:0]          aluresultw;
    logic [DATA_WIDTH-1:0]          readdataw;
    logic [REG_FILE_ADDR_WIDTH-1:0] rdw;
    logic [DATA_WIDTH-1:0]          pcplus4w;
    logic [DATA_WIDTH-1:0]          immextw;
    logic [ADDRESS_WIDTH-1:0]       pctargetw;

// -- output from branch_decoder --
logic should_branch_e;

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
    .rd1(rd1e),
    .rd2(rd2e),
    .immext(immexte),

    .forwardae(forwardae),
    .forwardbe(forwardbe),
    .aluresultm(aluresultm),
    .resultw(resultw),
    
    .aluresult(aluresulte),
    .zero(zeroe),
    .writedatae(writedatae)
);

top_control_unit top_control_unit(
    .instr(instrd),

    .regwrite(regwrited),
    .resultsrc(resultsrcd),
    .memwrite(memwrited),
    .jump(jumpd),
    .branch(branchd),
    .alucontrol(alucontrold),
    .alusrc(alusrcd),
    .immsrc(immsrcd),
    .jalr(jalrd),  // custom control signal to indicate if executing jalr
    .funct3(funct3d) // for data_mem, branch_decoder
);


memory top_data_mem(
    .clk(clk),
    .rst(rst),
    .we(memwritem),
    .wd(writedatam),
    .alu_result(aluresultm),
    .memcontrol(funct3m),

    .readdata(readdatam)
);


instr_mem instr_mem(
    .a(pcf),

    .instr(instrf)
);

top_pc top_PC(
    .clk(clk),
    .rst(rst),
    .trigger(trigger),
    .en_b(stallf),
    .pcsrc(pcsrce),
    .immexte(immexte),
    .pce(pce),
    .aluresulte(aluresulte),

    .pcplus4(pcplus4f),
    .pctargete(pctargete),
    .pc(pcf)
);

reg_file reg_file(
    .clk(clk),
    .we3(regwritew),
    .wd3(resultw),
    .ad1(instrd[19:15]),
    .ad2(instrd[24:20]),
    .ad3(rdw),

    .rd1(rd1d),
    .rd2(rd2d),
    .a0(a0)
);

sign_extend signExtend(
    .instr(instrd),
    .immsrc(immsrcd),

    .immext(immextd)
);

mux3 result_mux(
    .input0(aluresultw),
    .input1(readdataw),
    .input2(pcplus4w),
    .input3(immextw),
    .input4(pctargetw),
    .input5({32{1'b0}}), // not using input 5 - set to 0 by default
    .input6({32{1'b0}}), // not using input 6 - set to 0 by default
    .input7({32{1'b0}}), // not using input 7 - set to 0 by default  
    .select(resultsrcw),

    .out(resultw)
);

pipeline_reg_decode pipeline_reg_decode(
    .clk(clk),
    .en_b(stalld),
    .clr(flushd),

    .instrf(instrf),
    .pcf(pcf),
    .pcplus4f(pcplus4f),

    .instrd(instrd),
    .pcd(pcd),
    .pcplus4d(pcplus4d)
);

pipeline_reg_execute pipeline_reg_execute(
    .clk(clk),
    .clr(flushe),

    .regwrited(regwrited),
    .resultsrcd(resultsrcd),
    .memwrited(memwrited),
    .jumpd(jumpd),     
    .branchd(branchd),
    .alucontrold(alucontrold),
    .alusrcd(alusrcd),
    .jalrd(jalrd),
    .funct3d(funct3d),

    .rd1d(rd1d),
    .rd2d(rd2d),
    .pcd(pcd),
    .rs1d(instrd[19:15]),
    .rs2d(instrd[24:20]),
    .rdd(instrd[11:7]),
    .immextd(immextd),
    .pcplus4d(pcplus4d),

    .regwritee(regwritee),
    .resultsrce(resultsrce),
    .memwritee(memwritee),
    .jumpe(jumpe),
    .branche(branche),
    .alucontrole(alucontrole),
    .alusrce(alusrce),
    .jalre(jalre),
    .funct3e(funct3e),

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
    .funct3e(funct3e),

    .aluresulte(aluresulte),
    .writedatae(writedatae),
    .rde(rde),
    .pcplus4e(pcplus4e),
    .immexte(immexte),
    .pctargete(pctargete),

    .regwritem(regwritem),
    .resultsrcm(resultsrcm),
    .memwritem(memwritem),
    .funct3m(funct3m),

    .aluresultm(aluresultm),
    .writedatam(writedatam),
    .rdm(rdm),
    .pcplus4m(pcplus4m),
    .immextm(immextm),
    .pctargetm(pctargetm)
);

pipeline_reg_writeback pipeline_reg_writeback(
    .clk(clk),

    .regwritem(regwritem),
    .resultsrcm(resultsrcm),

    .aluresultm(aluresultm),
    .readdatam(readdatam),
    .rdm(rdm),
    .pcplus4m(pcplus4m),
    .immextm(immextm),
    .pctargetm(pctargetm),

    .regwritew(regwritew),
    .resultsrcw(resultsrcw),

    .aluresultw(aluresultw),
    .readdataw(readdataw),
    .rdw(rdw),
    .pcplus4w(pcplus4w),
    .immextw(immextw),
    .pctargetw(pctargetw)
);

branch_decoder branch_decoder(
    .branch(branche),
    .zero(zeroe),   
    .funct3(funct3e), 

    .should_branch(should_branch_e) 
);
  
pcsrc_logic pcsrc_logic(
    .should_branch(should_branch_e), 
    .should_jal(jumpe),   
    .should_jalr(jalre), 

    .pcsrce(pcsrce)
);

hazard_unit hazard_unit(
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
    .resultsrce(resultsrce),

    .forwardae(forwardae),
    .forwardbe(forwardbe),
    .stallf(stallf),
    .stalld(stalld),
    .flushd(flushd),
    .flushe(flushe)
);

endmodule

