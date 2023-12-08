.global _boot
.text

/* TODO: THIS IS MISSING SLLI */

_boot:    
    addi t0, x0, 10    /* t0 := 10  */ 
    add  a0, t0, t0    /* a0 := 20   */
    sub  a0, a0, t0    /* a0 := 10   */
    andi a0, t1, 3     /* a0 := 3  */
    or   a0, a0, 255   /* a0 := 255  */
