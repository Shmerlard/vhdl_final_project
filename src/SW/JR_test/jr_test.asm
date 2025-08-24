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
	addi $t5, $0, 5
		
	lw	$t0, A1
	addi $t1, $t0, 1

label1:
label2:

end:
	j end
