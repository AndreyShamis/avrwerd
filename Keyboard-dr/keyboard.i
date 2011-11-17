
void KEYB_Init(void);                  
void KEYB_ScanKeyboard(void);          
unsigned char KEYB_GetKey(void);       

#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

__flash unsigned char keyTable[][2] = { 
{((~(1<<4)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<0)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '1'},
{((~(1<<4)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<1)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '2'},
{((~(1<<4)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<2)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '3'},
{((~(1<<4)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<3)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), 'A'},

{((~(1<<5)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<0)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '4'},
{((~(1<<5)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<1)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '5'},
{((~(1<<5)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<2)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '6'}, 
{((~(1<<5)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<3)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), 'B'},  

{((~(1<<6)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<0)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '7'},
{((~(1<<6)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<1)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '8'},
{((~(1<<6)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<2)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '9'},    
{((~(1<<6)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<3)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), 'C'}, 

{((~(1<<7)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<0)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '*'},
{((~(1<<7)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<1)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '0'},
{((~(1<<7)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<2)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), '#'}, 
{((~(1<<7)&(((1<<4)|(1<<5)|(1<<6)|(1<<7))))|(~(1<<3)&(((1<<0)|(1<<1)|(1<<2)|(1<<3))))), 'D'} 
};

unsigned char keyState = 0;

unsigned char keyCode;

volatile unsigned char keyValue;

unsigned char keyDown;

volatile unsigned char keyNew;

unsigned char KEYB_AnyKey(void);
unsigned char KEYB_SameKey(void);
void KEYB_ScanKey(void);
void KEYB_FindKey(void);
void KEYB_ClearKey(void);

void KEYB_Init(void)
{

keyState = 0;
keyCode = 0;
keyValue = 0;
keyDown = 0;
keyNew = 0;
}

void KEYB_ScanKeyboard(void)
{
unsigned char buf[4];
buf[0] = DDRB;
buf[1] = PORTB;
buf[2] = DDRA;
buf[3] = PORTA;

DDRA &= ~((1<<4)|(1<<5)|(1<<6)|(1<<7));
PORTA |= ((1<<4)|(1<<5)|(1<<6)|(1<<7));

DDRB |= ((1<<0)|(1<<1)|(1<<2)|(1<<3)); 
PORTB &= ~((1<<0)|(1<<1)|(1<<2)|(1<<3));

switch (keyState){
case 0: {
if (KEYB_AnyKey()) {
KEYB_ScanKey();
keyState = 1;
}
}
break;

case 1: {
if (KEYB_SameKey()) {
KEYB_FindKey();
keyState = 2;   
}
else keyState = 0;
}
break;

case 2: {
if (KEYB_SameKey()) {}
else keyState = 3;
}
break;

case 3: {
if (KEYB_SameKey()) {
keyState = 2;
}
else {
KEYB_ClearKey();
keyState = 0;
}
}
break;

default:
break;
}

DDRB = buf[0];
PORTB = buf[1];
DDRA = buf[2];    
PORTA = buf[3];
}

unsigned char KEYB_AnyKey(void) 
{  
PORTB &= ~((1<<0)|(1<<1)|(1<<2)|(1<<3));
delay_us(5);
return (~PINA & ((1<<4)|(1<<5)|(1<<6)|(1<<7)));
}

unsigned char KEYB_SameKey(void) 
{
PORTB &= ~((1<<0)|(1<<1)|(1<<2)|(1<<3));
PORTB |= (keyCode & ((1<<0)|(1<<1)|(1<<2)|(1<<3)));
return ((~keyCode & ((1<<4)|(1<<5)|(1<<6)|(1<<7)))&(~PINA));
}

void KEYB_ScanKey(void) 
{
unsigned char i;
for(i = 0; i<4; i++){
PORTB |= ((1<<0)|(1<<1)|(1<<2)|(1<<3));
if (i == 0) PORTB &= ~(1<<0);
if (i == 1) PORTB &= ~(1<<1);
if (i == 2) PORTB &= ~(1<<2);
if (i == 3) PORTB &= ~(1<<3);
delay_us(5);
if (~PINA & ((1<<4)|(1<<5)|(1<<6)|(1<<7))) {
keyCode = PINA & ((1<<4)|(1<<5)|(1<<6)|(1<<7));
keyCode |= PORTB & ((1<<0)|(1<<1)|(1<<2)|(1<<3));
return;
}
}
}

void KEYB_FindKey(void) 
{
unsigned char index;
for (index = 0; index < 16; index++) {
if (keyTable [index][0] == keyCode) {
keyValue = keyTable [index][1];
keyDown = 1;
keyNew = 1;
return;
}
}
}

void KEYB_ClearKey(void) 
{
keyDown = 0;
}

unsigned char KEYB_GetKey(void)
{
if (keyNew){
keyNew = 0;
return keyValue;
}
else 
return 0;
}

