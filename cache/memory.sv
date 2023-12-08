module memory#(
    parameter       ADDRESS_WIDTH = 32,
                    DATA_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic we,
    input logic [DATA_WIDTH-1:0] wd,
    input logic [ADDRESS_WIDTH-1:0] alu_result,
    
    output logic [DATA_WIDTH-1:0] read_data
);

logic hit;
logic [DATA_WIDTH-1:0] a;
logic [DATA_WIDTH-1:0] demux_input;
logic [DATA_WIDTH-1:0] mux_input0;
logic [DATA_WIDTH-1:0] mux_input1;

cache cache_test(
    .din(alu_result),
    .rd(rd),
    .rst(rst),

    .dout(demux_input),
    .hit(hit)
);

demux cache_demux(
    .input_data(demux_input),
    .select(hit),

    .output0(a),
    .output1(mux_input1)
)

data_mem data_memory(
    .a(a),
    .clk(clk),
    .we(we),
    .wd(wd),

    .rd(mux_input0)

);

mux memory_mux(
    .input0(mux_input0),
    .input1(mux_input1),
    .select(hit),

    .out(read_data)
)

endmodule
