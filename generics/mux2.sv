module mux2#(
    parameter DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0] input0,
    input  logic [DATA_WIDTH-1:0] input1,
    input  logic [DATA_WIDTH-1:0] input2,
    input  logic [1:0]            select,
    
    output logic [DATA_WIDTH-1:0] out
);

always_comb begin
    case (select)
        2'b00: out = input0;
        2'b01: out = input1;
        2'b10: out = input2;
        2'b11: out = 32'b0;
    endcase
end
    
endmodule
