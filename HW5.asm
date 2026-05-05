	;PART 1
	LD A,(N1)
	LD B, A
	LD A, (N2)
	ADD A, B

	LD B, A
	LD A, (N3)
	ADD A, B

	LD B, A
	LD A, (N4)
	ADD A, B

	LD (SUM1), A

	;PART 2
	LD BC, N1
	LD DE, N2
	LD A, (BC)
	LD B, A
	LD A, (DE)
	ADD A, B
	LD H, A

	LD BC, N3
	LD DE, N4
	LD A, (BC)
	LD B, A
	LD A, (DE)
	ADD A, B

	ADD A, H

	LD (SUM2), A

	;PART 3
	LD A, (N3)
	LD B, A
	LD A, (N4)
	ADD A, B
	LD B, A

	LD A, (N1)
	LD c, A
	LD A, (N2)
	ADD A, C
	LD C, A

	LD A, B
	SUB C

	LD (SUM3), A

          HALT

SUM1	.DB
SUM2	.DB
SUM3	.DB
N1      .DB   04
N2      .DB   08
N3      .DB   12
N4      .DB   16
          .END