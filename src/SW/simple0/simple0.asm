.data
	a1: 0xAA
	a2: 0x55
	
.text
	addi $t1, $0, 1
	addi $t2, $0, 2
	addi $t3, $0, 3
	addi $t4, $0, 4
	
	slt $t5, $t3, $t4 # if t3 < t4 -> t5 = 1
	
end:
	j end
	