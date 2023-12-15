module alu #(
    parameter DATA_WIDTH = 32  
)(
    input  logic signed [DATA_WIDTH-1:0] ALUop1,
    input  logic signed [DATA_WIDTH-1:0] ALUop2,
    input  logic                         ALUctrl,
    output logic signed [DATA_WIDTH-1:0] ALUout,
    output logic                         EQ
);

assign EQ = ((ALUop1 == ALUop2) ? 1:0); // Check if operands are equal
assign ALUout = ALUop1 + ALUop2;

endmodule
