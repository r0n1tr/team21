module memory(
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 32
)(

    input logic [ADDRESS_WIDTH-1:0] din,
    input logic [DATA_WIDTH-1:0] wd,
    input logic clk,
    input logic rst,
    input logic we,
    
);

logic [DATA_WIDTH-1:0] cache_out;
logic [DATA_WIDTH-1:0] dm_out;

cache cache(
    .din(din),
    .rd(dm_out),

    .dout(cache_out)
);

data_mem datamem(
    .clk(clk),
    .we(we),
    .wd(wd),
    .a(cache_out),

    .rd(dm_out)


);

endmodule

