module pipe_decode #(
    parameter DATA_WIDTH = 32,
               ADDRESS_WIDTH = 32,
               WRITE_WIDTH = 5

)(
    input logic clk,
    input logic [DATA_WIDTH-1:0] rd1d,    // could be simplified to match what they are called in ALU 
    input logic [DATA_WIDTH-1:0] rd2d,
    input logic [ADDRESS_WIDTH-1:0] pcd,
    input logic [WRITE_WIDTH-1:0] rdd,
    input logic [DATA_WIDTH-1:0] immextd,
    input logic [ADDRESS_WIDTH-1:0] pcplus4d,
    input logic [WRITE_WIDTH-1:0] rs1d,
    input logic [WRITE_WIDTH-1:0] rs2d,

    input logic regwrited,
    input logic [1:0] resultsrcd,
    input logic memwrited,
    input logic jumpd,
    input logic branchd,
    input logic [2:0] alucontrold,
    input logic alusrcd,
    input logic clr,
    input logic jalrd,    
    

    output logic regwritee,
    output logic [1:0] resultsrce,
    output logic memwritee,
    output logic jumpe,
    output logic branche,
    output logic [2:0] alucontrole,
    output logic alusrce,
    output logic jalre,

    output logic [DATA_WIDTH-1:0] rd1e,
    output logic [DATA_WIDTH-1:0] rd2e,
    output logic [ADDRESS_WIDTH-1:0] pce,
    output logic [WRITE_WIDTH-1:0] rde,
    output logic [DATA_WIDTH-1:0] immexte,
    output logic [ADDRESS_WIDTH-1:0] pcplus4e,
    output logic [WRITE_WIDTH-1:0] rs1e,
    output logic [WRITE_WIDTH-1:0] rs2e

);

always_ff @ (posedge clk) begin
    if(clr) begin
        regwritee <= 1'b0;
        resultsrce <= 2'b0;
        memwritee <= 1'b0;
        jumpe <= 1'b0;
        branche <= 1'b0;
        alucontrole <= 3'b0;
        alusrce <= 1'b0;
        jalre <= '0;

        rd1e <= 32'b0;
        rd2e <= 32'b0;
        rs1e <= 5'b0;
        rs2e <= 5'b0;
        pce <= 32'b0;
        rde <= 5'b0;
        immexte <= 32'b0;
        pcplus4e <= 32'b0; 
    end
    else begin
        regwritee <= regwrited;
        resultsrce <= resultsrcd;
        memwritee <= memwrited;
        jumpe <= jumpd;
        branche <= branchd;
        alucontrole <= alucontrold;
        alusrce <= alusrcd;

        rd1e <= rd1d;
        rd2e <= rd2d;
        rs1e <= rs1d;
        rs2e <= rs2d;
        pce <= pcd;
        rde <= rdd;
        jalre <= jalrd;
        immexte <= immextd;
        pcplus4e <= pcplus4d;
    end

end

endmodule
