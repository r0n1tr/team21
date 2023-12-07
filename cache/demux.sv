module (
    parameter  DATA_WIDTH = 32

)(
    input logic [DATA_WIDTH-1:0] input,
    input logic select,

    output logic [DATA_WIDTH-1:0] output0,
    output logic [DATA_WIDTH-1:0] output1

);

if (select)
    output0 = {DATA_WIDTH{1'b0}};
    output1 = input;
    
else
    output0 = input;
    output1 = {DATA_WIDTH{1'b0}};

endmodule

   