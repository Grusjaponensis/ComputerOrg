.text
    ori $t0, $zero, 0		# ori test
    ori $t0, $zero, 0xabcd
    ori $t1, $t0, 0x1234
    ori $t1, $zero, 12
    ori $t0, $zero, 0xffff

    lui $t0, 0xffff		# lui test
    lui $t1, 17
    lui $zero, 0xa
    
    lui $t0, 0
    ori $t0, $zero, 0x1234
    add $t0, $zero, $t0		# add test
    add $t0, $t0, $t0
    add $zero, $t0, $t0
    
    sub $t0, $t0, $zero		# sub test
    sub $t1, $t0, $t1
    sub $t1, $t1, $t1
    
    lui $t0, 0
    lui $t1, 0
    ori $t0, 12
    ori $t1, 0x1234
    sw $t1, 0($t0)		# sw test
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
    lui $t1, 0
    lw $t1, 0($t0) 		# lw test
    lui $t1, 0
    lw $t1, 4($t0)
    lui $t1, 0
    lw $t1, -4($t0)
    
    previous:
    lui $t0, 0
    lui $t1, 0
    ori $t0, 1
    beq $t0, $t1, jump
    beq $t1, $t1, jump
    
    jump:
    ori $t0, $zero, 0xabcd
    beq $t0, $zero, previous
    beq $zero, $zero, previous