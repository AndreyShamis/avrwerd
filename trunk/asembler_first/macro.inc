//=============================================================================
//	Macro wich give you option save nvalues into lowregister
//	from R0 - R15
.MACRO LDIL
	PUSH	R17	; Save the value from register into the STEK
	LDI	R17,@1	; Put to th register our value 
	MOV	@0,R17	; move the value to low register from high register. 
	POP 	R17	; repair from stack the value wich we save 
.ENDM
//=============================================================================
//	Macro for init Stack point
.MACRO STACK_INIT
	LDI R16,Low(RAMEND)	
	OUT SPL,R16

	LDI R16,High(RAMEND)
	OUT SPH,R16
.ENDM

//=============================================================================
.MACRO    UOUT        
   	.if	@0 < 0x40
      	OUT	@0,@1         
	.else
      	STS	@0,@1
   	.endif
.ENDM
