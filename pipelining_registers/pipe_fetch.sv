module pipe_fetch #(
    parameter ADDRESS_WIDTH = 32,
    DATA_WIDTH = 32
)(
    input logic clk,
    input logic [DATA_WIDTH-1:0] a,
    input logic [DATA_WIDTH-1:0] pcplus4f
    output logic [DATA_WIDTH-1:0] pcf,
    output logic [DATA_WIDTH-1:0] instrd
);

always_ff @ (posedge clk) begin
     <= next_pc;
end

    



endmodule
