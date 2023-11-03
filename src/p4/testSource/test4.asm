.text
    ori $t0, $zero, 1
    ori $t1, $zero, 2

    add $t0, $t0, $t0
    add $t1, $t0, $t1

    sub $t1, $t1, $t0
    sub $t0, $t0, $zero

    jal func
    beq $zero, $zero, branch

    func:
    lui $t0, 0
    lui $t1, 0
    ori $t1, 0x1234
    sw $t1, 4($t0)
    lw $t0, 4($t0)
    jr $ra

    branch:
    ori $t0, $zero, $zero