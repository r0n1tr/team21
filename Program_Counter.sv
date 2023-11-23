module Program_Counter #(
    parameter ADDRESS_WIDTH = 8,
    DATA_WIDTH = 32
)( //change 
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        PCsrc,
    input  logic         [DATA_WIDTH-1:0]    ImmOp,
    //input  logic         [WIDTH-1:0]    PC,
    output logic         [ADDRESS_WIDTH-1:0]    PC
);
    logic [ADDRESS_WIDTH-1:0] next_PC;

multiplexer myMultiplexer (
    .PCsrc(PCsrc),
    .ImmOp(ImmOp),
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
