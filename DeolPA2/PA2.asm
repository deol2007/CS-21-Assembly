;part 1
	SUB A
	LD (SUM1), A
	LD C,8
	LD D,0
	LD HL,array+8
loop1
	LD A,(HL)
	ADD A,D
	LD D,A
	DEC HL
	DEC C
	LD A,C
	CP 0
	JP P,loop1

	LD A, D
	LD (SUM1), A

;part 2
	SUB A
	LD (SUM2), A
	LD C,-5
	LD D,0
	LD HL,array
loop2
	LD A,(HL)
	ADD A,D
	LD D,A
	INC HL

	LD A,C
	CP (HL)
	JP NZ,loop2

	LD A, D
	LD (SUM2), A

	HALT

array .DB 3,6,9,12,-1,18,0,24,-5
SUM1 .DB
SUM2 .DB

	.end
