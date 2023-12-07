module hazard_unit #(
    parameter REG_FILE_ADDR_WIDTH = 5
)(
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs1d,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs2d,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rde,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs1e,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs2e,
    input logic                           pcsrce,
    input logic                           resultsrce,
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

logic lwstall;

/*
    Idea for how to input hazard unit taken from:
        Digital Design and Computer Architecture: RISC-V Edition 
        by Sarah Harris, David Harris
        Section 7.5.3 Hazards
*/

always_comb begin
    // clear hazard outputs
    {stallf, stalld, flushd, flushe, forwardae, forwardbe} = '0;

    // rs1 forwarding
    if (((rs1e == rdm) && regwritem) && (rs1e != 0)) forwardae = 2'b10; // forward (memory stage)
    else if ((rs1e == rdw) & regwritew)              forwardae = 2'b01; // forward (writeback stage)
    else                                             forwardae = 2'b00; // no hazard --> no forwarding needed

    // rs2 forwarding
    if (((rs2e == rdm) && regwritem) && (rs2e != 0)) forwardbe = 2'b10; // forward (memory stage)
    else if ((rs2e == rdw) & regwritew)              forwardbe = 2'b01; // forward (writeback stage)
    else                                             forwardbe = 2'b00; // no hazard --> no forwarding needed
end

// stall if lw instruction is executed when there's a data dependency on the next intruction
assign lwstall = resultsrce && ((rs1d == rde) | (rs2d == rde));
assign stallf  = lwstall; // stall PCF if a branch or a lw instrctuon is executed
assign stalld  = lwstall;

assign flushd  = pcsrce;
assign flushe  = lwstall | pcsrce;

endmodule
