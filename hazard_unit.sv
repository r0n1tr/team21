module hazard_unit(
    
    input logic [4:0]  Rs1E,
    input logic [4:0]  Rs2E,
    input logic [4:0]  RdM,
    input logic [4:0]  RdW,
    input logic        RegWriteM,
    input logic        RegWriteW,

    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE
);

always_comb begin
    if (Rs1E == RdW)        ForwardAE = 2'b01;
    else if (Rs1E == RdM)   ForwardAE = 2'b10;
    else                    ForwardAE = 2'b00;
    
end

always_comb begin
    if (Rs2E == RdW)        ForwardAE = 2'b01;
    else if (Rs2E == RdM)   ForwardAE = 2'b10;
    else                    ForwardAE = 2'b00;
    
end

endmodule

 