
;CodeVisionAVR C Compiler V2.05.3 Professional
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega162V
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega162V
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1279
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	.DEF _devices=R5
	.DEF _i=R4
	.DEF _j=R7
	.DEF _rx_wr_index0=R6
	.DEF _rx_rd_index0=R9
	.DEF _rx_counter0=R8
	.DEF _tx_wr_index0=R11
	.DEF _tx_rd_index0=R10
	.DEF _tx_counter0=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

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
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_conv_delay_G101:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G101:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x46,0x6F,0x75,0x6E,0x64,0x20,0x25,0x75
	.DB  0x20,0x64,0x65,0x76,0x69,0x63,0x65,0x73
	.DB  0xA,0x2E,0x0,0x44,0x65,0x76,0x20,0x25
	.DB  0x75,0x2E,0x20,0x0,0x25,0x30,0x32,0x58
	.DB  0x20,0x0,0x4E,0x6F,0x74,0x20,0x46,0x6F
	.DB  0x75,0x6E,0x64,0x65,0x64,0x0,0x20,0x49
	.DB  0x6E,0x69,0x74,0x20,0x65,0x72,0x72,0x20
	.DB  0x25,0x75,0x20,0x2E,0x0,0x54,0x25,0x64
	.DB  0x3A,0x25,0x2E,0x32,0x66,0x20,0xEF,0x43
	.DB  0x2E,0x20,0x0,0x50,0x72,0x65,0x73,0x73
	.DB  0x65,0x64,0x20,0x20,0x45,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

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
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;/*****************************************************
;Chip type               : ATmega162V
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega162.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>      // Standard Input/Output functions
;//#include <1wire.h>    // 1 Wire Bus interface functions
;#include <ds18b20.h>    // DS1820 Temperature Sensor functions
;//=======================================================================================
;//                          DEFINE SECTION
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
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;
;#define CONTROL_FAN_OBDUV       PORTC.0
;#define CONTROL_FAN_VIDUV       PORTC.1
;#define CONTROL_LIGHT           PORTC.2
;
;#define RX_BUFFER_SIZE0 20              // USART0 Receiver buffer
;#define TX_BUFFER_SIZE0 20              // USART0 Transmitter buffer
;#define MAX_DEVICES 3                   // maximum number of DS1820 devices connected to the 1 Wire bus
;#define DELAY_TIME 100
;//=======================================================================================
;//                  GLOBAL VARIABLES SECTOION
;unsigned char devices;                      // number of DS1820 devices connected to the 1 Wire bus
;unsigned char rom_codes[MAX_DEVICES][9];    // DS1820 devices ROM code storage area,
;
;bit rx_buffer_overflow0;                    // This flag is set on USART0 Receiver buffer overflow
;char rx_buffer0[RX_BUFFER_SIZE0];
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;char lcd_buffer[30];
;unsigned char i,j;
;
;//===========================
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char   rx_wr_index0,
;                rx_rd_index0,
;                rx_counter0;
;#else
;unsigned int    rx_wr_index0,
;                rx_rd_index0,
;                rx_counter0;
;#endif
;
;//===========================
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char   tx_wr_index0,
;                tx_rd_index0,
;                tx_counter0;
;#else
;unsigned int    tx_wr_index0,
;                tx_rd_index0,
;                tx_counter0;
;#endif
;
;
;//=======================================================================================
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0062 {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0063     char    status,
; 0000 0064             data;
; 0000 0065 
; 0000 0066     status  =   UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0067     data    =   UDR0;
	IN   R16,12
; 0000 0068 
; 0000 0069     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 006A     {
; 0000 006B         rx_buffer0[rx_wr_index0++]  =   data;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 006C #if RX_BUFFER_SIZE0 == 256
; 0000 006D    // special case for receiver buffer size=256
; 0000 006E    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 006F #else
; 0000 0070    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(20)
	CP   R30,R6
	BRNE _0x4
	CLR  R6
; 0000 0071    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R8
	LDI  R30,LOW(20)
	CP   R30,R8
	BRNE _0x5
; 0000 0072       {
; 0000 0073         rx_counter0         =   0;
	CLR  R8
; 0000 0074         rx_buffer_overflow0 =   1;
	SET
	BLD  R2,0
; 0000 0075       }
; 0000 0076 #endif
; 0000 0077    }
_0x5:
; 0000 0078 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x61
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;//=======================================================================================
;char getchar(void)
; 0000 0080 {
; 0000 0081     char data;
; 0000 0082     while (rx_counter0==0);
;	data -> R17
; 0000 0083     data=rx_buffer0[rx_rd_index0++];
; 0000 0084 #if RX_BUFFER_SIZE0 != 256
; 0000 0085     if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 0086 #endif
; 0000 0087 #asm("cli")
; 0000 0088     --rx_counter0;
; 0000 0089 #asm("sei")
; 0000 008A     return data;
; 0000 008B }
;#pragma used-
;#endif
;
;//=======================================================================================
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0092 {
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0093     if (tx_counter0)
	TST  R13
	BREQ _0xA
; 0000 0094     {
; 0000 0095         --tx_counter0;
	DEC  R13
; 0000 0096         UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0097         #if TX_BUFFER_SIZE0 != 256
; 0000 0098         if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(20)
	CP   R30,R10
	BRNE _0xB
	CLR  R10
; 0000 0099         #endif
; 0000 009A     }
_0xB:
; 0000 009B }
_0xA:
_0x61:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;
;//=======================================================================================
;void putchar(char c)
; 0000 00A4 {
_putchar:
; 0000 00A5     while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0xC:
	LDI  R30,LOW(20)
	CP   R30,R13
	BREQ _0xC
; 0000 00A6     #asm("cli")
	cli
; 0000 00A7     if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R13
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 00A8     {
; 0000 00A9         tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R11
	INC  R11
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00AA         #if TX_BUFFER_SIZE0 != 256
; 0000 00AB         if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(20)
	CP   R30,R11
	BRNE _0x12
	CLR  R11
; 0000 00AC         #endif
; 0000 00AD         ++tx_counter0;
_0x12:
	INC  R13
; 0000 00AE     }
; 0000 00AF     else
	RJMP _0x13
_0xF:
; 0000 00B0         UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00B1     #asm("sei")
_0x13:
	sei
; 0000 00B2 }
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;//=======================================================================================
;void SendData(char *data);
;void InitilizeMC();
;
;//=======================================================================================
;void main(void)
; 0000 00BC {
_main:
; 0000 00BD     // Declare your local variables here
; 0000 00BE     InitilizeMC();
	RCALL _InitilizeMC
; 0000 00BF 
; 0000 00C0     delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 00C1     w1_init();
	CALL _w1_init
; 0000 00C2     devices=w1_search(DS18B20_SEARCH_ROM_CMD,rom_codes);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R26,LOW(_rom_codes)
	LDI  R27,HIGH(_rom_codes)
	CALL _w1_search
	MOV  R5,R30
; 0000 00C3     // Global enable interrupts
; 0000 00C4     #asm("sei")
	sei
; 0000 00C5 
; 0000 00C6     CONTROL_FAN_OBDUV   = 0;
	CBI  0x15,0
; 0000 00C7     CONTROL_FAN_VIDUV   = 0;
	CBI  0x15,1
; 0000 00C8     CONTROL_LIGHT       = 0;
	CBI  0x15,2
; 0000 00C9     if (devices)
	TST  R5
	BREQ _0x1A
; 0000 00CA     {
; 0000 00CB         sprintf(lcd_buffer,"Found %u devices\n.",devices);
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CALL SUBOPT_0x1
; 0000 00CC         SendData(lcd_buffer);
; 0000 00CD         for (i=0;i<devices;i++)
	CLR  R4
_0x1C:
	CP   R4,R5
	BRSH _0x1D
; 0000 00CE         {
; 0000 00CF            sprintf(lcd_buffer,"Dev %u. ",i+1);
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,19
	CALL SUBOPT_0x2
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 00D0            SendData(lcd_buffer);
	CALL SUBOPT_0x3
; 0000 00D1            delay_ms(10);
	CALL SUBOPT_0x4
; 0000 00D2 
; 0000 00D3            for (j=0;j<8;j++)
	CLR  R7
_0x1F:
	LDI  R30,LOW(8)
	CP   R7,R30
	BRSH _0x20
; 0000 00D4                {
; 0000 00D5                sprintf(lcd_buffer,"%02X ",rom_codes[i][j]);
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,28
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5
	MOVW R26,R30
	CLR  R30
	ADD  R26,R7
	ADC  R27,R30
	LD   R30,X
	CALL SUBOPT_0x1
; 0000 00D6                SendData(lcd_buffer);
; 0000 00D7                }
	INC  R7
	RJMP _0x1F
_0x20:
; 0000 00D8            delay_ms(10);
	CALL SUBOPT_0x4
; 0000 00D9         }
	INC  R4
	RJMP _0x1C
_0x1D:
; 0000 00DA     }
; 0000 00DB     else
	RJMP _0x21
_0x1A:
; 0000 00DC     {
; 0000 00DD         sprintf(lcd_buffer,"Not Founded");
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x6
; 0000 00DE         SendData(lcd_buffer);
; 0000 00DF     }
_0x21:
; 0000 00E0 
; 0000 00E1     for (i=0;i<devices;i++)
	CLR  R4
_0x23:
	CP   R4,R5
	BRSH _0x24
; 0000 00E2     {
; 0000 00E3         if (!ds18b20_init(&rom_codes[i][0],12,39,DS18B20_12BIT_RES))//DS18B20_12BIT_RES
	CALL SUBOPT_0x5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(39)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ds18b20_init
	CPI  R30,0
	BRNE _0x25
; 0000 00E4         {
; 0000 00E5            sprintf(lcd_buffer," Init err %u .",i);
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,46
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R4
	CALL SUBOPT_0x1
; 0000 00E6            SendData(lcd_buffer);
; 0000 00E7         }
; 0000 00E8         delay_ms(100);
_0x25:
	CALL SUBOPT_0x7
; 0000 00E9     }
	INC  R4
	RJMP _0x23
_0x24:
; 0000 00EA 
; 0000 00EB 
; 0000 00EC     while (1)
_0x26:
; 0000 00ED     {
; 0000 00EE         j=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 00EF         for (i=0;i<devices;i++)
	CLR  R4
_0x2A:
	CP   R4,R5
	BRSH _0x2B
; 0000 00F0         {
; 0000 00F1           sprintf(lcd_buffer,"T%d:%.2f \xefC. ",i+1,ds18b20_temperature(&rom_codes[i][0]));
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,61
	CALL SUBOPT_0x2
	CALL SUBOPT_0x5
	MOVW R26,R30
	RCALL _ds18b20_temperature
	CALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
; 0000 00F2 
; 0000 00F3           SendData(lcd_buffer);
	CALL SUBOPT_0x3
; 0000 00F4           delay_ms(10);
	CALL SUBOPT_0x4
; 0000 00F5         }
	INC  R4
	RJMP _0x2A
_0x2B:
; 0000 00F6 
; 0000 00F7         PORTB.0 = 0;
	CBI  0x18,0
; 0000 00F8 
; 0000 00F9         if (rx_buffer0[0]== 'E')
	LDS  R26,_rx_buffer0
	CPI  R26,LOW(0x45)
	BRNE _0x2E
; 0000 00FA         {
; 0000 00FB             sprintf(lcd_buffer,"Pressed  E");
	CALL SUBOPT_0x0
	__POINTW1FN _0x0,75
	CALL SUBOPT_0x6
; 0000 00FC             SendData(lcd_buffer);
; 0000 00FD             rx_buffer0[0]='C' ;
	LDI  R30,LOW(67)
	STS  _rx_buffer0,R30
; 0000 00FE             PORTB.0 = 1;
	SBI  0x18,0
; 0000 00FF             delay_ms(DELAY_TIME*2);
	LDI  R26,LOW(200)
	CALL SUBOPT_0x8
; 0000 0100 
; 0000 0101         }
; 0000 0102         CONTROL_FAN_OBDUV = 1;
_0x2E:
	SBI  0x15,0
; 0000 0103         CONTROL_FAN_VIDUV = 0;
	CBI  0x15,1
; 0000 0104         CONTROL_LIGHT = 0;
	CBI  0x15,2
; 0000 0105         delay_ms(DELAY_TIME);
	CALL SUBOPT_0x7
; 0000 0106         CONTROL_FAN_OBDUV = 0;
	CBI  0x15,0
; 0000 0107         CONTROL_FAN_VIDUV = 1;
	SBI  0x15,1
; 0000 0108         CONTROL_LIGHT = 0;
	CBI  0x15,2
; 0000 0109         delay_ms(DELAY_TIME);
	CALL SUBOPT_0x7
; 0000 010A         CONTROL_FAN_OBDUV = 0;
	CBI  0x15,0
; 0000 010B         CONTROL_FAN_VIDUV = 0;
	CBI  0x15,1
; 0000 010C         CONTROL_LIGHT = 1;
	SBI  0x15,2
; 0000 010D         delay_ms(DELAY_TIME);
	CALL SUBOPT_0x7
; 0000 010E         CONTROL_FAN_OBDUV = 0;
	CBI  0x15,0
; 0000 010F         CONTROL_FAN_VIDUV = 0;
	CBI  0x15,1
; 0000 0110         CONTROL_LIGHT = 0;
	CBI  0x15,2
; 0000 0111         delay_ms(DELAY_TIME);
	CALL SUBOPT_0x7
; 0000 0112         CONTROL_FAN_OBDUV = 1;
	SBI  0x15,0
; 0000 0113         CONTROL_FAN_VIDUV = 1;
	SBI  0x15,1
; 0000 0114         CONTROL_LIGHT = 0;
	CBI  0x15,2
; 0000 0115         delay_ms(DELAY_TIME);
	CALL SUBOPT_0x7
; 0000 0116         CONTROL_FAN_OBDUV = 1;
	SBI  0x15,0
; 0000 0117         CONTROL_FAN_VIDUV = 0;
	CBI  0x15,1
; 0000 0118         CONTROL_LIGHT = 1;
	SBI  0x15,2
; 0000 0119         delay_ms(DELAY_TIME);
	CALL SUBOPT_0x7
; 0000 011A         CONTROL_FAN_OBDUV = 1;
	SBI  0x15,0
; 0000 011B         CONTROL_FAN_VIDUV = 1;
	SBI  0x15,1
; 0000 011C         CONTROL_LIGHT = 1;
	SBI  0x15,2
; 0000 011D         delay_ms(DELAY_TIME);
	CALL SUBOPT_0x7
; 0000 011E         // }
; 0000 011F         //putchar('C');
; 0000 0120 
; 0000 0121         PORTB.0 = 1;
	SBI  0x18,0
; 0000 0122         delay_ms(DELAY_TIME);
	CALL SUBOPT_0x7
; 0000 0123     }
	RJMP _0x26
; 0000 0124 }
_0x5D:
	NOP
	RJMP _0x5D
;
;//=======================================================================================
;void SendData(char *data)
; 0000 0128 {
_SendData:
; 0000 0129     while(*data != 0)
	ST   -Y,R27
	ST   -Y,R26
;	*data -> Y+0
_0x5E:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x60
; 0000 012A     {
; 0000 012B         putchar(*(data++));
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RCALL _putchar
; 0000 012C         delay_ms(1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x8
; 0000 012D     }
	RJMP _0x5E
_0x60:
; 0000 012E }
	ADIW R28,2
	RET
;//=======================================================================================
;void InitilizeMC()
; 0000 0131 {
_InitilizeMC:
; 0000 0132     // Crystal Oscillator division factor: 1
; 0000 0133     #pragma optsize-
; 0000 0134     CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0135     CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0136     #ifdef _OPTIMIZE_SIZE_
; 0000 0137     #pragma optsize+
; 0000 0138     #endif
; 0000 0139 
; 0000 013A     PORTA=0x00;
	OUT  0x1B,R30
; 0000 013B     DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 013C     PORTB=0xFF;
	OUT  0x18,R30
; 0000 013D     DDRB=0x01;
	LDI  R30,LOW(1)
	OUT  0x17,R30
; 0000 013E     PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 013F     DDRC=0xFF;
	OUT  0x14,R30
; 0000 0140     PORTD=0xEF;
	LDI  R30,LOW(239)
	OUT  0x12,R30
; 0000 0141     DDRD=0x12;
	LDI  R30,LOW(18)
	OUT  0x11,R30
; 0000 0142     PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 0143     DDRE=0x00;
	OUT  0x6,R30
; 0000 0144 
; 0000 0145 
; 0000 0146 
; 0000 0147     // Timer/Counter 0 initialization  Clock source: System Clock
; 0000 0148     // Clock value: Timer 0 Stopped    Mode: Normal top=0xFF
; 0000 0149     // OC0 output: Disconnected
; 0000 014A     TCCR0=0x00;
	OUT  0x33,R30
; 0000 014B     TCNT0=0x00;
	OUT  0x32,R30
; 0000 014C     OCR0=0x00;
	OUT  0x31,R30
; 0000 014D 
; 0000 014E     // Timer/Counter 1 initialization
; 0000 014F     // Clock source: System Clock
; 0000 0150     // Clock value: Timer1 Stopped
; 0000 0151     // Mode: Normal top=0xFFFF
; 0000 0152     // OC1A output: Discon.
; 0000 0153     // OC1B output: Discon.
; 0000 0154     // Noise Canceler: Off
; 0000 0155     // Input Capture on Falling Edge
; 0000 0156     // Timer1 Overflow Interrupt: Off
; 0000 0157     // Input Capture Interrupt: Off
; 0000 0158     // Compare A Match Interrupt: Off
; 0000 0159     // Compare B Match Interrupt: Off
; 0000 015A     TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 015B     TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 015C     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 015D     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 015E     ICR1H=0x00;
	OUT  0x25,R30
; 0000 015F     ICR1L=0x00;
	OUT  0x24,R30
; 0000 0160     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0161     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0162     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0163     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0164 
; 0000 0165     // Timer/Counter 2 initialization
; 0000 0166     // Clock source: System Clock
; 0000 0167     // Clock value: Timer2 Stopped
; 0000 0168     // Mode: Normal top=0xFF
; 0000 0169     // OC2 output: Disconnected
; 0000 016A     ASSR=0x00;
	OUT  0x26,R30
; 0000 016B     TCCR2=0x00;
	OUT  0x27,R30
; 0000 016C     TCNT2=0x00;
	OUT  0x23,R30
; 0000 016D     OCR2=0x00;
	OUT  0x22,R30
; 0000 016E 
; 0000 016F     // Timer/Counter 3 initialization
; 0000 0170     // Clock value: Timer3 Stopped
; 0000 0171     // Mode: Normal top=0xFFFF
; 0000 0172     // OC3A output: Discon.
; 0000 0173     // OC3B output: Discon.
; 0000 0174     // Noise Canceler: Off
; 0000 0175     // Input Capture on Falling Edge
; 0000 0176     // Timer3 Overflow Interrupt: Off
; 0000 0177     // Input Capture Interrupt: Off
; 0000 0178     // Compare A Match Interrupt: Off
; 0000 0179     // Compare B Match Interrupt: Off
; 0000 017A     TCCR3A=0x00;
	STS  139,R30
; 0000 017B     TCCR3B=0x00;
	STS  138,R30
; 0000 017C     TCNT3H=0x00;
	STS  137,R30
; 0000 017D     TCNT3L=0x00;
	STS  136,R30
; 0000 017E     ICR3H=0x00;
	STS  129,R30
; 0000 017F     ICR3L=0x00;
	STS  128,R30
; 0000 0180     OCR3AH=0x00;
	STS  135,R30
; 0000 0181     OCR3AL=0x00;
	STS  134,R30
; 0000 0182     OCR3BH=0x00;
	STS  133,R30
; 0000 0183     OCR3BL=0x00;
	STS  132,R30
; 0000 0184 
; 0000 0185     // External Interrupt(s) initialization
; 0000 0186     // INT0: Off
; 0000 0187     // INT1: Off
; 0000 0188     // INT2: Off
; 0000 0189     // Interrupt on any change on pins PCINT0-7: Off
; 0000 018A     // Interrupt on any change on pins PCINT8-15: Off
; 0000 018B     MCUCR=0x00;
	OUT  0x35,R30
; 0000 018C     EMCUCR=0x00;
	OUT  0x36,R30
; 0000 018D 
; 0000 018E     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 018F     TIMSK=0x00;
	OUT  0x39,R30
; 0000 0190 
; 0000 0191     ETIMSK=0x00;
	STS  125,R30
; 0000 0192 
; 0000 0193     // USART0 initialization
; 0000 0194     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0195     // USART0 Receiver: On
; 0000 0196     // USART0 Transmitter: On
; 0000 0197     // USART0 Mode: Asynchronous
; 0000 0198     // USART0 Baud Rate: 9600
; 0000 0199     UCSR0A=0x00;
	OUT  0xB,R30
; 0000 019A     UCSR0B=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 019B     UCSR0C=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 019C     UBRR0H=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 019D     UBRR0L=0x33;   //06
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 019E 
; 0000 019F     // USART1 initialization
; 0000 01A0     // USART1 disabled
; 0000 01A1     UCSR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 01A2 
; 0000 01A3     // Analog Comparator initialization
; 0000 01A4     // Analog Comparator: Off
; 0000 01A5     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01A6     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01A7 
; 0000 01A8     // SPI initialization  // SPI disabled
; 0000 01A9     SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 01AA }
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x9
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x9
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C0004
__ftoe_G100:
	CALL SUBOPT_0xA
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20C0008
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20C0008
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0xB
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0xB
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0xC
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	CALL SUBOPT_0xB
_0x2000022:
	CALL SUBOPT_0xC
	BRLO _0x2000024
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0xC
	BRSH _0x2000028
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0xB
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	CALL SUBOPT_0xC
	BRLO _0x2000029
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	__GETD2S 4
	CALL SUBOPT_0x12
	CALL SUBOPT_0x11
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0xD
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0xD
	CALL SUBOPT_0x15
	CALL SUBOPT_0x10
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x13
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x16
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x200010E
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x200010E:
	ST   X,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x16
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0008:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G100:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x9
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x17
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x17
	RJMP _0x200010F
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	CALL SUBOPT_0x18
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1A
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x1B
	CALL __GETD1P
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	RJMP _0x200005E
_0x200005B:
	CALL SUBOPT_0x1E
	CALL __ANEGF1
	CALL SUBOPT_0x1C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x200005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x1A
	RJMP _0x2000060
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000060:
_0x200005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000062
	CALL SUBOPT_0x1E
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2000063
_0x2000062:
	CALL SUBOPT_0x1E
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x1F
	RJMP _0x2000064
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000066
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1F
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0x70)
	BRNE _0x2000069
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006B
	CP   R20,R17
	BRLO _0x200006C
_0x200006B:
	RJMP _0x200006A
_0x200006C:
	MOV  R17,R20
_0x200006A:
_0x2000064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006D
_0x2000069:
	CPI  R30,LOW(0x64)
	BREQ _0x2000070
	CPI  R30,LOW(0x69)
	BRNE _0x2000071
_0x2000070:
	ORI  R16,LOW(4)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0x75)
	BRNE _0x2000073
_0x2000072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x21
	LDI  R17,LOW(10)
	RJMP _0x2000075
_0x2000074:
	__GETD1N 0x2710
	CALL SUBOPT_0x21
	LDI  R17,LOW(5)
	RJMP _0x2000075
_0x2000073:
	CPI  R30,LOW(0x58)
	BRNE _0x2000077
	ORI  R16,LOW(8)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000B6
_0x2000078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x21
	LDI  R17,LOW(8)
	RJMP _0x2000075
_0x200007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x21
	LDI  R17,LOW(4)
_0x2000075:
	CPI  R20,0
	BREQ _0x200007B
	ANDI R16,LOW(127)
	RJMP _0x200007C
_0x200007B:
	LDI  R20,LOW(1)
_0x200007C:
	SBRS R16,1
	RJMP _0x200007D
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1B
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000110
_0x200007D:
	SBRS R16,2
	RJMP _0x200007F
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
	CALL __CWD1
	RJMP _0x2000110
_0x200007F:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
	CLR  R22
	CLR  R23
_0x2000110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000082
	CALL SUBOPT_0x1E
	CALL __ANEGD1
	CALL SUBOPT_0x1C
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000084
_0x2000083:
	ANDI R16,LOW(251)
_0x2000084:
_0x2000081:
	MOV  R19,R20
_0x200006D:
	SBRC R16,0
	RJMP _0x2000085
_0x2000086:
	CP   R17,R21
	BRSH _0x2000089
	CP   R19,R21
	BRLO _0x200008A
_0x2000089:
	RJMP _0x2000088
_0x200008A:
	SBRS R16,7
	RJMP _0x200008B
	SBRS R16,2
	RJMP _0x200008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008D
_0x200008C:
	LDI  R18,LOW(48)
_0x200008D:
	RJMP _0x200008E
_0x200008B:
	LDI  R18,LOW(32)
_0x200008E:
	CALL SUBOPT_0x17
	SUBI R21,LOW(1)
	RJMP _0x2000086
_0x2000088:
_0x2000085:
_0x200008F:
	CP   R17,R20
	BRSH _0x2000091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000092
	CALL SUBOPT_0x22
	BREQ _0x2000093
	SUBI R21,LOW(1)
_0x2000093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x2000094
	SUBI R21,LOW(1)
_0x2000094:
	SUBI R20,LOW(1)
	RJMP _0x200008F
_0x2000091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000095
_0x2000096:
	CPI  R19,0
	BREQ _0x2000098
	SBRS R16,3
	RJMP _0x2000099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009A
_0x2000099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009A:
	CALL SUBOPT_0x17
	CPI  R21,0
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R19,LOW(1)
	RJMP _0x2000096
_0x2000098:
	RJMP _0x200009C
_0x2000095:
_0x200009E:
	CALL SUBOPT_0x23
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	SUBI R18,-LOW(55)
	RJMP _0x20000A2
_0x20000A1:
	SUBI R18,-LOW(87)
_0x20000A2:
	RJMP _0x20000A3
_0x20000A0:
	SUBI R18,-LOW(48)
_0x20000A3:
	SBRC R16,4
	RJMP _0x20000A5
	CPI  R18,49
	BRSH _0x20000A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A6
_0x20000A7:
	RJMP _0x20000A9
_0x20000A6:
	CP   R20,R19
	BRSH _0x2000111
	CP   R21,R19
	BRLO _0x20000AC
	SBRS R16,0
	RJMP _0x20000AD
_0x20000AC:
	RJMP _0x20000AB
_0x20000AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000AE
_0x2000111:
	LDI  R18,LOW(48)
_0x20000A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000AF
	CALL SUBOPT_0x22
	BREQ _0x20000B0
	SUBI R21,LOW(1)
_0x20000B0:
_0x20000AF:
_0x20000AE:
_0x20000A5:
	CALL SUBOPT_0x17
	CPI  R21,0
	BREQ _0x20000B1
	SUBI R21,LOW(1)
_0x20000B1:
_0x20000AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x23
	CALL __MODD21U
	CALL SUBOPT_0x1C
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x21
	__GETD1S 16
	CALL __CPD10
	BREQ _0x200009F
	RJMP _0x200009E
_0x200009F:
_0x200009C:
	SBRS R16,0
	RJMP _0x20000B2
_0x20000B3:
	CPI  R21,0
	BREQ _0x20000B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1A
	RJMP _0x20000B3
_0x20000B5:
_0x20000B2:
_0x20000B6:
_0x2000054:
_0x200010F:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x24
	SBIW R30,0
	BRNE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0007
_0x20000B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x24
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_ds18b20_select:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	CALL _w1_init
	CPI  R30,0
	BRNE _0x2020003
	LDI  R30,LOW(0)
	RJMP _0x20C0005
_0x2020003:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2020004
	LDI  R26,LOW(85)
	CALL _w1_write
	LDI  R17,LOW(0)
_0x2020006:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R26,R30
	CALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2020006
	RJMP _0x2020008
_0x2020004:
	LDI  R26,LOW(204)
	CALL _w1_write
_0x2020008:
	LDI  R30,LOW(1)
	RJMP _0x20C0005
_ds18b20_read_spd:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2020009
	LDI  R30,LOW(0)
	RJMP _0x20C0006
_0x2020009:
	LDI  R26,LOW(190)
	CALL _w1_write
	LDI  R17,LOW(0)
	__POINTWRM 18,19,___ds18b20_scratch_pad
_0x202000B:
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	CALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x202000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	LDI  R31,HIGH(___ds18b20_scratch_pad)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	CALL _w1_dow_crc8
	CALL __LNEGB1
_0x20C0006:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
_ds18b20_temperature:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x202000D
	CALL SUBOPT_0x25
	RJMP _0x20C0005
_0x202000D:
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x202000E
	CALL SUBOPT_0x25
	RJMP _0x20C0005
_0x202000E:
	LDI  R26,LOW(68)
	CALL _w1_write
	MOV  R30,R17
	LDI  R26,LOW(_conv_delay_G101*2)
	LDI  R27,HIGH(_conv_delay_G101*2)
	CALL SUBOPT_0x26
	CALL __GETW2PF
	CALL _delay_ms
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x202000F
	CALL SUBOPT_0x25
	RJMP _0x20C0005
_0x202000F:
	CALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G101*2)
	LDI  R27,HIGH(_bit_mask_G101*2)
	CALL SUBOPT_0x26
	CALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	CALL SUBOPT_0x27
	__GETD2N 0x3D800000
	CALL __MULF12
_0x20C0005:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_ds18b20_init:
	ST   -Y,R26
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2020010
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x2020010:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R26,LOW(78)
	CALL _w1_write
	LDD  R26,Y+1
	CALL _w1_write
	LDD  R26,Y+2
	CALL _w1_write
	LD   R26,Y
	CALL _w1_write
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2020011
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x2020011:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2020013
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2020013
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2020012
_0x2020013:
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x2020012:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2020015
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x2020015:
	LDI  R26,LOW(72)
	CALL _w1_write
	LDI  R26,LOW(15)
	CALL SUBOPT_0x8
	CALL _w1_init
_0x20C0004:
	ADIW R28,5
	RET

	.CSEG

	.CSEG
_strcpyf:
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
	ST   -Y,R27
	ST   -Y,R26
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
	ST   -Y,R27
	ST   -Y,R26
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

	.CSEG
_ftrunc:
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0003:
	ADIW R28,4
	RET

	.CSEG
_ftoa:
	RCALL SUBOPT_0xA
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A000D
	RCALL SUBOPT_0x28
	__POINTW2FN _0x20A0000,0
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	RCALL SUBOPT_0x28
	__POINTW2FN _0x20A0000,1
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(45)
	ST   X,R30
_0x20A000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20A0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20A0010:
	LDD  R17,Y+8
_0x20A0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A0013
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x2C
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x2D
	CALL __ADDF12
	RCALL SUBOPT_0x29
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x2C
_0x20A0014:
	RCALL SUBOPT_0x2D
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x2C
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20A0017
	RCALL SUBOPT_0x28
	__POINTW2FN _0x20A0000,5
	CALL _strcpyf
	RJMP _0x20C0002
_0x20A0017:
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0018
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0019
_0x20A0018:
_0x20A001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001C
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x11
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x14
	LDI  R31,0
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x27
	CALL __MULF12
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x29
	RJMP _0x20A001A
_0x20A001C:
_0x20A0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A0020
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x29
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x14
	LDI  R31,0
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x29
	RJMP _0x20A001E
_0x20A0020:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_rom_codes:
	.BYTE 0x1B
_rx_buffer0:
	.BYTE 0x14
_tx_buffer0:
	.BYTE 0x14
_lcd_buffer:
	.BYTE 0x1E
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	JMP  _SendData

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R4
	LDI  R31,0
	ADIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	JMP  _SendData

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	MOV  R30,R4
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_rom_codes)
	SBCI R31,HIGH(-_rom_codes)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xB:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xC:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x18:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1B:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x18
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x1B
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x22:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD1N 0xC61C3C00
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x1B
	.equ __w1_bit=0x00

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_search:
	push r20
	push r21
	clr  r1
	clr  r20
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	push r26
	ld   r26,y
	rcall _w1_write
	pop  r26
	ldi  r21,1
__w1_search1:
	cp   r21,r0
	brsh __w1_search6
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search2
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search3
	rcall __sel_bit
	and  r24,r25
	brne __w1_search3
	mov  r1,r21
	rjmp __w1_search3
__w1_search2:
	rcall __w1_read_bit
__w1_search3:
	rcall __sel_bit
	and  r24,r25
	ldi  r23,0
	breq __w1_search5
__w1_search4:
	ldi  r23,1
__w1_search5:
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search6:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search9
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search8
__w1_search7:
	mov  r30,r20
	pop  r21
	pop  r20
	adiw r28,1
	ret
__w1_search8:
	set
	rcall __set_bit
	rjmp __w1_search4
__w1_search9:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search10
	rjmp __w1_search11
__w1_search10:
	cp   r21,r0
	breq __w1_search12
	mov  r1,r21
__w1_search11:
	clt
	rcall __set_bit
	clr  r23
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search12:
	set
	rcall __set_bit
	ldi  r23,1
	rcall __w1_write_bit
__w1_search13:
	inc  r21
	cpi  r21,65
	brlt __w1_search1
	rcall __w1_read_bit
	rol  r30
	rol  r30
	andi r30,1
	adiw r26,8
	st   x,r30
	sbiw r26,8
	inc  r20
	tst  r1
	breq __w1_search7
	ldi  r21,9
__w1_search14:
	ld   r30,x
	adiw r26,9
	st   x,r30
	sbiw r26,8
	dec  r21
	brne __w1_search14
	rjmp __w1_search0

__sel_bit:
	mov  r30,r21
	dec  r30
	mov  r22,r30
	lsr  r30
	lsr  r30
	lsr  r30
	clr  r31
	add  r30,r26
	adc  r31,r27
	ld   r24,z
	ldi  r25,1
	andi r22,7
__sel_bit0:
	breq __sel_bit1
	lsl  r25
	dec  r22
	rjmp __sel_bit0
__sel_bit1:
	ret

__set_bit:
	rcall __sel_bit
	brts __set_bit2
	com  r25
	and  r24,r25
	rjmp __set_bit3
__set_bit2:
	or   r24,r25
__set_bit3:
	st   z,r24
	ret

_w1_dow_crc8:
	clr  r30
	tst  r26
	breq __w1_dow_crc83
	mov  r24,r26
	ldi  r22,0x18
	ld   r26,y
	ldd  r27,y+1
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,2
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
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
