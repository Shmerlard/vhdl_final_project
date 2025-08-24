.eqv PORT_HEX0 0x804     # Define a constant named PORT_HEX0
.eqv PORT_HEX1 0x805
.eqv PORT_HEX2 0x808     	# Define a constant named PORT_HEX2
.eqv PORT_HEX3 0x809

.data
	A1: .word 0xAA
.text
	addi $t1, $0, 1
	addi $t2, $0, 2
	addi $t3, $0, 3
	addi $t4, $0, 4
	addi $t5, $t1, 0 
	sw $t1, PORT_HEX0
	sw $t5, PORT_HEX1
	sw $t5, PORT_HEX2
	sw $t5, PORT_HEX3
	
	
	lw $t5, A1
	addi $t4, $t5, 2
	#move $t4, $t5
	
end:
	j end
	
	