.text
	addi $t1, $0, 5
	addi $t2, $0, 5
	beq $t1, $t2, L2
L1:
	addi $t3, $0, 4

L2:
	addi $t3, $0, 8

end: j end