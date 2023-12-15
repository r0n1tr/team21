.global _boot
.text

# Purpose:         To test instructiom JALR when rd != x0 (like it is in RET)           
# Expected output: The final output should be a0 := PC + 4 = 8 (for the JALR i)         
#                  Should never see 42 or 21 appear in a0, as JALR means we go to _halt 

_boot:
    addi a0, x0, 12    # a0 := 12
    jalr x1, a0, 4     # PC <= (a0 + 4 = 16); x1 <= (PC + 4 = 8)  # (this is the second instruction in memory, so has address 4, so PC is 4 when executing this instruction, so PC + 4 = 8)
    addi a0, x0, 42    # a0 := 42 (should never execute)
    addi a0, x0, 21    # a0 := 21 (should never execute)

_halt:
    add  a0, x0, x1    # a0 := x1 ( = PC + 4 as stored by JALR above)
    jal  x0, _halt     # goto halt (we write PC + 4 for this jal instruction to x0, which is hardwired to 0 so doesn't change anthing, hence the previous instruction continues correctly)
