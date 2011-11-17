
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8515L
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8515L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCSR=0x34
	.EQU MCUCR=0x35
	.EQU EMCUCR=0x36
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x49,0x4E,0x54,0x30,0x0,0x50,0x52,0x25
	.DB  0x64,0x2D,0x25,0x64,0x25,0x64,0x25,0x64
	.DB  0x25,0x64,0x0,0x45,0x45,0x43,0x52,0x2D
	.DB  0x25,0x64,0x3A,0x45,0x45,0x41,0x52,0x48
	.DB  0x2D,0x25,0x64,0x0,0x50,0x49,0x4E,0x41
	.DB  0x2D,0x25,0x64,0x3A,0x50,0x49,0x4E,0x42
	.DB  0x2D,0x25,0x64,0x0,0x50,0x49,0x4E,0x43
	.DB  0x2D,0x25,0x64,0x3A,0x50,0x49,0x4E,0x44
	.DB  0x2D,0x25,0x64,0x0,0x55,0x42,0x52,0x52
	.DB  0x48,0x2D,0x25,0x64,0x3A,0x55,0x43,0x53
	.DB  0x52,0x43,0x2D,0x25,0x64,0x0,0x53,0x52
	.DB  0x45,0x47,0x2D,0x25,0x64,0x3A,0x53,0x50
	.DB  0x48,0x2D,0x25,0x64,0x0,0x43,0x52,0x2D
	.DB  0x25,0x64,0x3A,0x43,0x53,0x52,0x2D,0x25
	.DB  0x64,0x0,0x53,0x50,0x48,0x2D,0x25,0x64
	.DB  0x3A,0x53,0x50,0x4C,0x2D,0x25,0x64,0x0
	.DB  0x47,0x49,0x43,0x52,0x2D,0x25,0x64,0x3A
	.DB  0x47,0x49,0x46,0x52,0x2D,0x25,0x64,0x0
	.DB  0x41,0x43,0x53,0x52,0x25,0x64,0x3A,0x4F
	.DB  0x53,0x41,0x4C,0x25,0x64,0x0,0x48,0x65
	.DB  0x6C,0x6C,0x6F,0x20,0x41,0x6C,0x65,0x78
	.DB  0x65,0x79,0x0,0x43,0x6F,0x6D,0x6D,0x20
	.DB  0x25,0x64,0x0,0x4C,0x43,0x44,0x0
_0x200005F:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G100
	.DW  _0x200005F*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30
	OUT  EMCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x25F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x25F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0xE0)
	LDI  R29,HIGH(0xE0)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0

	.CSEG
;/*****************************************************
;Chip type               : ATmega8515L
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*****************************************************/
;
;
;#define DEL_START           15*8  //  delay leds start
;#define DEL_CYCLE           15*8  //  delay in each cycle
;#define MAX_COMMAND_SIZE    6   //  Max command size
;#define BUFF_SIZE           17
;//  Button section
;#define btn1 PINC.1
;#define btn2 PINC.3
;#define btn3 PINC.5
;#define btn4 PINC.4
;
;#define wUSBOUT PORTB.0
;#define wUSBIN PINB.1
;//  Led section
;#define led1 PORTC.0
;#define led2 PORTC.2
;#define led3 PORTC.6
;#define led4 PORTC.7
;//-----------------------------------------------------------------------------
;#include <mega8515.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <string.h>
;#include <delay.h>
;#include <stdio.h>
;//#include "usbdrv/usbdrv.h"
;//#include <avr/interrupt.h>
;
;#ifndef F_CPU
;/* Your CPU clock */
;#define F_CPU 16000000
;#endif
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x1B ;PORTA
; 0000 002C #endasm
;
;#include <lcd.h>
;
;
;
;//-----------------------------------------------------------------------------
;//-----------------------------------------------------------------------------
;//  Function For disable all leds on PORTC
;void DisableLeds()
; 0000 0036 {

	.CSEG
_DisableLeds:
; 0000 0037     led1 =0;
	CBI  0x15,0
; 0000 0038     led2 =1;
	SBI  0x15,2
; 0000 0039     led3 =1;
	SBI  0x15,6
; 0000 003A     led4 =1;
	SBI  0x15,7
; 0000 003B    // PORTC=0x1C;
; 0000 003C }
	RET
