.global _boot
.text

_boot:    
    addi a0, x0, 21        # Initialize a0 to 0
    jal x5, loadfortytwo   # go to load42 subroutine

loadfortytwo:
    addi a0, x0, 42   # load 42 into a0
    ret               # pseudoinstruction for JALR

                    