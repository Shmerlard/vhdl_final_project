.include "IO_map_addr.asm"

.data
  
.text
label1:
	lw $t0, PORT_SW
	sw $t0, PORT_LEDR
	j label1
	  
	 