module hazard_unit(
    
    input logic [4:0]  Rs1D,
    input logic [4:0]  Rs2D,
    input logic [4:0]  RdE,
    input logic [4:0]  Rs1E,
    input logic [4:0]  Rs2E,
    input logic [4:0]  RdM,
    input logic [4:0]  RdW,
    input logic        RegWriteM,
    input logic        RegWriteW,
    input logic        PCSrcE,
    input logic        ResultSrcE,

    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE,
    output logic StallF,
    output logic StallD,
    output logic FlushD,
    output logic FlushE

);

logic lwstall;

always_comb begin
    if ((Rs1E == RdW) & RegWriteW & (Rs1E != 0))        ForwardAE <= 2'b01;
    else if ((Rs1E == RdM) & RegWriteM)   ForwardAE <= 2'b10;
    else                                  ForwardAE <= 2'b00;
    
end

always_comb begin
    if ((Rs2E == RdW) & RegWriteW & (Rs2E != 0))        ForwardBE = 2'b01;
    else if ((Rs2E == RdM) & RegWriteM)   ForwardBE = 2'b10;
    else                                  ForwardBE = 2'b00;
    
end

// flush if branch instruction is executed
assign FlushD = PCSrcE;
assign FlushE = PCSrcE;

// stall if lw instruction is executed when there's a data dependency on the next intruction
lwstall = ResultSrcE & ((Rs1D == RdE) | (Rs2D == RdE));
assign StallD = lwstall;
assign StallF = lwstall | PCSrcE; // stall PCF if a branch or a lw instrctuon is executed


endmodule

 
 
