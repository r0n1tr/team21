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
    if (((rs1e == rdm) && regwritem) && (rs1e != 0))        forwardae = 2'b10;
    else if ((rs1e == rdw) & regwritew)   forwardae = 2'b01;
    else                                  forwardae = 2'b00;

    if (((rs2e == rdm) && regwritem) && (rs2e != 0))        forwardbe = 2'b10;
    else if ((rs2e == rdw) & regwritew)   forwardbe = 2'b01;
    else                                  forwardbe = 2'b00;


end

// stall if lw instruction is executed when there's a data dependency on the next intruction
assign lwstall = resultsrce & ((rs1d == rde) | (rs2d == rde));
assign stallf = lwstall; // stall PCF if a branch or a lw instrctuon is executed
assign stalld = lwstall;


// flush if branch instruction is executed
assign flushd = pcsrce;
assign flushe = lwstall | pcsrce;



endmodule
