
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	.EQU MCUCR=0x35
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _keyState=R5
	.DEF _keyCode=R4
	.DEF _keyDown=R7
	.DEF _buf=R6

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_keyTable:
	.DB  0xEE,0x31,0xED,0x32,0xEB,0x33,0xE7,0x41
	.DB  0xDE,0x34,0xDD,0x35,0xDB,0x36,0xD7,0x42
	.DB  0xBE,0x37,0xBD,0x38,0xBB,0x39,0xB7,0x43
	.DB  0x7E,0x2A,0x7D,0x30,0x7B,0x23,0x77,0x44

_0x20:
	.DB  0x0
_0x40009:
	.DB  0x0
_0x40000:
	.DB  0x43,0x56,0x20,0x4B,0x65,0x79,0x3A,0x20
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x05
	.DW  _0x20*2

	.DW  0x09
	.DW  _0x40003
	.DW  _0x40000*2

	.DW  0x01
	.DW  0x06
	.DW  _0x40009*2

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
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
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;//*****************************************************************************
;//
;//  Author(s)...: Pashgan    http://ChipEnable.Ru
;//
;//  Target(s)...: любой
;//
;//  Compiler....: любой
;//
;//  Description.: Универсальный драйвер матричной клавиатуры
;//
;//  Data........: 12.10.2011
;//
;//******************************************************************************
;#include "keyboard.h"
;
;
;//раздел для совместимости с компиляторами**************************************
;//менять здесь ничего не надо
;
;#ifdef  __ICCAVR__
;  #include <ioavr.h>
;  #include <intrinsics.h>
;
;  #define _delay_us(value)  __delay_cycles((F_CPU / 1000000) * (value));
;  #define FLASH_ATR         __flash
;  #define read_flash(adr)   adr
;#endif
;
;#ifdef  __GNUC__
;  #include <avr/io.h>
;  #include <util/delay.h>
;  #include <avr/interrupt.h>
;  #include <avr/pgmspace.h>
;
;  #define FLASH_ATR         PROGMEM
;  #define read_flash(adr)   pgm_read_byte(&(adr))
;#endif
;
;#ifdef __CODEVISIONAVR__
;  #include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;  #include <delay.h>
;
;  #define _delay_us(value) delay_us(value)
;  #define FLASH_ATR         __flash
;  #define read_flash(adr)   adr
;#endif
;//******************************************************************************
;
;
;
;
;#ifdef KEYBOARD_4X4
;   #warning "Keyboard 4x4"
;
;   #define KEYS 16
;   #define SCAN_CYCLES 4
;   #define ROW_MASK ((1<<PIN_ROW1)|(1<<PIN_ROW2)|(1<<PIN_ROW3)|(1<<PIN_ROW4))
;   #define COL_MASK ((1<<PIN_COL1)|(1<<PIN_COL2)|(1<<PIN_COL3)|(1<<PIN_COL4))
;
;  //таблица перекодировки
;  FLASH_ATR unsigned char keyTable[][2] = {
;  {((~(1<<PIN_ROW1)&(ROW_MASK))|(~(1<<PIN_COL1)&(COL_MASK))), EVENT_KEY1},
;  {((~(1<<PIN_ROW1)&(ROW_MASK))|(~(1<<PIN_COL2)&(COL_MASK))), EVENT_KEY2},
;  {((~(1<<PIN_ROW1)&(ROW_MASK))|(~(1<<PIN_COL3)&(COL_MASK))), EVENT_KEY3},
;  {((~(1<<PIN_ROW1)&(ROW_MASK))|(~(1<<PIN_COL4)&(COL_MASK))), EVENT_KEYA},
;
;  {((~(1<<PIN_ROW2)&(ROW_MASK))|(~(1<<PIN_COL1)&(COL_MASK))), EVENT_KEY4},
;  {((~(1<<PIN_ROW2)&(ROW_MASK))|(~(1<<PIN_COL2)&(COL_MASK))), EVENT_KEY5},
;  {((~(1<<PIN_ROW2)&(ROW_MASK))|(~(1<<PIN_COL3)&(COL_MASK))), EVENT_KEY6},
;  {((~(1<<PIN_ROW2)&(ROW_MASK))|(~(1<<PIN_COL4)&(COL_MASK))), EVENT_KEYB},
;
;  {((~(1<<PIN_ROW3)&(ROW_MASK))|(~(1<<PIN_COL1)&(COL_MASK))), EVENT_KEY7},
;  {((~(1<<PIN_ROW3)&(ROW_MASK))|(~(1<<PIN_COL2)&(COL_MASK))), EVENT_KEY8},
;  {((~(1<<PIN_ROW3)&(ROW_MASK))|(~(1<<PIN_COL3)&(COL_MASK))), EVENT_KEY9},
;  {((~(1<<PIN_ROW3)&(ROW_MASK))|(~(1<<PIN_COL4)&(COL_MASK))), EVENT_KEYC},
;
;  {((~(1<<PIN_ROW4)&(ROW_MASK))|(~(1<<PIN_COL1)&(COL_MASK))), EVENT_KEYZ},
;  {((~(1<<PIN_ROW4)&(ROW_MASK))|(~(1<<PIN_COL2)&(COL_MASK))), EVENT_KEY0},
;  {((~(1<<PIN_ROW4)&(ROW_MASK))|(~(1<<PIN_COL3)&(COL_MASK))), EVENT_KEYR},
;  {((~(1<<PIN_ROW4)&(ROW_MASK))|(~(1<<PIN_COL4)&(COL_MASK))), EVENT_KEYD}
;  };
;
;#else
;  #warning "Keyboard3x4"
;
;  #define KEYS 12
;  #define SCAN_CYCLES 3
;  #define ROW_MASK ((1<<PIN_ROW1)|(1<<PIN_ROW2)|(1<<PIN_ROW3)|(1<<PIN_ROW4))
;  #define COL_MASK ((1<<PIN_COL1)|(1<<PIN_COL2)|(1<<PIN_COL3))
;
;  //таблица перекодировки
;  FLASH_ATR unsigned char keyTable[][2] = {
;  {((~(1<<PIN_ROW1)&(ROW_MASK))|(~(1<<PIN_COL1)&(COL_MASK))), EVENT_KEY1},
;  {((~(1<<PIN_ROW1)&(ROW_MASK))|(~(1<<PIN_COL2)&(COL_MASK))), EVENT_KEY2},
;  {((~(1<<PIN_ROW1)&(ROW_MASK))|(~(1<<PIN_COL3)&(COL_MASK))), EVENT_KEY3},
;
;  {((~(1<<PIN_ROW2)&(ROW_MASK))|(~(1<<PIN_COL1)&(COL_MASK))), EVENT_KEY4},
;  {((~(1<<PIN_ROW2)&(ROW_MASK))|(~(1<<PIN_COL2)&(COL_MASK))), EVENT_KEY5},
;  {((~(1<<PIN_ROW2)&(ROW_MASK))|(~(1<<PIN_COL3)&(COL_MASK))), EVENT_KEY6},
;
;  {((~(1<<PIN_ROW3)&(ROW_MASK))|(~(1<<PIN_COL1)&(COL_MASK))), EVENT_KEY7},
;  {((~(1<<PIN_ROW3)&(ROW_MASK))|(~(1<<PIN_COL2)&(COL_MASK))), EVENT_KEY8},
;  {((~(1<<PIN_ROW3)&(ROW_MASK))|(~(1<<PIN_COL3)&(COL_MASK))), EVENT_KEY9},
;
;  {((~(1<<PIN_ROW4)&(ROW_MASK))|(~(1<<PIN_COL1)&(COL_MASK))), EVENT_KEYZ},
;  {((~(1<<PIN_ROW4)&(ROW_MASK))|(~(1<<PIN_COL2)&(COL_MASK))), EVENT_KEY0},
;  {((~(1<<PIN_ROW4)&(ROW_MASK))|(~(1<<PIN_COL3)&(COL_MASK))), EVENT_KEYR}
;  };
;
;#endif
;
;
;#define DELAY 5
;
;//состояние автомата
;unsigned char keyState = 0;
;//код кнопки
;unsigned char keyCode;
;//символьный код кнопки
;volatile unsigned char keyValue;
;//флаг - кнопка нажата и удерживается
;unsigned char keyDown;
;//флаг - нажата новая кнопка
;volatile unsigned char keyNew;
;
;unsigned char KEYB_AnyKey(void);
;unsigned char KEYB_SameKey(void);
;void KEYB_ScanKey(void);
;void KEYB_FindKey(void);
;void KEYB_ClearKey(void);
;
;//инициализация портов,
;//обнуление переменных
;void KEYB_Init(void)
; 0000 0087 {

	.CSEG
_KEYB_Init:
; 0000 0088 #ifndef COMMON_BUS
; 0000 0089   //вход, подтяжка
; 0000 008A   DDRX_ROW &= ~ROW_MASK;
; 0000 008B   PORTX_ROW |= ROW_MASK;
; 0000 008C   //выход, ноль
; 0000 008D   DDRX_COL |= COL_MASK;
; 0000 008E   PORTX_COL &= ~COL_MASK;
; 0000 008F #endif //COMMON_BUS
; 0000 0090 
; 0000 0091   keyState = 0;
	CLR  R5
; 0000 0092   keyCode = 0;
	CLR  R4
; 0000 0093   keyValue = 0;
	LDI  R30,LOW(0)
	STS  _keyValue,R30
; 0000 0094   keyDown = 0;
	CLR  R7
; 0000 0095   keyNew = 0;
	STS  _keyNew,R30
; 0000 0096 }
	RET
