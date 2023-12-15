module alu #(
    parameter DATA_WIDTH = 32  
)(
    input  logic signed [DATA_WIDTH-1:0] aluop1,
    input  logic signed [DATA_WIDTH-1:0] aluop2,
    input  logic        [3:0]            alucontrol,
    
    output logic signed [DATA_WIDTH-1:0] aluresult,
    output logic                         zero
);

always_comb begin
    case(alucontrol)
        4'b0000: aluresult = aluop1  +  aluop2;       // add             
        4'b0001: aluresult = aluop1  -  aluop2;       // sub             
        4'b0010: aluresult = aluop1 <<  aluop2[4:0];  // shift left logic
        4'b0101: aluresult = aluop1  ^  aluop2;       // xor              
        4'b0110: aluresult = aluop1 >>  aluop2[4:0];  // shift right logical             
        4'b0111: aluresult = aluop1 >>> aluop2[4:0];  // shift right arithmetic             
        4'b1000: aluresult = aluop1  |  aluop2;       // or             
        4'b1001: aluresult = aluop1  &  aluop2;       // and  
        
        4'b0011: aluresult = (  $signed(aluop1) <   $signed(aluop2)) ? 32'b1 : 32'b0;   // set less than  
        4'b0100: aluresult = ($unsigned(aluop1) < $unsigned(aluop2)) ? 32'b1 : 32'b0;   // set less than unsigned     
    
        default: aluresult = {32{1'b1}}; // unrecognised alucontrol
    endcase 
    
    zero = (aluresult == 32'b0); // zero flag check
end


endmodule
