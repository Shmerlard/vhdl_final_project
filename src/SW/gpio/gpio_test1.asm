.include "io_map_address.asm"

.data
A1:	.word 0xAA
A2: .word 0x55

.text
	lw $t0, A1
	lw $t1, A2
	addi $t2, $0, 50
	
L1:	addi $t2, $t2, -1
	beqz $t2, end
	sw $t0, PORT_LEDR
	nop
	nop
	nop
	sw $t1, PORT_LEDR
	j L1
	
end:
	nop
	nop
	nop
	j end