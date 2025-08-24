.eqv PORT_HEX0 0x804     # Define a constant named PORT_HEX0
.eqv PORT_HEX1 0x805
.eqv PORT_HEX2 0x808     	# Define a constant named PORT_HEX2
.eqv PORT_HEX3 0x809
.eqv PORT_HEX4 0x80C		# Define a constant named PORT_HEX4
.eqv PORT_HEX5 0x80D
.data
	A1: .word 0x5
	l1: .word label1
	l2: .word label2
	
.text
	addi $t1, $0, 1
	addi $t2, $0, 2
	addi $t3, $0, 3
	addi $t4, $0, 4
	addi $t5, $t1, 0xA 
	sw $t5, PORT_HEX0
	sw $t5, PORT_HEX1
	sw $t5, PORT_HEX2
	sw $t5, PORT_HEX3
	
	lw $t5, A1
	addi $t2, $t5, 2
	addi $t4, $t5, 4
	addi $t3, $t5, 3
	sw $t2, PORT_HEX1
	sw $t3, PORT_HEX1
	sw $t4, PORT_HEX2
	#move $t4, $t5
	
	
	lw $t6, l1
	lw $t6, l2
	jr $t6
	
	
label1:
	addi $t1, $0, 0x3
	sw $t1, PORT_HEX4
	j end

label2:
	nop
	nop
	addi $t1, $0, 0x3
	sw $t1, PORT_HEX5
	j end
	

end:
	sw $t1, PORT_HEX1
	j end
	
	
