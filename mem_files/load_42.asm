.global _boot
.text

_boot:    
    addi a0, x0, 21  # Initialize a0 to 0
    jal x5, loop     # Jump back to the main loop

loop:
    addi a0, x0, 42  # Initialize a0 to 0
    ret

                    