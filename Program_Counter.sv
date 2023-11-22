module Program_Counter #(
    parameter WIDTH = 8
)( //change 
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        PCsrc,
    input  logic         [WIDTH-1:0]    ImmOp,
    input  logic         [WIDTH-1:0]    PC,
    output logic         [WIDTH-1:0]    PC
);
    logic [WIDTH-1:0] next_PC;

multiplexer myMultiplexer (
    .PCsrc(PCsrc),
    .ImmOP(ImmOp),
    .PC(PC),
    .next_PC(next_PC)

);

PC_Reg myPC_Reg(
    .clk(clk),
    .rst(rst),
    .next_PC(next_PC),
    .PC(PC)
);

endmodule
