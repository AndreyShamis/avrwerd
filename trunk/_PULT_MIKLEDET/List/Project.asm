
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 4.000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R3
	.DEF _rx_rd_index=R2
	.DEF _rx_counter=R5
	.DEF _tx_wr_index=R4
	.DEF _tx_rd_index=R7
	.DEF _tx_counter=R6
	.DEF _keys=R9

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_int
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/25/2011
;Author  : NeVaDa
;Company : WERD
;Comments:
;
;
;Chip type               : ATtiny2313
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*****************************************************/
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 004D {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 004E char status,data;
; 0000 004F status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0050 data=UDR;
	IN   R16,12
; 0000 0051 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0052    {
; 0000 0053    rx_buffer[rx_wr_index]=data;
	MOV  R30,R3
	SUBI R30,-LOW(_rx_buffer)
	ST   Z,R16
; 0000 0054    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R3
	LDI  R30,LOW(8)
	CP   R30,R3
	BRNE _0x4
	CLR  R3
; 0000 0055    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x5
; 0000 0056       {
; 0000 0057       rx_counter=0;
	CLR  R5
; 0000 0058       rx_buffer_overflow=1;
	SBI  0x13,0
; 0000 0059       };
_0x5:
; 0000 005A    };
_0x3:
; 0000 005B }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0062 {
; 0000 0063     char data;
; 0000 0064     while (rx_counter==0);
;	data -> R17
; 0000 0065     data=rx_buffer[rx_rd_index];
; 0000 0066     if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0067     #asm("cli")
; 0000 0068     --rx_counter;
; 0000 0069     #asm("sei")
; 0000 006A     return data;
; 0000 006B }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE<256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 007B {
_usart_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 007C     if (tx_counter)
	TST  R6
	BREQ _0xC
; 0000 007D        {
; 0000 007E        --tx_counter;
	DEC  R6
; 0000 007F        UDR=tx_buffer[tx_rd_index];
	LDI  R26,LOW(_tx_buffer)
	ADD  R26,R7
	LD   R30,X
	OUT  0xC,R30
; 0000 0080        if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0xD
	CLR  R7
; 0000 0081        };
_0xD:
_0xC:
; 0000 0082 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0089 {
_putchar:
; 0000 008A     while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0xE:
	LDI  R30,LOW(8)
	CP   R30,R6
	BREQ _0xE
; 0000 008B     #asm("cli")
	cli
; 0000 008C     if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R6
	BRNE _0x12
	SBIC 0xB,5
	RJMP _0x11
_0x12:
; 0000 008D        {
; 0000 008E        tx_buffer[tx_wr_index]=c;
	MOV  R30,R4
	SUBI R30,-LOW(_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 008F        if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x14
	CLR  R4
; 0000 0090        ++tx_counter;
_0x14:
	INC  R6
; 0000 0091        }
; 0000 0092     else
	RJMP _0x15
_0x11:
; 0000 0093        UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0094     #asm("sei")
_0x15:
	sei
; 0000 0095 }
	RJMP _0x2000001
;#pragma used-
;#endif
;
;
;// PIND0..3 will be row inputs
;#define KEYIN PINB
;// PORTD4..7 will be column outputs
;#define KEYOUT PORTB
;#define F_XTAL 4000000L
;
;// used for TIMER0 count initialization
;#define INIT_TIMER TCNT0=0x100L-F_XTAL/64L/500L
;//#define INIT_TIMER TCNT0=0x10L
;#define FIRST_COLUMN 0x80
;#define LAST_COLUMN 0x20
;
;
;void init_keypad(void);
;char inkey();
;
; char keys;
;
; void GetButton(char val)
; 0000 00AD {
_GetButton:
; 0000 00AE 
; 0000 00AF 
; 0000 00B0     if(!PINB.0)
;	val -> Y+0
	SBIC 0x16,0
	RJMP _0x16
; 0000 00B1         keys =  1+val;
	LD   R30,Y
	SUBI R30,-LOW(1)
	MOV  R9,R30
; 0000 00B2     else if(!PINB.1)
	RJMP _0x17
_0x16:
	SBIC 0x16,1
	RJMP _0x18
; 0000 00B3         keys =  2+val;
	LD   R30,Y
	SUBI R30,-LOW(2)
	MOV  R9,R30
; 0000 00B4     else  if(!PINB.2)
	RJMP _0x19
_0x18:
	SBIC 0x16,2
	RJMP _0x1A
; 0000 00B5         keys =  3+val;
	LD   R30,Y
	SUBI R30,-LOW(3)
	MOV  R9,R30
; 0000 00B6     else  if(!PINB.3)
	RJMP _0x1B
_0x1A:
	SBIC 0x16,3
	RJMP _0x1C
; 0000 00B7         keys =  4+val;
	LD   R30,Y
	SUBI R30,-LOW(4)
	MOV  R9,R30
; 0000 00B8     else  if(!PINB.4)
	RJMP _0x1D
_0x1C:
	SBIC 0x16,4
	RJMP _0x1E
; 0000 00B9         keys =  5+val;
	LD   R30,Y
	SUBI R30,-LOW(5)
	MOV  R9,R30
; 0000 00BA     else
	RJMP _0x1F
_0x1E:
; 0000 00BB      keys =  0;
	CLR  R9
; 0000 00BC }
_0x1F:
_0x1D:
_0x1B:
_0x19:
_0x17:
_0x2000001:
	ADIW R28,1
	RET
;// TIMER 0 interrupt at every 2 ms
;interrupt [TIM0_OVF] void timer0_int(void){
; 0000 00BE interrupt [7] void timer0_int(void){
_timer0_int:
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
; 0000 00BF 
; 0000 00C0 
; 0000 00C1  /*
; 0000 00C2 
; 0000 00C3     static unsigned char key_pressed_counter = 20;
; 0000 00C4     static unsigned char key_released_counter,
; 0000 00C5                     column=FIRST_COLUMN;
; 0000 00C6     static unsigned row_data,
; 0000 00C7                     crt_key;
; 0000 00C8     // reinitialize TIMER0
; 0000 00C9     INIT_TIMER;
; 0000 00CA     row_data<<=3;
; 0000 00CB     // get a group of 4 keys in in row_data
; 0000 00CC     row_data|=~KEYIN&0xf1;
; 0000 00CD     column>>=1;
; 0000 00CE     if (column==(LAST_COLUMN>>1))
; 0000 00CF     {
; 0000 00D0         column=FIRST_COLUMN;
; 0000 00D1         if (row_data==0)
; 0000 00D2                 goto new_key;
; 0000 00D3         if (key_released_counter)
; 0000 00D4                 --key_released_counter;
; 0000 00D5         else
; 0000 00D6         {
; 0000 00D7           if (--key_pressed_counter==9)
; 0000 00D8                 crt_key=row_data;
; 0000 00D9           else
; 0000 00DA           {
; 0000 00DB              if (row_data!=crt_key)
; 0000 00DC              {
; 0000 00DD                 new_key:
; 0000 00DE                 key_pressed_counter=10;
; 0000 00DF                 key_released_counter=0;
; 0000 00E0                 goto end_key;
; 0000 00E1              };
; 0000 00E2              if(!key_pressed_counter)
; 0000 00E3              {
; 0000 00E4                 keys=row_data;
; 0000 00E5                 key_released_counter=20;
; 0000 00E6              };
; 0000 00E7           };
; 0000 00E8         };
; 0000 00E9        end_key:;
; 0000 00EA        row_data=0;
; 0000 00EB     };
; 0000 00EC     // select next column, inputs will be with pull-up
; 0000 00ED     KEYOUT=~column;
; 0000 00EE     */
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 
; 0000 00F2 //     #asm("cli")
; 0000 00F3 //    keys=0;
; 0000 00F4     if(keys==0)
	TST  R9
	BRNE _0x20
; 0000 00F5     {
; 0000 00F6     PORTB.5 = 0;
	RCALL SUBOPT_0x0
; 0000 00F7     GetButton(0);
; 0000 00F8     PORTB.5 = 1;
; 0000 00F9     }
; 0000 00FA     if(keys==0)
_0x20:
	TST  R9
	BRNE _0x25
; 0000 00FB     {
; 0000 00FC     PORTB.6 = 0;
	RCALL SUBOPT_0x1
; 0000 00FD     GetButton(5);
; 0000 00FE     PORTB.6 = 1;
; 0000 00FF     }
; 0000 0100 
; 0000 0101     if(keys==0)
_0x25:
	TST  R9
	BRNE _0x2A
; 0000 0102     {
; 0000 0103     PORTB.7 = 0;
	RCALL SUBOPT_0x2
; 0000 0104     GetButton(10);
; 0000 0105     PORTB.7 = 1;
; 0000 0106     }
; 0000 0107 
; 0000 0108         #asm("sei")
_0x2A:
	sei
; 0000 0109 
; 0000 010A }
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
;
;
;
;
;//============================================================================
;//      Main Function
;void main(void)
; 0000 0112 {
_main:
; 0000 0113 
; 0000 0114     char k;
; 0000 0115     // Crystal Oscillator division factor: 1
; 0000 0116     #pragma optsize-
; 0000 0117 //    CLKPR=0x80;
; 0000 0118 //    CLKPR=0x00;
; 0000 0119     #ifdef _OPTIMIZE_SIZE_
; 0000 011A     #pragma optsize+
; 0000 011B     #endif
; 0000 011C 
; 0000 011D 
; 0000 011E     PORTA=0x00;
;	k -> R17
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 011F     DDRA=0x00;
	OUT  0x1A,R30
; 0000 0120 
; 0000 0121     PORTD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 0122     DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0123     DDRB=0xE0;
	RCALL SUBOPT_0x3
; 0000 0124     PORTB=0xFF;
; 0000 0125     keys = 0;
; 0000 0126    /*
; 0000 0127     TCCR0A=0x00;
; 0000 0128     TCCR0B=0x00;
; 0000 0129     TCNT0=0x00;
; 0000 012A     OCR0A=0x00;
; 0000 012B     OCR0B=0x00;
; 0000 012C 
; 0000 012D     TCCR1A=0x00;
; 0000 012E     TCCR1B=0x00;
; 0000 012F     TCNT1H=0x00;
; 0000 0130     TCNT1L=0x00;
; 0000 0131     ICR1H=0x00;
; 0000 0132     ICR1L=0x00;
; 0000 0133     OCR1AH=0x00;
; 0000 0134     OCR1AL=0x00;
; 0000 0135     OCR1BH=0x00;
; 0000 0136     OCR1BL=0x00;
; 0000 0137 
; 0000 0138     GIMSK=0x00;
; 0000 0139     MCUCR=0x00;
; 0000 013A 
; 0000 013B     TIMSK=0x00;
; 0000 013C 
; 0000 013D     USICR=0x00;
; 0000 013E 
; 0000 013F     ACSR=0x80;
; 0000 0140     */
; 0000 0141         UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0142         UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0143         UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 0144         UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0145         UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0146 
; 0000 0147 
; 0000 0148 
; 0000 0149  init_keypad();
	RCALL _init_keypad
; 0000 014A     k=inkey();
	RCALL _inkey
	MOV  R17,R30
; 0000 014B     putchar(k);
	ST   -Y,R17
	RCALL _putchar
; 0000 014C     while (1)
_0x2F:
; 0000 014D     {
; 0000 014E         // Place your code here
; 0000 014F         #pragma warn-
; 0000 0150         if (k=inkey())
	RCALL _inkey
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x32
; 0000 0151         {
; 0000 0152             putchar(k);
	ST   -Y,R17
	RCALL _putchar
; 0000 0153         }
; 0000 0154         #pragma warn+
_0x32:
; 0000 0155 
; 0000 0156         delay_ms(400);
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0157 
; 0000 0158     };
	RJMP _0x2F
; 0000 0159 }
_0x33:
	RJMP _0x33
;
;
;char inkey()
; 0000 015D {
_inkey:
; 0000 015E     unsigned char k;
; 0000 015F  //   #pragma warn-
; 0000 0160    // if (k=keys) keys=0;
; 0000 0161    // INIT_TIMER;
; 0000 0162      if(keys==0)
	ST   -Y,R17
;	k -> R17
	TST  R9
	BRNE _0x34
; 0000 0163     {
; 0000 0164     PORTB.5 = 0;
	RCALL SUBOPT_0x0
; 0000 0165     GetButton(0);
; 0000 0166     PORTB.5 = 1;
; 0000 0167     }
; 0000 0168     if(keys==0)
_0x34:
	TST  R9
	BRNE _0x39
; 0000 0169     {
; 0000 016A     PORTB.6 = 0;
	RCALL SUBOPT_0x1
; 0000 016B     GetButton(5);
; 0000 016C     PORTB.6 = 1;
; 0000 016D     }
; 0000 016E 
; 0000 016F     if(keys==0)
_0x39:
	TST  R9
	BRNE _0x3E
; 0000 0170     {
; 0000 0171     PORTB.7 = 0;
	RCALL SUBOPT_0x2
; 0000 0172     GetButton(10);
; 0000 0173     PORTB.7 = 1;
; 0000 0174     }
; 0000 0175     k=keys;
_0x3E:
	MOV  R17,R9
; 0000 0176         keys=0;
	CLR  R9
; 0000 0177     return k;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0178 }
;
;void init_keypad(void)
; 0000 017B {
_init_keypad:
; 0000 017C     DDRB=0xE0;
	RCALL SUBOPT_0x3
; 0000 017D     PORTB=0xFF;
; 0000 017E     keys = 0;
; 0000 017F     // Mode: Normal top=FFh
; 0000 0180     // OC0 output: Disconnected
; 0000 0181     TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0182     INIT_TIMER;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0183 
; 0000 0184     // External Interrupts are off
; 0000 0185     MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0186     //EMCUCR=0x00;
; 0000 0187     // Timer 0 overflow interrupt is on
; 0000 0188     TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0189     #asm("sei")
	sei
; 0000 018A }
	RET

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	CBI  0x18,5
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _GetButton
	SBI  0x18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	CBI  0x18,6
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _GetButton
	SBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	CBI  0x18,7
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _GetButton
	SBI  0x18,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(224)
	OUT  0x17,R30
	LDI  R30,LOW(255)
	OUT  0x18,R30
	CLR  R9
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
