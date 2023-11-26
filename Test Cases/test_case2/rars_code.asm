.text main

main:
	li x30, 268500992
	li x29, 17
	li x28, 9
	li x27,25
	li x26, -1
	sw x29, 0(x30)
	sw x28, 4(x30)
	sw x27, 8(x30)
	sw x26, 12(x30)
	
	# Program starts here
	lw x1, 0(x30)
	lw x2, 4(x30)
	lw x3, 8(x30)
	lw x5, 12(x30)           
	xori x4, x2, 6
	sltu x6, x2, x5
	slt x7, x2, x5
	bltu x3, x5, L1
	add x4, x2, x3
	L1: addi x0, x0, 0
	bne x0, x0, L2
	L2: sltiu x8, x2, 39
	jal x9, L3
	bge x3, x2, L4
	addi x11, x3, 50
	L3:jalr x10, 0(x9)
	blt x0, x1, L4
	addi x0, x0, 0
	L4: 
	L5:
	 auipc x12, 1	
	xor x13, x2, x0
	sltiu x14, x2, -1
	slti x15, x2, -1
	ori x16, x2, 4
	andi x2, x1, 0
	addi x11, x3, 50
	ebreak
	add x2, x2, x3
	addi x0, x0, 0