.text
    jal func2
    
    func1:
    jr $ra
    
    func2:
    jal	func				# jump to func and save position to $ra
    jal func1
    jr	$ra					# jump to $ra
    
    func:
    jr	$ra					# jump to $ra
    
    