;
;
;void KEYB_ScanKeyboard(void)
; 0000 009A {
_KEYB_ScanKeyboard:
; 0000 009B #ifdef COMMON_BUS
; 0000 009C   unsigned char buf[4];
; 0000 009D   buf[0] = DDRX_COL;
	SBIW R28,4
;	buf -> Y+0
	IN   R30,0x17
	ST   Y,R30
; 0000 009E   buf[1] = PORTX_COL;
	IN   R30,0x18
	STD  Y+1,R30
; 0000 009F   buf[2] = DDRX_ROW;
	IN   R30,0x1A
	STD  Y+2,R30
; 0000 00A0   buf[3] = PORTX_ROW;
	IN   R30,0x1B
	STD  Y+3,R30
; 0000 00A1 
; 0000 00A2   //вход, подтяжка
; 0000 00A3   DDRX_ROW &= ~ROW_MASK;
	IN   R30,0x1A
	ANDI R30,LOW(0xF)
	OUT  0x1A,R30
; 0000 00A4   PORTX_ROW |= ROW_MASK;
	IN   R30,0x1B
	ORI  R30,LOW(0xF0)
	OUT  0x1B,R30
; 0000 00A5 
; 0000 00A6   //выход, ноль
; 0000 00A7   DDRX_COL |= COL_MASK;
	IN   R30,0x17
	ORI  R30,LOW(0xF)
	OUT  0x17,R30
; 0000 00A8   PORTX_COL &= ~COL_MASK;
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	OUT  0x18,R30
; 0000 00A9 #endif //COMMON_BUS
; 0000 00AA 
; 0000 00AB   switch (keyState){
	MOV  R30,R5
; 0000 00AC      case 0: {
	CPI  R30,0
	BRNE _0x6
; 0000 00AD        if (KEYB_AnyKey()) {
	RCALL _KEYB_AnyKey
	CPI  R30,0
	BREQ _0x7
; 0000 00AE          KEYB_ScanKey();
	RCALL _KEYB_ScanKey
; 0000 00AF          keyState = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 00B0        }
; 0000 00B1      }
_0x7:
; 0000 00B2      break;
	RJMP _0x5
; 0000 00B3 
; 0000 00B4      case 1: {
_0x6:
	CPI  R30,LOW(0x1)
	BRNE _0x8
; 0000 00B5        if (KEYB_SameKey()) {
	RCALL _KEYB_SameKey
	CPI  R30,0
	BREQ _0x9
; 0000 00B6          KEYB_FindKey();
	RCALL _KEYB_FindKey
; 0000 00B7          keyState = 2;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 00B8        }
; 0000 00B9        else keyState = 0;
	RJMP _0xA
_0x9:
	CLR  R5
; 0000 00BA      }
_0xA:
; 0000 00BB      break;
	RJMP _0x5
; 0000 00BC 
; 0000 00BD      case 2: {
_0x8:
	CPI  R30,LOW(0x2)
	BRNE _0xB
; 0000 00BE        if (KEYB_SameKey()) {}
	RCALL _KEYB_SameKey
	CPI  R30,0
	BRNE _0xD
; 0000 00BF        else keyState = 3;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 00C0      }
_0xD:
; 0000 00C1      break;
	RJMP _0x5
; 0000 00C2 
; 0000 00C3      case 3: {
_0xB:
	CPI  R30,LOW(0x3)
	BRNE _0x11
; 0000 00C4        if (KEYB_SameKey()) {
	RCALL _KEYB_SameKey
	CPI  R30,0
	BREQ _0xF
; 0000 00C5          keyState = 2;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 00C6        }
; 0000 00C7        else {
	RJMP _0x10
_0xF:
; 0000 00C8          KEYB_ClearKey();
	RCALL _KEYB_ClearKey
; 0000 00C9          keyState = 0;
	CLR  R5
; 0000 00CA        }
_0x10:
; 0000 00CB      }
; 0000 00CC      break;
; 0000 00CD 
; 0000 00CE      default:
_0x11:
; 0000 00CF        break;
; 0000 00D0    }
_0x5:
; 0000 00D1 
; 0000 00D2 #ifdef COMMON_BUS
; 0000 00D3   DDRX_COL = buf[0];
	LD   R30,Y
	OUT  0x17,R30
; 0000 00D4   PORTX_COL = buf[1];
	LDD  R30,Y+1
	OUT  0x18,R30
; 0000 00D5   DDRX_ROW = buf[2];
	LDD  R30,Y+2
	OUT  0x1A,R30
; 0000 00D6   PORTX_ROW = buf[3];
	LDD  R30,Y+3
	OUT  0x1B,R30
; 0000 00D7 #endif //COMMON_BUS
; 0000 00D8 }
	ADIW R28,4
	RET
