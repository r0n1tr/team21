module mux(
    input  logic [31:0] input0,
    input  logic [31:0] input1,
    input  logic        ALUsrc,
    output logic [31:0] out
);

always_comb begin
    if (ALUsrc == 0)
        out = input0;
    else 
        out = input1;
end
    
endmodule
