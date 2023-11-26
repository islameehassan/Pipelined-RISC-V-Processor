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
	addi x4, x1, 3
	addi x5, x1, -12
	mul x6, x4, x5
	add x6, x6, x6
	slli x7, x6, 24
	sub x8, x0, x7
	mulh x9, x8, x7
	mulhu x10, x8, x7
	mulhsu x11, x7, x7
	sub x12, x0, x5
	div x13, x6, x12
	divu x14, x6, x12
	div x12, x5, x6
	sub x15, x0, x2
	rem x16, x1, x15
	remu x17, x1, x15