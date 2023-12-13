.global _boot
.text

_boot:    
    addi a0, x0, 21          # a0 := 21
    jal  x1, _loadfortytwo   # goto loadfortytwo
    addi a0, x0, 66          # a0 := 66
    jal  ra, _loadfortytwo   # goto loadfortytwo
    jal  ra, _halt           # do nothing forever

_loadfortytwo:
    addi a0, x0, 42   # a0 := 42
    jalr x0, ra, 0    # RET

_halt:   
    addi x0, x0, 0    # nop
    jal  x0, _halt