;
;
;//возвращает true если какая нибудь кнопка нажата
;unsigned char KEYB_AnyKey(void)
; 0000 00DD {
_KEYB_AnyKey:
; 0000 00DE   PORTX_COL &= ~COL_MASK;
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	OUT  0x18,R30
; 0000 00DF   _delay_us(DELAY);
	CALL SUBOPT_0x0
; 0000 00E0   return (~PINX_ROW & ROW_MASK);
	RET
; 0000 00E1 }
;
;//возвращает true, если удерживается та же кнопка,
;//что и в предыдущем цикле опроса
;unsigned char KEYB_SameKey(void)
; 0000 00E6 {
_KEYB_SameKey:
; 0000 00E7   PORTX_COL &= ~COL_MASK;
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	OUT  0x18,R30
; 0000 00E8   PORTX_COL |= (keyCode & COL_MASK);
	IN   R30,0x18
	MOV  R26,R30
	MOV  R30,R4
	ANDI R30,LOW(0xF)
	OR   R30,R26
	OUT  0x18,R30
; 0000 00E9   return ((~keyCode & ROW_MASK)&(~PINX_ROW));
	MOV  R30,R4
	COM  R30
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	IN   R30,0x19
	COM  R30
	AND  R30,R26
	RET
; 0000 00EA }
;
;
;//сканирует клавиатуру
;void KEYB_ScanKey(void)
; 0000 00EF {
_KEYB_ScanKey:
; 0000 00F0     unsigned char i;
; 0000 00F1     for(i = 0; i<SCAN_CYCLES; i++){
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,4
	BRSH _0x14
; 0000 00F2        PORTX_COL |= COL_MASK;
	IN   R30,0x18
	ORI  R30,LOW(0xF)
	OUT  0x18,R30
; 0000 00F3        if (i == 0) PORTX_COL &= ~(1<<PIN_COL1);
	CPI  R17,0
	BRNE _0x15
	CBI  0x18,0
; 0000 00F4        if (i == 1) PORTX_COL &= ~(1<<PIN_COL2);
_0x15:
	CPI  R17,1
	BRNE _0x16
	CBI  0x18,1
; 0000 00F5        if (i == 2) PORTX_COL &= ~(1<<PIN_COL3);
_0x16:
	CPI  R17,2
	BRNE _0x17
	CBI  0x18,2
; 0000 00F6        #ifdef KEYBOARD_4X4
; 0000 00F7        if (i == 3) PORTX_COL &= ~(1<<PIN_COL4);
_0x17:
	CPI  R17,3
	BRNE _0x18
	CBI  0x18,3
; 0000 00F8        #endif
; 0000 00F9        _delay_us(DELAY);
_0x18:
	CALL SUBOPT_0x0
; 0000 00FA        if (~PINX_ROW & ROW_MASK) {
	BREQ _0x19
; 0000 00FB          keyCode = PINX_ROW & ROW_MASK;
	IN   R30,0x19
	ANDI R30,LOW(0xF0)
	MOV  R4,R30
; 0000 00FC          keyCode |= PORTX_COL & COL_MASK;
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OR   R4,R30
; 0000 00FD          return;
	RJMP _0x2000004
; 0000 00FE        }
; 0000 00FF     }
_0x19:
	SUBI R17,-1
	RJMP _0x13
_0x14:
; 0000 0100 }
	RJMP _0x2000004
