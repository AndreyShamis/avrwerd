//=============================================================================
	.include "m8515def.inc"
	.include "macro.inc"
//=============================================================================
	.DSEG		//	OPERATIVKA
	
	//.ORG SRAM_START+4
	//Var1:	.byte	3
	//Var2:	.byte	2
//=============================================================================
	.CSEG
		.equ	Delay	=	3
		RJMP NOP1
		.ORG $001				//	INT0
		RJMP INT_interrupt
NOP1:	
		STACK_INIT
		SEI
NOP2:
		LDS R16,Var1
		LDS R17,Var1+1
		LDS R18,Var1+2
		
		SUBI R16,-1
		SBCI R17,-1
		SBCI R18,-1
		STS Var1,R16
		STS Var1+1,R17
		STS Var1+2,R18

		LDI ZL,low(NOP2)
		LDI ZH,high(NOP2)
		LDI	R17,0
		LDI	R18,1
		LDI	R19,2
 
		PUSH	R17
		PUSH	R18
		POP		R1
		POP		R2

		LDI 	R17,Delay

		RCALL	Wait
		//	EEPROM manipulation	
		LDI ZL,low(data*2)
		LDI ZH,high(data*2)
		LPM R17,Z
		IJMP 
		NOP
		RJMP NOP2
INT_interrupt:
		NOP
		RETI

Wait: 	LDI	R17,Delay
M1:		DEC	R17
		NOP
		BRNE	M1
		RET
//=============================================================================
	.ESEG

data: .db 12,34,45,23
	
