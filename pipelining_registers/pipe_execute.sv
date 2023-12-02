module pipe_execute # (
    parameter ADDRESS_WIDTH = 32,
    DATA_WIDTH = 32,
    WRITE_WIDTH = 5;
)(
    input logic clk,
    input logic [DATA_WIDTH-1:0] aluresulte,
    input logic [DATA_WIDTH-1:0] writedatae,
    input logic [WRITE_WIDTH-1:0] rde,
    input logic [DATA_WIDTH-1:0] pcplus4e,
    output logic[DATA_WIDTH-1:0] aluresultm
    output logic [DATA_WIDTH-1:0] writedatam,
    output logic [WRITE_WIDTH-1:0] rdm,
    output logic [DATA_WIDTH-1:0] pcplus4m 
);

    always_ff @(posedge clk) begin
        aluresultm <= aluresulte;
        writedatam <= writedatae;
        rdm <= rde;
        pcplus4m <= pcplus4e;
    end


endmodule
