module mux3#(
    parameter DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0] input0,
    input  logic [DATA_WIDTH-1:0] input1,
    input  logic [DATA_WIDTH-1:0] input2,
    input  logic [DATA_WIDTH-1:0] input3,
    input  logic [DATA_WIDTH-1:0] input4,
    input  logic [DATA_WIDTH-1:0] input5,
    input  logic [DATA_WIDTH-1:0] input6,
    input  logic [DATA_WIDTH-1:0] input7,
    input  logic [2:0]            select,
    
    output logic [DATA_WIDTH-1:0] out
);

always_comb begin
    case (select)
        3'b000: out = input0;
        3'b001: out = input1;
        3'b010: out = input2;
        3'b011: out = input3;
        3'b100: out = input4;
        3'b101: out = input5;
        3'b110: out = input6;
        3'b111: out = input7;
    endcase
end
    
endmodule
