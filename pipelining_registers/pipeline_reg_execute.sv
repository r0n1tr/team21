module pipeline_reg_execute #(
    parameter DATA_WIDTH = 32,
              ADDRESS_WIDTH = 32,
              REG_FILE_ADDR_WIDTH = 5

)(
    input logic clk,
    input logic clr,

    // control path input
    input logic       regwrited,
    input logic [1:0] resultsrcd,
    input logic       memwrited,
    input logic       jumpd,
    input logic       branchd,
    input logic [2:0] alucontrold,
    input logic       alusrcd,
    input logic       jalrd,    

    // data path input
    input logic [DATA_WIDTH-1:0]          rd1d,
    input logic [DATA_WIDTH-1:0]          rd2d,
    input logic [ADDRESS_WIDTH-1:0]       pcd,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs1d,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rs2d,
    input logic [REG_FILE_ADDR_WIDTH-1:0] rdd,
    input logic [DATA_WIDTH-1:0]          immextd,
    input logic [ADDRESS_WIDTH-1:0]       pcplus4d,

    // control path output
    output logic       regwritee,
    output logic [1:0] resultsrce,
    output logic       memwritee,
    output logic       jumpe,
    output logic       branche,
    output logic [2:0] alucontrole,
    output logic       alusrce,
    output logic       jalre,

    // data path output
    output logic [DATA_WIDTH-1:0]          rd1e,
    output logic [DATA_WIDTH-1:0]          rd2e,
    output logic [ADDRESS_WIDTH-1:0]       pce,
    output logic [REG_FILE_ADDR_WIDTH-1:0] rs1e,
    output logic [REG_FILE_ADDR_WIDTH-1:0] rs2e,
    output logic [REG_FILE_ADDR_WIDTH-1:0] rde,
    output logic [DATA_WIDTH-1:0]          immexte,
    output logic [ADDRESS_WIDTH-1:0]       pcplus4e
);

always_ff @ (posedge clk) begin
    if(clr) begin
        regwritee   <= 1'b0;
        resultsrce  <= 2'b0;
        memwritee   <= 1'b0;
        jumpe       <= 1'b0;
        branche     <= 1'b0;
        alucontrole <= 3'b0;
        alusrce     <= 1'b0;
        jalre       <= 1'b0;

        rd1e     <= 32'b0;
        rd2e     <= 32'b0;
        rs1e     <=  5'b0;
        rs2e     <=  5'b0;
        pce      <= 32'b0;
        rde      <=  5'b0;
        immexte  <= 32'b0;
        pcplus4e <= 32'b0; 
    end
    else begin
        regwritee   <= regwrited;
        resultsrce  <= resultsrcd;
        memwritee   <= memwrited;
        jumpe       <= jumpd;
        branche     <= branchd;
        alucontrole <= alucontrold;
        alusrce     <= alusrcd;

        rd1e     <= rd1d;
        rd2e     <= rd2d;
        rs1e     <= rs1d;
        rs2e     <= rs2d;
        pce      <= pcd;
        rde      <= rdd;
        jalre    <= jalrd;
        immexte  <= immextd;
        pcplus4e <= pcplus4d;
    end
end

endmodule