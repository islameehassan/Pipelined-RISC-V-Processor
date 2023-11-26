.text main

main:
	
	addi x10, x0, 8
	   jal x1, Fib
	   ebreak
	
	Fib:
	   slti x5, x10, 2
	   beq x5, zero, recurse
	   jalr zero, 0(x1)
	recurse:
	   addi x2, x2, -16
	   sw x10, 512(x2)
	   sw x1, 516(x2)
	   addi x10, x10, -1
	   jal x1, Fib
	   sw x18, 524(x2)
	   sw x9, 520(x2)
	   addi x9, x10, 0
	   lw x10, 512(x2)
	   addi x10, x10, -2		
	   jal x1, Fib
	   addi x18, x10, 0
	   add x10, x9, x18
	   lw x1, 516(x2)
	   lw x9, 520(x2)
	   lw x18, 524(x2)
	   addi x2, x2, 16
	   jalr zero, 0(x1)