;
;
;
;//ищет символьный код кнопки по таблице
;//обновляет значения флагов
;void KEYB_FindKey(void)
; 0000 0107 {
_KEYB_FindKey:
; 0000 0108   unsigned char index;
; 0000 0109   for (index = 0; index < KEYS; index++) {
	ST   -Y,R17
;	index -> R17
	LDI  R17,LOW(0)
_0x1B:
	CPI  R17,16
	BRSH _0x1C
; 0000 010A     if (read_flash(keyTable [index][0]) == keyCode) {
	CALL SUBOPT_0x1
	LPM  R26,Z
	CP   R4,R26
	BRNE _0x1D
; 0000 010B       keyValue = read_flash(keyTable [index][1]);
	CALL SUBOPT_0x1
	ADIW R30,1
	LPM  R0,Z
	STS  _keyValue,R0
; 0000 010C       keyDown = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 010D       keyNew = 1;
	STS  _keyNew,R30
; 0000 010E       return;
	RJMP _0x2000004
; 0000 010F     }
; 0000 0110   }
_0x1D:
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
; 0000 0111 }
_0x2000004:
	LD   R17,Y+
	RET
;
;//сбрасывает флаг
;void KEYB_ClearKey(void)
; 0000 0115 {
_KEYB_ClearKey:
; 0000 0116   keyDown = 0;
	CLR  R7
; 0000 0117 }
	RET
