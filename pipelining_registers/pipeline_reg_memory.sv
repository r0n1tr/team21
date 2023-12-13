module pipeline_reg_memory # (
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 32,
              REG_FILE_ADDR_WIDTH = 5
)(
    input logic clk,

    // control path input
    input logic       regwritee,
    input logic [2:0] resultsrce,
    input logic       memwritee,
    input logic [2:0] funct3e,

    // data path input
    input logic [DATA_WIDTH-1:0]          aluresulte,
    input logic [DATA_WIDTH-1:0]          writedatae,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rde,
    input logic [ADDRESS_WIDTH-1:0]       pcplus4e,
    input logic [DATA_WIDTH-1:0]          immexte,
    input logic [ADDRESS_WIDTH-1:0]       pctargete,

    // control path output
    output logic       regwritem,
    output logic [2:0] resultsrcm,
    output logic       memwritem,
    output logic [2:0] funct3m,

    // data path output
    output logic [DATA_WIDTH-1:0]          aluresultm,
    output logic [DATA_WIDTH-1:0]          writedatam,
    output logic [REG_FILE_ADDR_WIDTH-1:0] rdm,
    output logic [ADDRESS_WIDTH-1:0]       pcplus4m, 
    output logic [DATA_WIDTH-1:0]          immextm,
    output logic [ADDRESS_WIDTH-1:0]       pctargetm
);

always_ff @(posedge clk) begin
    regwritem  <= regwritee;
    resultsrcm <= resultsrce;
    memwritem  <= memwritee;
    funct3m    <= funct3e;
    
    aluresultm <= aluresulte;
    writedatam <= writedatae;
    rdm        <= rde;
    pcplus4m   <= pcplus4e;
    immextm    <= immexte;
    pctargetm  <= pctargete;
end

endmodule
