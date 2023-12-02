module pipe_memory # (
    parameter DATA_WIDTH = 32,
    ADDRESS_WIDTH = 32,
    WRITE_WIDTH = 5
)(
    input logic clk,
    input logic [DATA_WIDTH-1:0] aluresultm,
    input logic [DATA_WIDTH-1:0] readdatam,
    input logic [WRITE_WIDTH-1:0] rdm,
    input logic [DATA_WIDTH-1:0] pcplus4m,
    output logic [DATA_WIDTH-1:0] aluresultw,
    output logic [DATA_WIDTH-1:0] readdataw,
    output logic [WRITE_WIDTH-1:0] rdw,
    output logic [DATA_WIDTH-1:0] pcplus4w

);



    always_ff @(posedge clk) begin
        aluresultw <= aluresultm;
        readdataw <= readdatam;
        rdw <= rdm;
        pcplus4w <= pcplus4m;
    end


endmodule
