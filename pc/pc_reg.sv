module pc_reg #(
    parameter ADDRESS_WIDTH = 32
)(
    input  logic                     clk,
    input logic en_n,
    input  logic signed [ADDRESS_WIDTH-1:0] next_pc,

    output logic signed [ADDRESS_WIDTH-1:0] pc
);

always_ff @ (posedge clk) begin
    if(en_n == 1'b0) 
        pc <= next_pc;
    else   
        pc <= pc;
end


endmodule


