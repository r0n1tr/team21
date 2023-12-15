module pipeline_reg_writeback # (
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 32,
              REG_FILE_ADDR_WIDTH = 5
)(
    input logic clk,

    // control path input
    input logic       regwritem,
    input logic [2:0] resultsrcm,

    // data path input
    input logic [DATA_WIDTH-1:0]          aluresultm,
    input logic [DATA_WIDTH-1:0]          readdatam,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rdm,
    input logic [DATA_WIDTH-1:0]          pcplus4m,
    input logic [DATA_WIDTH-1:0]          immextm,
    input logic [ADDRESS_WIDTH-1:0]       pctargetm,

    // control path output
    output logic       regwritew,
    output logic [2:0] resultsrcw,
    
    // data path output
    output logic [DATA_WIDTH-1:0]          aluresultw,
    output logic [DATA_WIDTH-1:0]          readdataw,
    output logic [REG_FILE_ADDR_WIDTH-1:0] rdw,
    output logic [DATA_WIDTH-1:0]          pcplus4w,
    output logic [DATA_WIDTH-1:0]          immextw,
    output logic [ADDRESS_WIDTH-1:0]       pctargetw
);

always_ff @(posedge clk) begin  
    regwritew  <= regwritem;
    resultsrcw <= resultsrcm;

    aluresultw <= aluresultm;
    readdataw  <= readdatam;
    rdw        <= rdm;
    pcplus4w   <= pcplus4m;
    immextw    <= immextm;
    pctargetw  <= pctargetm;
end

endmodule
