module pc_reg #(
    parameter ADDRESS_WIDTH = 32
)(
    input logic                     clk,
    input logic                     en_b,
    input logic [ADDRESS_WIDTH-1:0] next_pc,

    output logic [ADDRESS_WIDTH-1:0] pc
);

always_ff @ (posedge clk) begin
    if(!en_b) pc <= next_pc;
end


endmodule