;
;//возвращает код нажатой кнопки
;unsigned char KEYB_GetKey(void)
; 0000 011B {
_KEYB_GetKey:
; 0000 011C   if (keyNew){
	LDS  R30,_keyNew
	CPI  R30,0
	BREQ _0x1E
; 0000 011D     keyNew = 0;
	LDI  R30,LOW(0)
	STS  _keyNew,R30
; 0000 011E     return keyValue;
	LDS  R30,_keyValue
	RET
; 0000 011F   }
; 0000 0120   else
_0x1E:
; 0000 0121     return EVENT_NULL;
	LDI  R30,LOW(0)
	RET
; 0000 0122 }
	RET
;
;#include "lcd_lib.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;//макросы для работы с битами
;#define ClearBit(reg, bit)       reg &= (~(1<<(bit)))
;#define SetBit(reg, bit)         reg |= (1<<(bit))
;
;#define FLAG_BF 7
;
;unsigned char __swap_nibbles(unsigned char data)
; 0001 000A {

	.CSEG
___swap_nibbles:
; 0001 000B  #asm
;	data -> Y+0
; 0001 000C  ld r30, Y
 ld r30, Y
; 0001 000D  swap r30
 swap r30
; 0001 000E  #endasm
; 0001 000F }
	RJMP _0x2000002
