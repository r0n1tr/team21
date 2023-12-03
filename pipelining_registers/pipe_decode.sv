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

    input logic regwrited,
    input logic [1:0] resultsrcd,
    input logic memwrited,
    input logic jumpd,
    input logic branchd,
    input logic [2:0] alucontrold,
    input logic alusrcd,

    output logic regwritee,
    output logic [1:0] resultsrce,
    output logic memwritee,
    output logic jumpe,
    output logic branche,
    output logic [2:0] alucontrole,
    output logic alusrce,

    output logic [DATA_WIDTH-1:0] rd1e,
    output logic [DATA_WIDTH-1:0] rd2e,
    output logic [ADDRESS_WIDTH-1:0] pce,
    output logic [WRITE_WIDTH-1:0] rde,
    output logic [DATA_WIDTH-1:0] immexte,
    output logic [ADDRESS_WIDTH-1:0] pcplus4e

);

always_ff @ (posedge clk)
    begin
     rd1e <= rd1d;
     rd2e <= rd2d;
     pce <= pcd;
     rde <= rdd;
     immexte <= immextd;
     pcplus4e <= pcplus4d; 

    end

endmodule
