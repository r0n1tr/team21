// verilator lint_off UNUSED
module alu_decoder(
    input logic [6:0] op,   // opcode
    input logic [1:0] aluop,
    input logic [2:0] funct3, 
    input logic [6:0] funct7, 

    output logic [3:0] alucontrol
);

// Interesting observation:
//   aluop, funct3 and funct7[5] are the same for e.g. add and addi. This makes sense since the ALU 
//   has to do the same job in either case. It is the other parts of the CPU that behave differently 
//   (and so have different control signals, as specified in main_decoder.sv)

always_comb begin
    casez ({aluop, funct3, funct7[5]})       
        // -- If executing load, store, jalr, jal, lui, auipc then aluop = 00 -- (this is the default case as this aluop=00 is all zeros, and the main decoder uses zeros as don't cares, so instructions that don't need the alu default to aluop = 00)
        6'b00_???_?: alucontrol = 4'b0000;

        // -- If excuting B-type instruction, then aluop = 01 --
        6'b01_00?_?: alucontrol = 4'b0001;    // beq  or bne  (Setting alucontrol=0001 causes aluresult = rs1-rs2. If this is =0, then (i) zero flag is asserted, and (ii) rs1=rs2.  So zero flag being asserted when executing beq or bne means rs1=rs2.  From there, we can either branch (for beq) or not branch (for bne).
        6'b01_10?_?: alucontrol = 4'b0011;    // blt  or bge  (Setting alucontrol=0011 causes aluresult = rs1<rs2. If this is =0, then (i) zero flag is asserted, and (ii) rs1>=rs2. So zero flag being asserted when executing blt or bge means rs1>=rs2. From there, we can either branch (for beg) or not branch (for blt).
        6'b01_11?_?: alucontrol = 4'b1001;    // bltu or bgeu (Same as above but rs1 and rs2 are treated as unsigned rather than signed)

        // -- If executing I-type (arithmetic/logical ones only) or R-type instructions, then aluop = 10 --
        6'b10_000_0: alucontrol = 4'b0000;    // add             
        6'b10_000_1: alucontrol = (op != 7'b001_0011 ? 4'b0001 : 4'b0000); // sub, addi  --> If we are doing an I-Type arithmetic instruction, then funct7 cannot be used so we default to addi (maybe why there is no sub immediate instruction). Otherwise we must be doing an R-Typr instruction (as aluop=10) so, since funct7[4]=1, we sub 
        6'b10_001_?: alucontrol = 4'b0010;    // shift left logic
        6'b10_010_?: alucontrol = 4'b0011;    // set less than          
        6'b10_011_?: alucontrol = 4'b0100;    // set less than unsigned   
        6'b10_100_?: alucontrol = 4'b0101;    // xor              
        6'b10_101_0: alucontrol = 4'b0110;    // shift right logical       --> even though funct7 doesn't usually exist for I-Type instructions, the shifts only ever use the lower 5 bits (as there's no point shifting more than 2^5=32 bits in a 32bit word), which leaves the upper 7 bits free in the immediate, which are repurposed as funct7. This is *not* the case with e.g. addi, which uses all 12 bits of the immediate, so has no room for funt7, so funct7 cannot be used
        6'b10_101_1: alucontrol = 4'b0111;    // shift right arithmetic             
        6'b10_110_?: alucontrol = 4'b1000;    // or             
        6'b10_111_?: alucontrol = 4'b1001;    // and             

        default:     alucontrol = 4'b1111;    // should never execute
    endcase
end

endmodule
// verilator lint_on UNUSED
