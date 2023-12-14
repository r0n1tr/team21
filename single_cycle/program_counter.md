# Program Counter

The PC was designed as such:
- pc_mux.sv
- pc_reg.sv
- top_pc.sv



Once again omitting our wires and I/O the program counter was designed around the register and input mux and designed the adders within the logic of the pc_mux to optimize simplicity in the top file, shown below: 

```verilog
always_comb begin
    casez ({pcsrc , trigger , rst})
        4'b???1: next_pc = {32{1'b0}};   // if rst     = 1: remain at instruction 0
        4'b??00: next_pc = {32{1'b0}};   // If trigger = 0: remain at instruction 0
        4'b0010: next_pc = pcplus4;      // go to next intruction in memory
        4'b0110: next_pc = pctarget;  // jal, beq (with condition met)
        4'b1010: next_pc = aluresult;    // jalr
        default: next_pc = {32{1'b1}};   // should never execute (if pc ever becomes odd, this may be why)
    endcase
end
```

By adding a trigger signal to our program counter we could control the CPU's ON/OFF state with a click of a button so that in the test bench unless the trigger was high the CPU would not execute the instructions/assembly.

When we were looking to implement the jump instructions, instead of adding another multiplexer to decide if we are jumping we decided it would be more efficient to implement PCSRC in a way where it was a 2-bit signal and increased the inputs into PC mux. This meant we could choose whether we wanted to take the input of the next instruction within the memory(pcplus4 ), the target program(for jump and branch or the address directly from the output of our ALU.

![image](https://github.com/r0n1tr/team21/assets/147700987/87b04ed4-74a7-41d8-a449-4ef101e42f94)