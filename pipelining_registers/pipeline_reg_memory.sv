module pipeline_reg_memory # (
    parameter DATA_WIDTH = 32,
              REG_FILE_ADDR_WIDTH = 5
)(
    input logic clk,

    // control path input
    input logic       regwritee,
    input logic [1:0] resultsrce,
    input logic       memwritee,

    // data path input
    input logic [DATA_WIDTH-1:0]          aluresulte,
    input logic [DATA_WIDTH-1:0]          writedatae,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rde,
    input logic [DATA_WIDTH-1:0]          pcplus4e,

    // control path output
    output logic       regwritem,
    output logic [1:0] resultsrcm,
    output logic       memwritem,

    // data path output
    output logic [DATA_WIDTH-1:0]          aluresultm,
    output logic [DATA_WIDTH-1:0]          writedatam,
    output logic [REG_FILE_ADDR_WIDTH-1:0] rdm,
    output logic [DATA_WIDTH-1:0]          pcplus4m 
);

always_ff @(posedge clk) begin
    regwritem  <= regwritee;
    resultsrcm <= resultsrce;
    memwritem  <= memwritee;
    
    aluresultm <= aluresulte;
    writedatam <= writedatae;
    rdm        <= rde;
    pcplus4m   <= pcplus4e;
end

endmodule
