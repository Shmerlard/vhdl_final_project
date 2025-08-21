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
	
	a: .word 0x0010
	b: .word 0xCCCC
	
	d1: .word lb1

.text
main:

	lw $t6, d1
	nop
	nop
	nop
	jr $t6
ret:
	ori $k0, $k0, 0x01
	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1
	
	lw $t0, a
	sw $t0, 0x840
	nop
	sw $t1, b
	
	add $t1, $0, 1
	add $t2, $0, 2
	add $t3, $0, 3
	add $t4, $0, 4
	add $t5, $0, 5
	add $t6, $0, 6
	add $t1, $0, 7
	add $t2, $0, 8
	add $t3, $0, 9
	add $t4, $0, 10
	add $t5, $0, 11
	add $t6, $0, 12

lb1:
	addi $t1, $0, 309
	j ret

	
L:	j    L		    				# infinite loop


	
KEY1_ISR:
	j    KEY1_ISR		    				# infinite loop

KEY2_ISR:
	addi $t7, $t0, 500
	addi $t7, $t0, 542
	jr $k1
	
KEY3_ISR:
	j    KEY3_ISR		    				# infinite loop