;
;
;interrupt [EXT_INT0] void ext_int0_isr(void){
; 0000 003F interrupt [2] void ext_int0_isr(void){
_ext_int0_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0040 
; 0000 0041     char buff[BUFF_SIZE];
; 0000 0042     #asm("cli");
	SBIW R28,17
;	buff -> Y+0
	cli
; 0000 0043     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
; 0000 0044     memset(buff,0,BUFF_SIZE);
	RCALL SUBOPT_0x2
; 0000 0045     sprintf(buff,"INT0");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x3
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
; 0000 0046     lcd_puts(buff);
	RCALL SUBOPT_0x4
; 0000 0047     lcd_gotoxy(0,1);
	RCALL SUBOPT_0x0
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL SUBOPT_0x1
; 0000 0048      memset(buff,0,BUFF_SIZE);
	RCALL SUBOPT_0x2
; 0000 0049     memset(buff,0,BUFF_SIZE);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x2
; 0000 004A     sprintf(buff,"PR%d-%d%d%d%d",PINB,wUSBIN,PINB.2,PINB.3,PINB.4);
	__POINTW1FN _0x0,5
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
	LDI  R30,0
	SBIC 0x16,1
	LDI  R30,1
	RCALL SUBOPT_0x6
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	RCALL SUBOPT_0x6
	LDI  R30,0
	SBIC 0x16,3
	LDI  R30,1
	RCALL SUBOPT_0x6
	LDI  R30,0
	SBIC 0x16,4
	LDI  R30,1
	RCALL SUBOPT_0x6
	LDI  R24,20
	RCALL _sprintf
	ADIW R28,24
; 0000 004B 
; 0000 004C     lcd_puts(buff);
	RCALL SUBOPT_0x4
; 0000 004D     led1 =1;
	SBI  0x15,0
; 0000 004E     delay_ms(DEL_START);
	RCALL SUBOPT_0x7
; 0000 004F     DisableLeds();
; 0000 0050 
; 0000 0051     led2 =0;
	CBI  0x15,2
; 0000 0052     delay_ms(DEL_START);
	RCALL SUBOPT_0x7
; 0000 0053     DisableLeds();
; 0000 0054 
; 0000 0055     led3 =0;
	CBI  0x15,6
; 0000 0056     delay_ms(DEL_START);
	RCALL SUBOPT_0x7
; 0000 0057     DisableLeds();
; 0000 0058 
; 0000 0059     led4 =0;
	CBI  0x15,7
; 0000 005A     delay_ms(DEL_START);
	RCALL SUBOPT_0x7
; 0000 005B     DisableLeds();
; 0000 005C     delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x8
; 0000 005D 
; 0000 005E 
; 0000 005F }
	ADIW R28,17
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;//-----------------------------------------------------------------------------
;//-----------------------------------------------------------------------------
;//  Function For
;void DoCommand(unsigned int comm)
; 0000 0064 {
_DoCommand:
; 0000 0065     char buff[BUFF_SIZE];
; 0000 0066     lcd_gotoxy(0,1);
	SBIW R28,17
;	comm -> Y+17
;	buff -> Y+0
	RCALL SUBOPT_0x0
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL SUBOPT_0x1
; 0000 0067     memset(buff,0,BUFF_SIZE);
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RCALL SUBOPT_0x3
	RCALL _memset
; 0000 0068     switch(comm)
	RCALL SUBOPT_0x9
; 0000 0069     {
; 0000 006A         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x16
; 0000 006B                sprintf(buff,"EECR-%d:EEARH-%d",EECR,EEARH);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	IN   R30,0x1F
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 006C                 break;
	RJMP _0x15
; 0000 006D         case 2:
_0x16:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x17
; 0000 006E                  sprintf(buff,"PINA-%d:PINB-%d",PINA,PINB);
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,36
	RCALL SUBOPT_0x3
	IN   R30,0x19
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xC
; 0000 006F                 break;
	RJMP _0x15
; 0000 0070         case 3:
_0x17:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x18
; 0000 0071                sprintf(buff,"PINC-%d:PIND-%d",PINC,PIND);
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,52
	RCALL SUBOPT_0x3
	IN   R30,0x13
	RCALL SUBOPT_0x6
	IN   R30,0x10
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 0072                 break;
	RJMP _0x15
; 0000 0073         case 11:
_0x18:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x19
; 0000 0074                 sprintf(buff,"UBRRH-%d:UCSRC-%d",UBRRH,UCSRC);
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,68
	RCALL SUBOPT_0x3
	IN   R30,0x20
	RCALL SUBOPT_0x6
	IN   R30,0x20
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 0075                 break;
	RJMP _0x15
; 0000 0076         case 12:
_0x19:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1A
; 0000 0077                sprintf(buff,"SREG-%d:SPH-%d",SREG,SPH);
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,86
	RCALL SUBOPT_0x3
	IN   R30,0x3F
	RCALL SUBOPT_0x6
	IN   R30,0x3E
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 0078                 break;
	RJMP _0x15
; 0000 0079 
; 0000 007A         case 13:
_0x1A:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1B
; 0000 007B                sprintf(buff,"EECR-%d:EEARH-%d",EECR,EEARH);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	IN   R30,0x1F
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 007C                 break;
	RJMP _0x15
; 0000 007D         case 21:
_0x1B:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1C
; 0000 007E                 sprintf(buff,"CR-%d:CSR-%d",MCUCR,MCUCSR);
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,101
	RCALL SUBOPT_0x3
	IN   R30,0x35
	RCALL SUBOPT_0x6
	IN   R30,0x34
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 007F                 break;
	RJMP _0x15
; 0000 0080         case 22:
_0x1C:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1D
; 0000 0081                sprintf(buff,"SPH-%d:SPL-%d",SPH,SPL);
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,114
	RCALL SUBOPT_0x3
	IN   R30,0x3E
	RCALL SUBOPT_0x6
	IN   R30,0x3D
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 0082                 break;
	RJMP _0x15
; 0000 0083         case 23:
_0x1D:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1E
; 0000 0084                 sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xD
	IN   R30,0x3A
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 0085                 break;
	RJMP _0x15
; 0000 0086         case 31:
_0x1E:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1F
; 0000 0087                 sprintf(buff,"ACSR%d:OSAL%d",ACSR,OSCCAL);
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,144
	RCALL SUBOPT_0x3
	IN   R30,0x8
	RCALL SUBOPT_0x6
	IN   R30,0x4
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 0088                 break;
	RJMP _0x15
; 0000 0089         case 32:
_0x1F:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x20
; 0000 008A                 sprintf(buff,"Hello Alexey");
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,158
	RCALL SUBOPT_0x3
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
; 0000 008B                 break;
	RJMP _0x15
; 0000 008C         case 33:
_0x20:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x22
; 0000 008D                 sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xD
	IN   R30,0x3A
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xC
; 0000 008E                 break;
	RJMP _0x15
; 0000 008F         default:
_0x22:
; 0000 0090                 sprintf(buff,"Comm %d",comm);
	RCALL SUBOPT_0xA
	__POINTW1FN _0x0,171
	RCALL SUBOPT_0x3
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 0091     }
_0x15:
; 0000 0092     lcd_puts(buff);
	RCALL SUBOPT_0x4
; 0000 0093 
; 0000 0094 }
	ADIW R28,19
	RET
;
;//-----------------------------------------------------------------------------
;//  Main function
;void main(void)
; 0000 0099 {
_main:
; 0000 009A 
; 0000 009B 
; 0000 009C     //char buff[17];
; 0000 009D 
; 0000 009E     char command[MAX_COMMAND_SIZE];
; 0000 009F     short prev_comm=0;
; 0000 00A0     int command_pos = 0;
; 0000 00A1 //    int counter = 0;
; 0000 00A2     int del_size = DEL_CYCLE;
; 0000 00A3     unsigned int wh_c=1;
; 0000 00A4     PORTA=0x00;
	SBIW R28,8
	LDI  R30,LOW(1)
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
;	command -> Y+2
;	prev_comm -> R16,R17
;	command_pos -> R18,R19
;	del_size -> R20,R21
;	wh_c -> Y+0
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,120
	OUT  0x1B,R30
; 0000 00A5     DDRA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 00A6     PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
; 0000 00A7     DDRB=0x01;
	OUT  0x17,R30
; 0000 00A8     DDRC=0xC5;
	LDI  R30,LOW(197)
	OUT  0x14,R30
; 0000 00A9     PORTC=0x01;
	LDI  R30,LOW(1)
	OUT  0x15,R30
; 0000 00AA     //PORTD=0x00;
; 0000 00AB     //DDRD=0x00;
; 0000 00AC     //PORTE=0x00;
; 0000 00AD     //DDRE=0x00;
; 0000 00AE     // Timer/Counter 0 initialization // Clock source: System Clock
; 0000 00AF     // Clock value: Timer 0 Stopped // Mode: Normal top=FFh
; 0000 00B0     // OC0 output: Disconnected
; 0000 00B1     //TCCR0=0x00;
; 0000 00B2     //TCNT0=0x00;
; 0000 00B3     //OCR0=0x00;
; 0000 00B4 
; 0000 00B5     // Timer/Counter 1 initialization   // Clock source: System Clock
; 0000 00B6     // Clock value: Timer1 Stopped      // Mode: Normal top=FFFFh
; 0000 00B7     // OC1A output: Discon.             // OC1B output: Discon.
; 0000 00B8     // Noise Canceler: Off              // Input Capture on Falling Edge
; 0000 00B9     // Timer1 Overflow Interrupt: Off   // Input Capture Interrupt: Off
; 0000 00BA     // Compare A Match Interrupt: Off   // Compare B Match Interrupt: Off
; 0000 00BB     TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00BC     TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00BD     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00BE     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00BF     ICR1H=0x00;
	OUT  0x25,R30
; 0000 00C0     ICR1L=0x00;
	OUT  0x24,R30
; 0000 00C1     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00C2     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00C3     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C4     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C5 
; 0000 00C6 // External Interrupt(s) initialization
; 0000 00C7 // INT0: On
; 0000 00C8 // INT0 Mode: Low level
; 0000 00C9 // INT1: Off
; 0000 00CA // INT2: Off
; 0000 00CB GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00CC MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00CD EMCUCR=0x00;
	OUT  0x36,R30
; 0000 00CE GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00CF 
; 0000 00D0     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D1     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00D2 
; 0000 00D3     // Analog Comparator initialization // Analog Comparator: Off
; 0000 00D4     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00D5     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D6 
; 0000 00D7     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00D8 
; 0000 00D9     // LCD module initialization
; 0000 00DA     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 00DB     lcd_clear();        /* очистка дисплея */
	RCALL _lcd_clear
; 0000 00DC     lcd_gotoxy(7,0);        /* верхняя строка, 4 позиция */
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL SUBOPT_0x0
	RCALL _lcd_gotoxy
; 0000 00DD     lcd_putsf("LCD");/* выводим надпись в указанных координатах */
	__POINTW1FN _0x0,179
	RCALL SUBOPT_0x3
	RCALL _lcd_putsf
; 0000 00DE     DisableLeds();
	RCALL _DisableLeds
; 0000 00DF     delay_ms(DEL_START);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	RCALL SUBOPT_0x8
; 0000 00E0 /*
; 0000 00E1     led1 =1;
; 0000 00E2     delay_ms(DEL_START);
; 0000 00E3     DisableLeds();
; 0000 00E4 
; 0000 00E5     led2 =0;
; 0000 00E6     delay_ms(DEL_START);
; 0000 00E7     DisableLeds();
; 0000 00E8 
; 0000 00E9     led3 =0;
; 0000 00EA     delay_ms(DEL_START);
; 0000 00EB     DisableLeds();
; 0000 00EC 
; 0000 00ED     led4 =0;
; 0000 00EE     delay_ms(DEL_START);
; 0000 00EF     DisableLeds();
; 0000 00F0 */
; 0000 00F1 
; 0000 00F2     while (wh_c < 1000){
_0x23:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLO PC+2
	RJMP _0x25
; 0000 00F3         wh_c++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 00F4         if(wh_c%20==0)  led1    = 1;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL __MODW21U
	SBIW R30,0
	BREQ PC+2
	RJMP _0x26
	SBI  0x15,0
; 0000 00F5         else            led1    = 0;
	RJMP _0x29
_0x26:
	CBI  0x15,0
; 0000 00F6 
; 0000 00F7         if(wh_c > 500){
_0x29:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRSH PC+2
	RJMP _0x2C
; 0000 00F8             lcd_clear();
	RCALL _lcd_clear
; 0000 00F9             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL _lcd_gotoxy
; 0000 00FA             delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x8
; 0000 00FB             wh_c = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00FC         }
; 0000 00FD 
; 0000 00FE         delay_ms(del_size);
_0x2C:
	ST   -Y,R21
	ST   -Y,R20
	RCALL _delay_ms
; 0000 00FF 
; 0000 0100 
; 0000 0101         if(command_pos < MAX_COMMAND_SIZE-1 && ( btn1 == 0 || btn2 == 0 || btn3 == 0)){
	__CPWRN 18,19,5
	BRLT PC+2
	RJMP _0x2E
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE PC+2
	RJMP _0x2F
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE PC+2
	RJMP _0x2F
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE PC+2
	RJMP _0x2F
	RJMP _0x2E
_0x2F:
	RJMP _0x31
_0x2E:
	RJMP _0x2D
_0x31:
; 0000 0102             if(btn1 == 0)
	SBIC 0x13,1
	RJMP _0x32
; 0000 0103                 command[command_pos] = '1';
	RCALL SUBOPT_0xE
	LDI  R30,LOW(49)
	ST   X,R30
; 0000 0104             else if(btn2 == 0)
	RJMP _0x33
_0x32:
	SBIC 0x13,3
	RJMP _0x34
; 0000 0105                 command[command_pos] = '2';
	RCALL SUBOPT_0xE
	LDI  R30,LOW(50)
	ST   X,R30
; 0000 0106             else
	RJMP _0x35
_0x34:
; 0000 0107                 command[command_pos] = '3';
	RCALL SUBOPT_0xE
	LDI  R30,LOW(51)
	ST   X,R30
; 0000 0108             command_pos++;
_0x35:
_0x33:
	__ADDWRN 18,19,1
; 0000 0109             delay_ms(del_size*2);
	RCALL SUBOPT_0xF
; 0000 010A         }
; 0000 010B 
; 0000 010C         if(prev_comm)
_0x2D:
	MOV  R0,R16
	OR   R0,R17
	BRNE PC+2
	RJMP _0x36
; 0000 010D         {
; 0000 010E                 DoCommand(prev_comm);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _DoCommand
; 0000 010F         }
; 0000 0110         if(btn4 == 0){
_0x36:
	SBIC 0x13,4
	RJMP _0x37
; 0000 0111             lcd_clear();
	RCALL _lcd_clear
; 0000 0112             prev_comm=  atoi(command);
	RCALL SUBOPT_0x10
	RCALL _atoi
	MOVW R16,R30
; 0000 0113             DoCommand(prev_comm);
	ST   -Y,R17
	ST   -Y,R16
	RCALL _DoCommand
; 0000 0114             memset(command,0,MAX_COMMAND_SIZE);
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x0
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x3
	RCALL _memset
; 0000 0115             command_pos = 0;
	__GETWRN 18,19,0
; 0000 0116             delay_ms(del_size*2);
	RCALL SUBOPT_0xF
; 0000 0117         }
; 0000 0118 
; 0000 0119         //lcd_clear();
; 0000 011A         lcd_gotoxy(0,0);
_0x37:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL _lcd_gotoxy
; 0000 011B         lcd_puts(command);
	RCALL SUBOPT_0x10
	RCALL _lcd_puts
; 0000 011C         #asm("sei");
	sei
; 0000 011D     }
	RJMP _0x23
_0x25:
; 0000 011E }
	ADIW R28,8
_0x38:
	NOP
	RJMP _0x38

	.CSEG
_atoi:
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
	ST   -Y,R30
	RCALL _isspace
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
	ST   -Y,R30
	RCALL _isdigit
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret

	.DSEG

	.CSEG

	.CSEG
_memset:
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x11
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2040010
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
	MOVW R16,R30
	SBIW R30,0
	BREQ PC+2
	RJMP _0x2040011
	RJMP _0x2040012
_0x2040011:
	__CPWRN 16,17,2
	BRSH PC+2
	RJMP _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	RCALL SUBOPT_0x11
	ADIW R26,2
	RCALL SUBOPT_0x13
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x11
	RCALL __GETW1P
	TST  R31
	BRPL PC+2
	RJMP _0x2040014
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x13
_0x2040014:
_0x2040013:
	RJMP _0x2040015
_0x2040010:
	RCALL SUBOPT_0x11
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G102:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BREQ PC+2
	RJMP _0x204001C
	CPI  R18,37
	BREQ PC+2
	RJMP _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0x14
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BREQ PC+2
	RJMP _0x204001F
	CPI  R18,37
	BREQ PC+2
	RJMP _0x2040020
	RCALL SUBOPT_0x14
	LDI  R17,LOW(0)
	RJMP _0x204001B
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BREQ PC+2
	RJMP _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BREQ PC+2
	RJMP _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BREQ PC+2
	RJMP _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BREQ PC+2
	RJMP _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BREQ PC+2
	RJMP _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRSH PC+2
	RJMP _0x204002A
	CPI  R18,58
	BRLO PC+2
	RJMP _0x204002A
	RJMP _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BREQ PC+2
	RJMP _0x204002F
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x15
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x17
	RJMP _0x2040030
	RJMP _0x2040031
_0x204002F:
	CPI  R30,LOW(0x73)
	BREQ PC+2
	RJMP _0x2040032
_0x2040031:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
	RJMP _0x2040034
_0x2040032:
	CPI  R30,LOW(0x70)
	BREQ PC+2
	RJMP _0x2040035
_0x2040034:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
	RJMP _0x2040037
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ PC+2
	RJMP _0x2040038
_0x2040037:
	RJMP _0x2040039
_0x2040038:
	CPI  R30,LOW(0x69)
	BREQ PC+2
	RJMP _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BREQ PC+2
	RJMP _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	RCALL SUBOPT_0x1B
	LDI  R17,LOW(5)
	RJMP _0x204003D
	RJMP _0x204003E
_0x204003C:
	CPI  R30,LOW(0x58)
	BREQ PC+2
	RJMP _0x204003F
_0x204003E:
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	RCALL SUBOPT_0x1B
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1C
	LDD  R26,Y+11
	TST  R26
	BRMI PC+2
	RJMP _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x1C
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BRNE PC+2
	RJMP _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1C
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRLO PC+2
	RJMP _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	RCALL SUBOPT_0x14
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BRNE PC+2
	RJMP _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x1B
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	RCALL SUBOPT_0x14
	CPI  R21,0
	BRNE PC+2
	RJMP _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x1B
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRSH PC+2
	RJMP _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x1C
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRSH PC+2
	RJMP _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRS R16,4
	RJMP _0x2040060
	RJMP _0x2040061
_0x2040060:
	CPI  R18,49
	BRLO PC+2
	RJMP _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE PC+2
	RJMP _0x2040063
	RJMP _0x2040062
_0x2040063:
	ORI  R16,LOW(16)
	RJMP _0x2040065
_0x2040062:
	CP   R21,R19
	BRSH PC+2
	RJMP _0x2040067
	SBRC R16,0
	RJMP _0x2040067
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
	ORI  R16,LOW(16)
_0x2040065:
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x17
	CPI  R21,0
	BRNE PC+2
	RJMP _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	RCALL SUBOPT_0x14
	CPI  R21,0
	BRNE PC+2
	RJMP _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
_0x2040057:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH PC+2
	RJMP _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BRNE PC+2
	RJMP _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x17
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
	LDI  R17,LOW(0)
_0x204002E:
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x1D
	SBIW R30,0
	BREQ PC+2
	RJMP _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x3
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	RCALL SUBOPT_0x3
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0x3
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G103:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G103:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G103
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G103
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble_G103:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G103
    andi  r30,0xf0
	RET
_lcd_read_byte0_G103:
	RCALL __lcd_delay_G103
	RCALL __lcd_read_nibble_G103
    mov   r26,r30
	RCALL __lcd_read_nibble_G103
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	RCALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x1E
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1E
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x1E
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1E
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R5,R7
	BRSH PC+2
	RJMP _0x2060004
	__lcd_putchar1:
	INC  R4
	RCALL SUBOPT_0x0
	ST   -Y,R4
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2060004:
	INC  R5
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	ADIW R28,1
	RET
_lcd_puts:
	ST   -Y,R17
_0x2060005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060005
_0x2060007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_putsf:
	ST   -Y,R17
_0x2060008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x206000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G103:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G103:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL __long_delay_G103
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x1E
	RCALL __long_delay_G103
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x1E
	RCALL __long_delay_G103
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x1E
	RCALL __long_delay_G103
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G103
	CPI  R30,LOW(0x5)
	BRNE PC+2
	RJMP _0x206000B
	LDI  R30,LOW(0)
	ADIW R28,1
	RET
_0x206000B:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x1E
	RCALL _lcd_clear
	LDI  R30,LOW(1)
	ADIW R28,1
	RET

	.CSEG
_isdigit:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret

	.CSEG

	.DSEG
__seed_G100:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	RCALL _lcd_gotoxy
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _memset
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:56 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	MOVW R30,R28
	RCALL SUBOPT_0x3
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	IN   R30,0x16
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:70 WORDS
SUBOPT_0x6:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	RCALL SUBOPT_0x3
	RCALL _delay_ms
	RJMP _DisableLeds

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	RCALL SUBOPT_0x3
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xA:
	MOVW R30,R28
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	__POINTW1FN _0x0,19
	RCALL SUBOPT_0x3
	IN   R30,0x1C
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xC:
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	__POINTW1FN _0x0,128
	RCALL SUBOPT_0x3
	IN   R30,0x3B
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R18
	ADC  R27,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x14:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x9
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x9
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0x15
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	RCALL __long_delay_G103
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G103


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