;
;void LCD_WriteComInit(unsigned char data)
; 0001 0012 {
_LCD_WriteComInit:
; 0001 0013   unsigned char tmp;
; 0001 0014   delay_us(40);
	ST   -Y,R17
;	data -> Y+1
;	tmp -> R17
	__DELAY_USB 213
; 0001 0015   ClearBit(PORT_SIG, RS);	//установка RS в 0 - команды
	CBI  0x15,6
; 0001 0016 #ifdef BUS_4BIT
; 0001 0017   tmp  = PORT_DATA & 0x0f;
	RJMP _0x2000003
; 0001 0018   tmp |= (data & 0xf0);
; 0001 0019   PORT_DATA = tmp;		//вывод старшей тетрады
; 0001 001A #else
; 0001 001B   PORT_DATA = data;		//вывод данных на шину индикатора
; 0001 001C #endif
; 0001 001D   SetBit(PORT_SIG, EN);	        //установка E в 1
; 0001 001E   delay_us(2);
; 0001 001F   ClearBit(PORT_SIG, EN);	//установка E в 0 - записывающий фронт
; 0001 0020 }
;
;
;inline static void LCD_CommonFunc(unsigned char data)
; 0001 0024 {
_LCD_CommonFunc_G001:
; 0001 0025 #ifdef BUS_4BIT
; 0001 0026   unsigned char tmp;
; 0001 0027   tmp  = PORT_DATA & 0x0f;
	ST   -Y,R17
;	data -> Y+1
;	tmp -> R17
	IN   R30,0x1B
	RCALL SUBOPT_0x2
; 0001 0028   tmp |= (data & 0xf0);
; 0001 0029 
; 0001 002A   PORT_DATA = tmp;		//вывод старшей тетрады
; 0001 002B   SetBit(PORT_SIG, EN);
; 0001 002C   delay_us(2);
; 0001 002D   ClearBit(PORT_SIG, EN);
; 0001 002E 
; 0001 002F   data = __swap_nibbles(data);
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL ___swap_nibbles
	STD  Y+1,R30
; 0001 0030   tmp  = PORT_DATA & 0x0f;
_0x2000003:
	IN   R30,0x1B
	RCALL SUBOPT_0x2
; 0001 0031   tmp |= (data & 0xf0);
; 0001 0032 
; 0001 0033   PORT_DATA = tmp;		//вывод младшей тетрады
; 0001 0034   SetBit(PORT_SIG, EN);
; 0001 0035   delay_us(2);
; 0001 0036   ClearBit(PORT_SIG, EN);
; 0001 0037 #else
; 0001 0038   PORT_DATA = data;		//вывод данных на шину индикатора
; 0001 0039   SetBit(PORT_SIG, EN);	        //установка E в 1
; 0001 003A   delay_us(2);
; 0001 003B   ClearBit(PORT_SIG, EN);	//установка E в 0 - записывающий фронт
; 0001 003C #endif
; 0001 003D }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;inline static void LCD_Wait(void)
; 0001 0040 {
_LCD_Wait_G001:
; 0001 0041 #ifdef CHECK_FLAG_BF
; 0001 0042   #ifdef BUS_4BIT
; 0001 0043 
; 0001 0044   unsigned char data;
; 0001 0045   DDRX_DATA &= 0x0f;            //конфигурируем порт на вход
; 0001 0046   PORT_DATA |= 0xf0;	        //включаем pull-up резисторы
; 0001 0047   SetBit(PORT_SIG, RW);         //RW в 1 чтение из lcd
; 0001 0048   ClearBit(PORT_SIG, RS);	//RS в 0 команды
; 0001 0049   do{
; 0001 004A     SetBit(PORT_SIG, EN);
; 0001 004B     delay_us(2);
; 0001 004C     data = PIN_DATA & 0xf0;      //чтение данных с порта
; 0001 004D     ClearBit(PORT_SIG, EN);
; 0001 004E     data = __swap_nibbles(data);
; 0001 004F     SetBit(PORT_SIG, EN);
; 0001 0050     delay_us(2);
; 0001 0051     data |= PIN_DATA & 0xf0;      //чтение данных с порта
; 0001 0052     ClearBit(PORT_SIG, EN);
; 0001 0053     data = __swap_nibbles(data);
; 0001 0054   }while((data & (1<<FLAG_BF))!= 0 );
; 0001 0055   ClearBit(PORT_SIG, RW);
; 0001 0056   DDRX_DATA |= 0xf0;
; 0001 0057 
; 0001 0058   #else
; 0001 0059   unsigned char data;
; 0001 005A   DDRX_DATA = 0;                //конфигурируем порт на вход
; 0001 005B   PORT_DATA = 0xff;	        //включаем pull-up резисторы
; 0001 005C   SetBit(PORT_SIG, RW);         //RW в 1 чтение из lcd
; 0001 005D   ClearBit(PORT_SIG, RS);	//RS в 0 команды
; 0001 005E   do{
; 0001 005F     SetBit(PORT_SIG, EN);
; 0001 0060     delay_us(2);
; 0001 0061     data = PIN_DATA;            //чтение данных с порта
; 0001 0062     ClearBit(PORT_SIG, EN);
; 0001 0063   }while((data & (1<<FLAG_BF))!= 0 );
; 0001 0064   ClearBit(PORT_SIG, RW);
; 0001 0065   DDRX_DATA = 0xff;
; 0001 0066   #endif
; 0001 0067 #else
; 0001 0068   delay_us(40);
	__DELAY_USB 213
; 0001 0069 #endif
; 0001 006A }
	RET
