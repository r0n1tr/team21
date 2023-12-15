.global _boot
.text

/*    Program purpose is to test lui, lw  */
/*    Expected output is a0:=87654321  */

_boot:
    lui  a1, 0x87654
    addi a1, a1, 0x321
    sw   a1, 0(x0)
    lw   a0, 0(x0)

