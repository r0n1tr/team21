module demux#(
    parameter   DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] input_data,
    input logic select,

    output logic [DATA_WIDTH-1:0] output0,
    output logic [DATA_WIDTH-1:0] output1
);

always_comb begin
    if (select == 1'b0) begin
        output0 = input_data;
        output1 = 32'b0;
    end
    else begin    
        output0 = 32'b0;
        output1 = input_data;
    end
end

endmodule
