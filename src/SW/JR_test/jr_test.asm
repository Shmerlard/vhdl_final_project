.eqv PORT_HEX0 0x804     # Define a constant named PORT_HEX0
.eqv PORT_HEX1 0x805
.eqv PORT_HEX2 0x808     	# Define a constant named PORT_HEX2
.eqv PORT_HEX3 0x809

.text
	addi $t1, $0, 1
	addi $t2, $0, 2
	addi $t3, $0, 3
	addi $t4, $0, 4
	nop
	addi $t5, $t1, 0 
	sw $t1, PORT_HEX0
	sw $t5, PORT_HEX1
	sw $t5, PORT_HEX2
	sw $t5, PORT_HEX3
end:
	j end
	
	