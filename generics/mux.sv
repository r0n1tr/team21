module mux#(
    parameter DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0] input0,
    input  logic [DATA_WIDTH-1:0] input1,
    input  logic                  select,
    
    output logic [DATA_WIDTH-1:0] out
);

always_comb begin
    if (select == 0)
        out = input0;
    else 
        out = input1;
end
    
endmodule
