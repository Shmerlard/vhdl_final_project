.include "io_map_address.asm"

.data
A1:	.word 0xAA
A2: .word 0x55

.text
	lw $t0, A1
	lw $t1, A2
	
L1:	sw $t0, PORT_LEDR
	nop
	nop
	nop
	sw $t1, PORT_LEDR
	j L1