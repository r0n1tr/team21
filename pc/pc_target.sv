module pc_target #(
    parameter DATA_WIDTH = 32
)(
    input logic signed [DATA_WIDTH-1:0] pce,
    input logic signed [DATA_WIDTH-1:0] immexte,

    output logic signed [DATA_WIDTH-1:0] pctargete
);

assign pctargete = pce + immexte;

endmodule
