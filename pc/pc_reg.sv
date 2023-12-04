module pc_reg #(
    parameter ADDRESS_WIDTH = 32
)(
    input  logic                     clk,
    input  logic signed [ADDRESS_WIDTH-1:0] next_pc,

    output logic signed [ADDRESS_WIDTH-1:0] pc
);

always_ff @ (posedge clk) begin
    pc <= next_pc;
end


endmodule


