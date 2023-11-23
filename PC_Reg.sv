module PC_Reg #(
    parameter ADDRESS_WIDTH = 8,
    DATA_WIDTH = 32
)(
    //interface signals 
    input  logic             clk,
    input  logic             rst,
    input  logic [ADDRESS_WIDTH-1:0] next_PC,
    output logic [ADDRESS_WIDTH-1:0] PC
);

always_ff @ (posedge clk) begin

  if(rst) 
    PC <= {ADDRESS_WIDTH{1'b0}};
  else
    PC <= next_PC;

end


endmodule


