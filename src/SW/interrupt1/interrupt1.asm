.data
	a: .word 23
	b: .word 21
	c: .word 193

.text
	add $t4, $t4, 5
	lw $t1, a
	lw $t2, b
	lw $t3, c

	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1
	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1
	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1
	add $t1, $t1, 1
	add $t2, $t2, 1
	add $t3, $t3, 1

