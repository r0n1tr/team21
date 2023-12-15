.global _boot
.text

_boot:    
    addi a0, x0, 1    # a0 := 1
    jal  x0, _rc      # goto rc
    
_rc:
    beq a0, x0, _boot
    add a0, a0, a0    # add a0 to itself to left shift
    jal x0, _rc       # goto rc
