module hazard_unit #(
    parameter REG_FILE_ADDR_WIDTH = 5
)(
    input logic                           rst,
    input logic                           trigger,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs1d,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs2d,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rde,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs1e,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs2e,
    input logic [1:0]                     pcsrce,
    input logic [2:0]                     resultsrce,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rdm,
    input logic                           regwritem,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rdw,
    input logic                           regwritew,

    output logic [1:0] forwardae,
    output logic [1:0] forwardbe,
    output logic       stallf,
    output logic       stalld,
    output logic       flushd,
    output logic       flushe
);

logic loadstall;

/*
    Idea for how to input hazard unit taken from:
        Digital Design and Computer Architecture: RISC-V Edition 
        by Sarah Harris, David Harris
        Section 7.5.3 Hazards
*/

always_comb begin
    // rs1 forwarding to avoid data hazards
    if (((rs1e == rdm) && regwritem) && (rs1e != 0)) forwardae = 2'b10; // forward (memory stage)   [Explanation of condition: if rs1e (a register being used in the execute stage) is the same as rdm (a register used by an instruction later in the pipeline) and regwritem = 1 (the instruction later in the pipeling shouldve written to the register) AND the register being potentially written to wasnt the 0 register: forward the value of the later instruction to the instruction currently executing]
    else if ((rs1e == rdw) & regwritew)              forwardae = 2'b01; // forward (writeback stage)
    else                                             forwardae = 2'b00; // no hazard --> no forwarding needed

    // rs2 forwarding to avoid data hazards
    if (((rs2e == rdm) && regwritem) && (rs2e != 0)) forwardbe = 2'b10; // forward (memory stage)
    else if ((rs2e == rdw) & regwritew)              forwardbe = 2'b01; // forward (writeback stage)
    else                                             forwardbe = 2'b00; // no hazard --> no forwarding needed

    // stall if load instruction is executed when there's a data dependency on the next intruction (which is a hazard)
    loadstall = (resultsrce == 3'b001) && ((rs1d == rde) | (rs2d == rde));
    stallf  = loadstall;                      // stall program counter if a branch or load instrctuon is executed
    stalld  = ~(~loadstall | rst | ~trigger); // stall if loadstall=0 OR rst=1 OR trigger = 0. invert the entire thing as decode pipeline register's enable is active low. Having trigger and rst here stops the instruction at the the current PC address from being read into the pipeline even though the cpu is not yet activated.

    flushd  = (pcsrce == 2'b01 || pcsrce == 2'b10);              // Flush if branching 
    flushe  = (pcsrce == 2'b01 || pcsrce == 2'b10) || loadstall; // Flush if branching or load instruction introduces a bubble
end

endmodule
