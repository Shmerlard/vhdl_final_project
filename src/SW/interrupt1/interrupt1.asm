.data
	a: .word 23
	b: .word 21
	c: .word 193

.text
	lw $t1, a
	lw $t2, b
	lw $t3, c
	
	add $t1, $t2, 1
	add $t1, $t2, 1
	add $t1, $t2, 1
	add $t1, $t2, 1
	add $t1, $t2, 1