.global _boot
.text

_boot:
    lui   a0, 0x12345     /* Expected output: a0 := 0x12345000                      */
	auipc a0, 0x16789     /* Expected output: a0 := 0x06789000 + PC = 0x06789004    */
                    