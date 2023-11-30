// verilator lint_off UNUSED
module alu_decoder(
    input logic [6:0] op,     // 7-bit opcode
    input logic [1:0] aluop,
    input logic [2:0] funct3, 
    input logic [6:0] funct7, 

    output logic [2:0] alucontrol
);

// Implementation of control logic (TODO: Implement JAL)
//      Lecture 7 slide 19 indicates that we only need instructions: add, sub, slt, or, and
//      The rest of the instructions (from Lecture 6 Slides 25/26) have been added for posterity
//      but would require alucontrol be 4 bits to actually implement (as there are 10 instructions)

//      aluop, funct3 and funct7[5] are the same for e.g. add and addi. This makes sense since the ALU 
//      has to do the same job in either case. It is the other parts of the CPU that behave differently 
//      (and so have different control signals, as specified in main_decoder.sv)
always_comb begin
    casez ({aluop, funct3, funct7[5]})       
        // This case is executed if instr is lw, sw
        // In this case aluop = 00
        6'b00_???_?: alucontrol = 3'b000;    // add

        // This case is executed if instr is beq 
        // In this case aluop = 01
        6'b01_???_?: alucontrol = 3'b001;    // sub

        // These cases are executed if instr is any arithmetic/logical instruction
        // for all of these cases, aluop = 10
        6'b10_000_0: alucontrol = 3'b000;    // add             
        6'b10_000_1: alucontrol = 3'b001;    // sub             
     // 6'b10_001_?: alucontrol = 3'b000;    // shift left logic
        6'b10_010_?: alucontrol = 3'b101;    // set less than          
     // 6'b10_011_?: alucontrol = 3'b101;    // set less than unsigned   
     // 6'b10_100_?: alucontrol = 3'b011;    // xor              
     // 6'b10_101_0: alucontrol = 3'b010;    // shift right logical             
     // 6'b10_101_1: alucontrol = 3'b010;    // shift right arithmetic             
        6'b10_110_?: alucontrol = 3'b011;    // or             
        6'b10_111_?: alucontrol = 3'b010;    // and             

        default:     alucontrol = 3'b111;
    endcase
end

endmodule
// verilator lint_on UNUSED
