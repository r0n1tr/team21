module pc_reg #(
    parameter ADDRESS_WIDTH = 8
)(
    input  logic                     clk,
    input  logic                     rst,
    input  logic [ADDRESS_WIDTH-1:0] next_pc,

    output logic [ADDRESS_WIDTH-1:0] pc
);

always_ff @ (posedge clk) begin

  if(rst) 
    pc <= {ADDRESS_WIDTH{1'b0}};
  else
    pc <= next_pc;

end


endmodule