;
;//функция записи команды
;void LCD_WriteCom(unsigned char data)
; 0001 006E {
_LCD_WriteCom:
; 0001 006F   LCD_Wait();
;	data -> Y+0
	RCALL _LCD_Wait_G001
; 0001 0070   ClearBit(PORT_SIG, RS);	//установка RS в 0 - команды
	CBI  0x15,6
; 0001 0071   LCD_CommonFunc(data);
	RJMP _0x2000001
; 0001 0072 }
;
;//функция записи данных
;void LCD_WriteData(unsigned char data)
; 0001 0076 {
_LCD_WriteData:
; 0001 0077   LCD_Wait();
;	data -> Y+0
	RCALL _LCD_Wait_G001
; 0001 0078   SetBit(PORT_SIG, RS);	        //установка RS в 1 - данные
	SBI  0x15,6
; 0001 0079   LCD_CommonFunc(data);
_0x2000001:
	LD   R30,Y
	ST   -Y,R30
	RCALL _LCD_CommonFunc_G001
; 0001 007A }
_0x2000002:
	ADIW R28,1
	RET
;
;//функция инициализации
;void LCD_Init(void)
; 0001 007E {
_LCD_Init:
; 0001 007F #ifdef BUS_4BIT
; 0001 0080   DDRX_DATA |= 0xf0;
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
; 0001 0081   PORT_DATA |= 0xf0;
	IN   R30,0x1B
	ORI  R30,LOW(0xF0)
	OUT  0x1B,R30
; 0001 0082 #else
; 0001 0083   DDRX_DATA |= 0xff;
; 0001 0084   PORT_DATA |= 0xff;
; 0001 0085 #endif
; 0001 0086 
; 0001 0087   DDRX_SIG |= (1<<RW)|(1<<RS)|(1<<EN);
	IN   R30,0x14
	ORI  R30,LOW(0xD0)
	OUT  0x14,R30
; 0001 0088   PORT_SIG |= (1<<RW)|(1<<RS)|(1<<EN);
	IN   R30,0x15
	ORI  R30,LOW(0xD0)
	OUT  0x15,R30
; 0001 0089   ClearBit(PORT_SIG, RW);
	CBI  0x15,4
; 0001 008A   delay_ms(40);
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x3
; 0001 008B 
; 0001 008C #ifdef HD44780
; 0001 008D   LCD_WriteComInit(0x30);
; 0001 008E   delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x3
; 0001 008F   LCD_WriteComInit(0x30);
; 0001 0090   delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x3
; 0001 0091   LCD_WriteComInit(0x30);
; 0001 0092 #endif
; 0001 0093 
; 0001 0094 #ifdef BUS_4BIT
; 0001 0095   LCD_WriteComInit(0x20); //4-ми разрядная шина
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _LCD_WriteComInit
; 0001 0096   LCD_WriteCom(0x28); //4-ми разрядная шина, 2 - строки
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL _LCD_WriteCom
; 0001 0097 #else
; 0001 0098   LCD_WriteCom(0x38); //8-ми разрядная шина, 2 - строки
; 0001 0099 #endif
; 0001 009A   LCD_WriteCom(0x08);
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _LCD_WriteCom
; 0001 009B   LCD_WriteCom(0x0c);  //0b00001111 - дисплей вкл, курсор и мерцание выключены
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _LCD_WriteCom
; 0001 009C   LCD_WriteCom(0x01);  //0b00000001 - очистка дисплея
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LCD_WriteCom
; 0001 009D   delay_ms(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0001 009E   LCD_WriteCom(0x06);  //0b00000110 - курсор движется вправо, сдвига нет
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _LCD_WriteCom
; 0001 009F }
	RET
;
;//функция вывода строки из флэш памяти
;void LCD_SendStringFlash(char __flash *str)
; 0001 00A3 {
; 0001 00A4   unsigned char data;
; 0001 00A5   while (*str)
;	*str -> Y+1
;	data -> R17
; 0001 00A6   {
; 0001 00A7     data = *str++;
; 0001 00A8     LCD_WriteData(data);
; 0001 00A9   }
; 0001 00AA }
;
;//функция вывда строки из ОЗУ
;void LCD_SendString(char *str)
; 0001 00AE {
_LCD_SendString:
; 0001 00AF   unsigned char data;
; 0001 00B0   while (*str)
	ST   -Y,R17
;	*str -> Y+1
;	data -> R17
_0x20006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x20008
; 0001 00B1   {
; 0001 00B2     data = *str++;
	LD   R17,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
; 0001 00B3     LCD_WriteData(data);
	ST   -Y,R17
	RCALL _LCD_WriteData
; 0001 00B4   }
	RJMP _0x20006
_0x20008:
; 0001 00B5 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;void LCD_Clear(void)
; 0001 00B8 {
; 0001 00B9   LCD_WriteCom(0x01);
; 0001 00BA   delay_ms(2);
; 0001 00BB }
;//******************************************************************************
;//
;//  Author(s)...: Pashgan    http://ChipEnable.Ru
;//
;//  Target(s)...: atmega16
;//
;//  Compiler....: CodeVision 2.05
;//
;//  Description.: Универсальный драйвер матричной клавиатуры. Тестовый проект
;//
;//  Data........: 12.10.2011
;//
;//******************************************************************************
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "keyboard.h"
;#include "lcd_lib.h"
;
;unsigned char buf = 0;
;
;void main( void )
; 0002 0016 {

	.CSEG
_main:
; 0002 0017   LCD_Init();
	RCALL _LCD_Init
; 0002 0018   LCD_Goto(0,0);
	LDI  R30,LOW(128)
	ST   -Y,R30
	RCALL _LCD_WriteCom
; 0002 0019   LCD_SendString("CV Key: ");
	__POINTW1MN _0x40003,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LCD_SendString
; 0002 001A   KEYB_Init();
	CALL _KEYB_Init
; 0002 001B 
; 0002 001C   while(1){
_0x40004:
; 0002 001D      delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0002 001E      KEYB_ScanKeyboard();
	CALL _KEYB_ScanKeyboard
; 0002 001F      buf = KEYB_GetKey();
	CALL _KEYB_GetKey
	MOV  R6,R30
; 0002 0020      if (buf){
	TST  R6
	BREQ _0x40007
; 0002 0021        LCD_Goto(9,0);
	LDI  R30,LOW(137)
	ST   -Y,R30
	RCALL _LCD_WriteCom
; 0002 0022        LCD_WriteData(buf);
	ST   -Y,R6
	RCALL _LCD_WriteData
; 0002 0023      }
; 0002 0024   }
_0x40007:
	RJMP _0x40004
; 0002 0025 }
_0x40008:
	RJMP _0x40008

	.DSEG
_0x40003:
	.BYTE 0x9

	.DSEG
_keyValue:
	.BYTE 0x1
_keyNew:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	__DELAY_USB 27
	IN   R30,0x19
	COM  R30
	ANDI R30,LOW(0xF0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	MOV  R30,R17
	LDI  R26,LOW(_keyTable*2)
	LDI  R27,HIGH(_keyTable*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	LDD  R30,Y+1
	ANDI R30,LOW(0xF0)
	OR   R17,R30
	OUT  0x1B,R17
	SBI  0x15,7
	__DELAY_USB 11
	CBI  0x15,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP _LCD_WriteComInit


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
