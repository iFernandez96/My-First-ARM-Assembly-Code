@ Rotate a 10x10 matrix clockwise 90 degrees.
@ Input: 	R0 = pointer to input buffer.
@		  	R1 = matrix size (must be square matrix)
@			
@ Output: 	R0 = Output Buffer Pointer.

@ Note: As a challenge, I am to do all processing on the input buffer.
@ NOTE: R3 is being used as a on-chip stack for PUSHes and POPs.


	.text
	.global Rotate90b		@make process name visible to C code
	.type Rotate90b, %function

Rotate90b:
	PUSH	{r0 - r12, lr} 	@ Save Previous registers
@							// Start of setup
	CMP		r1, #1			@ Check if the input Cols is lower than 1.
	BLS 	exit			@ If the input matrix size is equal to or lower than 1, then exit.
	MUL		r4, r1, r1		@ R4 is the bottom right of the input buffer.
	MUL		r5, r1, r1		@ R5 is the bottom left of the input buffer.
	SUB		r5, r5, r1		@ Subtracts one entire row to get the beginning of the bottom row.
	ADD		r4, r0, r4		@ Set R4 to the actual location of the bottom right of the buffer
	ADD		r5, r0, r5		@ Set R5 to the actual location of the bottom left of the buffer.
	ADD		r6, r0, r1		@ Set R6 to the actual location of the top right of the buffer.
	SUB		r7, r1, #1		@ Copy over the Cols over to r7 subtracted by one
	MOV		r9, r1, LSR #1	@ This is to go through the entire buffer.
@							//The reason why I subtract by one is because I needed to stop before I hit the end of the number of columns because it was already done.
	MOV		r8, r7
	B 		Cols			@ Start the process of rotating
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ 
@ The reason I start at columns is because I have to decrement the ending length and increment the beginning length.
@
@							---------------------------------->|
@							0,   1,  2,  3,  4,  5,  6,  7,  8,  9,
@								-------------------------->|
@							10, 11, 12, 13, 14, 15, 16, 17, 18, 19
@									------------------>|
@							20, 21, 22, 23, 24, 25, 26, 27, 28, 29
@										---------->|
@							30, 31, 32, 33, 34, 35, 36, 37, 38, 39
@											-->|
@							40, 41, 42, 43, 44, 45, 46, 47, 48, 49
@							50, 51, 52, 53, 54, 55, 56, 57, 58, 59
@							60, 61, 62, 63, 64, 65, 66, 67, 68, 69
@							70, 71, 72, 73, 74, 75, 76, 77, 78, 79
@							80, 81, 82, 83, 84, 85, 86, 87, 88, 89								
@							90, 91, 92, 93, 94, 95, 96, 97, 98, 99
@
@		I have the increment and decrement at the beginning of each row which makes 
@			it difficult unless I start with the columns because I have to ensure that 
@ 			I go through all rows including the top. If I were to start with the Rows, then
@ 			it would increment the counters before running through the top of the buffer.
@		Starting at the columns allows me to go through the entire buffer.
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	
	
	
	
Rows:
	SUBS	r0, r0, r7
	ADC		r0, r0, r1		@ carry must be set!
	ADD		r0, r0, r1
	SUB		r7, r7, #2
	MOV		r8, r7
	ADD		r4, r4, r7
	SUB		r4, r4, r1
	SUB		r4, r4, #1	
	MUL		r11, r7, r1
	SUB		r5, r5, r11
	ADD		r5, r5, #1
	ADD		r6, r6, r11
	SUB		r6, r6, #1
	
	
	
	SUBS	r9, r9, #1
	BEQ		exit
Cols:	

							@START Rotating Loop
	LDRB	r3, [r0],#1		@ Load the contents of r0 into r10 to move it to the very right. 
	LDRB	r12,[r4]		@ Copy the contents of r4 for later. 
	STRB	r3, [r4],#-1	@ Take out the contents of r0 and store it into r4.
	
	LDRB 	r3, [r12]		@ Store the contents of r4 for later.
	LDRB	r12, [r6]			@ Get the contents of r5 for later.
	STRB 	r3, [r6]		@ store the contents of r4 into the location of r5.
	
	LDRB 	r3, [r12]		@ Store the contents of r5 for later.
	LDRB	r12, [r5]		@ Copy the contents of r6 for later.
	STRB	r3, [r5]	@ Store the contents of r5 into the location of r6.
	
	LDRB 	r3, [r12]		@ Store the contents of r6. 
	STRB	r3, [r0, #-1]	@ Store the contents of r6 into the location of r0.
		
	SUB		r6, r6, r1		
	ADD		r5, r5, r1

	SUBS	r8, #1			@ Decrement the counter.
	BNE 	Cols			@ If the counter does not equal zero, keep going through Cols.
	B		Rows

	
	
exit: 
	POP		{r0 - r12, pc}