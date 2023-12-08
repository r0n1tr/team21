.global _boot
.text

_boot:    
    addi a0, x0, 21         # a0 := 21
    jal  ra, loadfortytwo   # goto loadfortytwo
    addi a0, x0, 66         # a0 := 66

loadfortytwo:
    addi a0, x0, 42   # a0 := 42
    ret               # pseudoinstruction for JALR
