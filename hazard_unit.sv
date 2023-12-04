module hazard_unit(

    input logic [4:0]  rs1d,
    input logic [4:0]  rs2d,
    input logic [4:0]  rde,
    input logic [4:0]  rs1e,
    input logic [4:0]  rs2e,
    input logic [4:0]  rdm,
    input logic [4:0]  rdw,
    input logic        regwritem,
    input logic        regwritew,
    input logic        pcsrce,
    input logic        resultsrce,

    output logic [1:0] forwardae,
    output logic [1:0] forwardbe,
    output logic stallf,
    output logic stalld,
    output logic flushd,
    output logic flushe

);

logic lwstall;

always_comb begin
    if ((rs1e == rdw) & regwritew)        ForwardAE = 2'b01;
    else if ((rs1e == rdm) & regwritem)   ForwardAE = 2'b10;
    else                                  ForwardAE = 2'b00;
    if ((rs1e == rdw) & regwritew & (rs1e != 0))        ForwardAE <= 2'b01;
    else if ((rs1e == rdm) & regwritem)   ForwardAE <= 2'b10;
    else                                  ForwardAE <= 2'b00;

end

always_comb begin
    if ((rs2e == rdw) & regwritew)        ForwardBE = 2'b01;
    if ((rs2e == rdw) & regwritew & (rs2e != 0))        ForwardBE = 2'b01;
    else if ((rs2e == rdm) & regwritem)   ForwardBE = 2'b10;
    else                                  ForwardBE = 2'b00;

end

// flush if branch instruction is executed
assign flushd = pcsrce;
assign flushe = pcsrce;

// stall if lw instruction is executed when there's a data dependency on the next intruction
lwstall = resultsrce & ((rs1d == rde) | (rs2d == rde));
assign StallD = lwstall;
assign StallF = lwstall | pcsrce; // stall PCF if a branch or a lw instrctuon is executed


endmodule
