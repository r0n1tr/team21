module multiplexer #(
    parameter WIDTH = 8
)(
    input  logic                        PCsrc,
    input  logic         [WIDTH-1:0]    ImmOp,
    input  logic         [WIDTH-1:0]    PC,
    output logic         [WIDTH-1:0]    next_PC 
);
logic [WIDTH-1:0] branch_PC;
logic [WIDTH-1:0] inc_PC;

always_comb begin
    if(PCsrc) 
        branch_PC = PC + ImmOp;
        next_PC = branch_PC;
    else 
        inc_PC = PC +  {{WIDTH-3{1'b0}}, 3'b100};
        next_PC = inc_PC;
end


endmodule 
