.include "io_map_address.asm"
#--------------------------------------------------------------
#							 Data Segment
#--------------------------------------------------------------
.data 
N: .word 0xB71B00		# N=MCLKcycles argument of the delay routine 
btctl_val: .word 0x0040
btccr0_val: .word 500
btccr1_val: .word 300
#--------------------------------------------------------------
#							 Code Segment
#--------------------------------------------------------------
.text
	lw   $t3,btccr0_val
	sw   $t3,BTCCR0
	lw   $t3,btccr1_val
	sw   $t3,BTCCR1
	lw   $t3,btctl_val
	sw   $t3,BTCTL
	
L:  j L
	
	
