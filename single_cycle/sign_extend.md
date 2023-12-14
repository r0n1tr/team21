# Sign Extend

```verilog
always_comb begin
    case (immsrc)
        3'b000:   immext = { {20{instr[31]}} , instr[31:20] };                                        // I-TYPE; sign extend 12-bit imm
        3'b001:   immext = { {20{instr[31]}} , instr[31:25] , instr[11:7] };                          // S-TYPE; sign extend 12-bit imm
        3'b010:   immext = { {20{instr[31]}} , instr[7]     , instr[30:25] , instr[11:8]  , {1'b0} }; // B-TYPE; sign extend 13-bit imm; immext used as offset to PC (so can be -ve or +ve, so needs to be sign extended)
        3'b011:   immext = { {12{instr[31]}} , instr[19:12] , instr[20]    , instr[30:21] , {1'b0} }; // J-TYPE; sign extend 21-bit imm
        3'b100:   immext = { instr[31:12], {12'b0} };                                                 // U-TYPE; set 20-bit imm as upper 20 bits, and set lower 12 bits to 0
        default:  immext = 32'hdeadbeef;   // should never execute; set imm to 'deadbeef'
    endcase
end
```

Standard combinational block to extend sign extend a 32 bit integer.