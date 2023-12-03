module lfsr(
    input logic clk,
    input logic rst,
    input logic en,
    output logic[31:1] data_out
);
    logic [31:1] sreg;

    always_ff @ (posedge clk, posedge rst)
        if(rst)
            sreg <= 32'b1;
        else
            if(en) begin
                sreg <= {sreg[31:1], sreg[31] ^ sreg[28]}; // Adjusted for 32 bits
            end

    assign data_out = sreg;
endmodule
