module multiplexer #(
    parameters WIDTH = 32
)(
    input  logic                        PCsrc,
    input  logic         [WIDTH-1:0]    ImmOP,
    input  logic         [WIDTH-1:0]    PC,
    output logic         [WIDTH-1:0]    next_PC 
    
);
logic [WIDTH-1:0] branch_PC;
logic [WIDTH-1:0] inc_PC;

if(PCsrc) begin 
branch_PC <= PC + ImmOP;
next_PC <= branch_PC;
end 
else begin
inc_PC <= PC +  {{WIDTH-3{1'b0}}, 3'b100};
next_PC <= inc_PC;
end 

endmodule


