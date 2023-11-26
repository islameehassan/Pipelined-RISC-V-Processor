.text main

main:
	li x30, 268500992
	li x29, 17
	li x28, 9
	li x27,25
	sw x29, 0(x30)
	sw x28, 4(x30)
	sw x27, 8(x30)
	
	# Program starts here
	lw x1, 0(x30)
	lw x2, 4(x30)
	lw x3, 8(x30)
	bgeu x5, x5, jump
	jump:fence 1,1
	srli x6, x2, 2
	# fence 1,1
	slli x7, x3, 1
	# ecall
	sub x8, x2, x1
	srai x4, x3, 2
	lui x13, 10
	sub x9, x3, x1
	srl x10, x2, x6
	#fence 1,1