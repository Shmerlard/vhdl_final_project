.data
IV: .word main            # Start of Interrupt Vector Table
	.word 100
	.word 100
	.word 100
	.word 100
	.word KEY1_ISR
	.word KEY2_ISR
	.word KEY3_ISR
	.word 0
	
	a: .word 0x000A

.text
main:

	ori $k0, $k0, 0x01
	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1
	
	lw $t1, a
	sw $t1, 0x840
	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1
	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1
	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1
	
L:	j    L		    				# infinite loop


	
KEY1_ISR:
	j    KEY1_ISR		    				# infinite loop

KEY2_ISR:
	j    KEY2_ISR		    				# infinite loop

KEY3_ISR:
	j    KEY3_ISR		    				# infinite loop

