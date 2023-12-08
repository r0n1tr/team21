module top_pc #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input logic                     clk,
    input logic                     rst,
    input logic                     trigger,
    input logic                     en_b,   // enable (b)ar - enable for pc reg (deasserted if pipeline stalling)
    input logic [1:0]               pcsrc,
    input logic [DATA_WIDTH-1:0]    immexte,
    input logic [ADDRESS_WIDTH-1:0] pce,
    input logic [DATA_WIDTH-1:0]    aluresult,
    
    output logic [ADDRESS_WIDTH-1:0] pcplus4, // output this for use in result_mux (for jal instruction)
    output logic [ADDRESS_WIDTH-1:0] pc
);

logic [ADDRESS_WIDTH-1:0] next_pc;

pc_reg pc_reg(
    .clk(clk),
    .next_pc(next_pc),
    .en_b(en_b),
    
    .pc(pc)
);

pc_mux pc_mux (
    .immexte(immexte),
    .pce(pce),
    .pc(pc),
    .pcsrc(pcsrc),
    .rst(rst),
    .trigger(trigger),
    .aluresult(aluresult),
    
    .pcplus4(pcplus4),
    .next_pc(next_pc)
);

endmodule
