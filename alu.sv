module alu #(
) (
    input logic signed [31:0] ALUop1,
    input logic signed [31:0] ALUop2,
    input logic ALUctrl,
    output logic signed [31:0] ALUout,
    output logic EQ

);

always_comb begin
        if (ALUctrl) begin
            EQ = (ALUop1 == ALUop2); // Check if operands are equal
            ALUout = 0;
            end 
            else begin
            ALUout = ALUop1 + ALUop2;
            EQ = 0;
        end
    end

endmodule
