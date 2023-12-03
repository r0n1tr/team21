module pc_target #(
    parameter DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] pce,
    input logic [DATA_WIDTH-1:0] immexte,

    output logic [DATA_WIDTH-1:0] pctargete
);

assign pctargete = pce + immexte;

endmodule
