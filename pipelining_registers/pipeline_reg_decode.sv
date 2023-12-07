module pipeline_reg_decode #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32          
)(  
    input logic clk,
    input logic en_b,
    input logic clr,

    input logic [DATA_WIDTH-1:0]     instrf,   // instruction output from instruction memory
    input logic [ADDRESS_WIDTH-1:0]  pcf,
    input logic [ADDRESS_WIDTH-1:0]  pcplus4f,

    output logic [DATA_WIDTH-1:0]    instrd,    
    output logic [ADDRESS_WIDTH-1:0] pcd,
    output logic [ADDRESS_WIDTH-1:0] pcplus4d
);

always_ff @ (posedge clk) begin
    if(clr) begin
        instrd   <= 32'b0;
        pcd      <= 32'b0;
        pcplus4d <= 32'b0;
    end
    else if(~en_b) begin
        instrd   <= instrf;
        pcd      <= pcf;
        pcplus4d <= pcplus4f;
    end
end

endmodule
