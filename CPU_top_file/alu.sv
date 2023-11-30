module alu #(
    parameter DATA_WIDTH = 32  
)(
    input  logic signed [DATA_WIDTH-1:0] ALUop1,
    input  logic signed [DATA_WIDTH-1:0] ALUop2,
    input  logic [2:0]                   ALUctrl,
    output logic signed [DATA_WIDTH-1:0] ALUout,
    output logic                         EQ
);

// IF/ELSE Version
/*
always_comb begin
    if(ALUctrl == 3'b000)
        ALUout = ALUop1 + ALUop2; // Add
    else if (ALUctrl == 3'b001) begin
        ALUout = ALUop1 - ALUop2; // Subtract
    end
    else if (ALUctrl == 3'b010) begin
        ALUout = ALUop1 & ALUop2; // Bitwise AND
    end
    else if (ALUctrl == 3'b011) begin
        ALUout = ALUop1 | ALUop2; // Bitwise OR
    end
    else if (ALUctrl == 3'b101) begin
        ALUout = (ALUop1 < ALUop2) ? 32'b1 : 32'b0; // SLT ~ Set Less Than
    end
        
    EQ = ((ALUop1 == ALUop2) ? 1 : 0); // EQ Flag check
end
*/

// CASE Version
always_comb begin
    case(ALUctrl)
        3'b000: ALUout = ALUop1 + ALUop2; // Add
        3'b001: ALUout = ALUop1 - ALUop2; // Subtract
        3'b010: ALUout = ALUop1 & ALUop2; // Bitwise AND
        3'b011: ALUout = ALUop1 | ALUop2; // Bitwise OR
        3'b101: ALUout = (ALUop1 < ALUop2) ? 32'b1 : 32'b0; // SLT ~ Set Less Than
        default: ALUout = 32'b0;
    endcase 
    
    EQ = ((ALUop1 == ALUop2) ? 1 : 0); // EQ Flag check
end


endmodule
