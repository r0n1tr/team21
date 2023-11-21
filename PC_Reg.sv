module PC_Reg #(
    parameters WIDTH = 32
)(
    //interface signals 
    input  logic             clk,
    input  logic             rst,
    input  logic [WIDTH-1:0] next_PC,
    output logic [WIDTH-1:0] PC
);

always_ff @ (posedge clk)
  if (rst) PC <= {WIDTH{1'b0}};
  else PC <= next_PC;
endmodule


