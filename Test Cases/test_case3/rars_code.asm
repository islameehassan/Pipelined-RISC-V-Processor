.text main

main:
	
	li x30, 268500992
	li x29, 17
	li x28, 9
	li x27,25
	sw x29, 0(x30)
	sw x28, 4(x30)
	sw x27, 8(x30)
	
	lw x1, 0(x30)
	lw x2, 4(x30)
	lw x3, 8(x30)
	or x4, x1, x2
	beq x4, x3, L1
	add x3, x1, x2
	L1:add x5, x3, x2
	sw x5, 12(x30)
	lw x6, 12(x30)
	and x7, x6, x1
	sub x8, x1, x2
	add x0, x1, x2
	add x9, x0, x1
	ebreak