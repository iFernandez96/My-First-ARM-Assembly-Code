@ Computing A Factorial in Assembly (Assume that r0 contains the 
@input value)
	PUSH	{r0 - r12, lr} 		@ Save previous registers.
	MOV	r1, r0			@ Set counter equal to the number you 
					@ are trying to apply the factorial 
					@ to.
	CMP 	r0, #100000		@ Check for. overflow.
	BHS	exit			@ If. so, then exit. 
	CMP 	r0, #0 			@ Compare the input to zero.
	BNE 	loop			@ If. the compare statement says that 
					@ the input
					@ is zero, then go into. the factorial 
					@ loop.
	BEQ 	exit 			@ Exit. if. input is zero
loop:					@ Start of the loop.
	SUBS 	r1, r1, #1 		@ Subtract 1 from the counter
	BEQ 	exit			@ Exit. if. the result is equal to zero
	MUL 	r0, r1, r0		@ apply factorial
	BNE 	loop			@ loop. back
					@
exit:					@ Exit. loop.
	POP {r0 - r12, pc}		@ Return. all. registers to their 
					@ default values. 
