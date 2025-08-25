.data
 	X: .word 0x00000005
 	Y: .word 0x00000015
  
.text
	addi $k0, $0, 1
 	lw $t0, X
 	lw $t1, Y
  
count:
	addi $t0, $t0, 1
	bne $t0, $t1, count

end:
	j end
