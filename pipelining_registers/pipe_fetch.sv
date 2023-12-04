module pipe_fetch #(
    parameter  ADDRESS_WIDTH = 32,
            DATA_WIDTH = 32
              
)(
    input logic                         clk, 
    input logic [DATA_WIDTH-1:0]        rd,   //the data that comes from instruction memory  
    input logic [ADDRESS_WIDTH-1:0]     pcf,
    input logic [ADDRESS_WIDTH-1:0]     pcplus4f,
    input logic en_n,
    input logic clr,

    output logic [DATA_WIDTH-1:0]       instrd,    
    output logic [ADDRESS_WIDTH-1:0]    pcd,
    output logic [ADDRESS_WIDTH-1:0]    pcplus4d

    

);

    always_ff @ (posedge clk)
        begin
        if(clr) begin
            instrd <= 32'b0;
            pcd <= 32'b0;
            pcplus4d <= 32'b0;
        end
        else if(en_n == 1'b0) begin
            instrd <= rd;
            pcd <= pcf;
            pcplus4d <= pcplus4f;
        end
    end

endmodule
