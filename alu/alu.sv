module alu #(
    parameter DATA_WIDTH = 32  
)(
    input  logic signed [DATA_WIDTH-1:0] aluop1,
    input  logic signed [DATA_WIDTH-1:0] aluop2,
    input  logic        [2:0]            alucontrol,
    output logic signed [DATA_WIDTH-1:0] aluout,
    output logic                         zero
);

// IF/ELSE Version
/*
always_comb begin
    if(alucontrol == 3'b000)
        aluout = aluop1
 + aluop2; // Add
    else if (alucontrol == 3'b001) begin
        aluout = aluop1
 - aluop2; // Subtract
    end
    else if (alucontrol == 3'b010) begin
        aluout = aluop1
 & aluop2; // Bitwise AND
    end
    else if (alucontrol == 3'b011) begin
        aluout = aluop1
 | aluop2; // Bitwise OR
    end
    else if (alucontrol == 3'b101) begin
        aluout = (aluop1
 < aluop2) ? 32'b1 : 32'b0; // SLT ~ Set Less Than
    end
        
    EQ = ((aluop1 == aluop2) ? 1 : 0); // EQ Flag check
end
*/

// CASE Version
always_comb begin
    case(alucontrol)
        3'b000: aluout = aluop1
 + aluop2; // Add
        3'b001: aluout = aluop1
 - aluop2; // Subtract
        3'b010: aluout = aluop1
 & aluop2; // Bitwise AND
        3'b011: aluout = aluop1
 | aluop2; // Bitwise OR
        3'b101: aluout = (aluop1
 < aluop2) ? 32'b1 : 32'b0; // SLT ~ Set Less Than
        default: aluout = 32'b0;
    endcase 
    
    zero = (aluout == 0); // zero flag check
end


endmodule
