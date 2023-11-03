.text
    ori $t0, $zero, 0xabcd
    ori $t1, $zero, 0x1234

    beq $t0, $t1, func
    jal func1
    beq $zero, $zero, func
    func:
    jal func1
    func1:
    jr $ra