/* 
  4x4 Keypad Demo

  CodeVisionAVR C Compiler
  (C) 2000-2007 HP InfoTech S.R.L.
  www.hpinfotech.ro

  Chip: ATmega8515
  
  PLEASE MAKE SURE THAT THE CKSEL0..3 FUSE
  BITS ARE PROGRAMMED TO USE THE EXTERNAL
  CLOCK SOURCE OF THE STK500 AND NOT
  THE INTERNAL 1MHz OSCILLATOR.
  The ATmega8515 chip comes from the factory
  with CKSEL0..3 fuse bits set to use the
  internal 1 MHz oscillator.

  Connect the keypad matrix as follows:

DDRD=0xf0;        11110000
PORTD=0xff;     

  [STK500 PORTD HEADER]   [KEYS]  R1
  1 PD0 -----0----1----2----3----~~~~~---o+5V
             |    |    |    |     R2   |
  2 PD1 -----4----5----6----7----~~~~~-
             |    |    |    |     R3   |
  3 PD2 -----8----9----10---11---~~~~~-
             |    |    |    |     R4   |
  4 PD3 -----12---13---14---15---~~~~~-
         D1  |    |    |    |
  5 PD4 -|<|-     |    |    |
         D2       |    |    |
  6 PD5 -|<|------     |    |
         D3            |    |
  7 PD6 -|<|-----------     |  R1..R4=10k..47k
         D4                 |
  8 PD7 -|<|----------------   D1..D4=1N4148
   
  Use an 2x16 alphanumeric LCD connected
  to PORTC as follows:

  [LCD]   [STK500 PORTC HEADER]
   1 GND- 9  GND
   2 +5V- 10 VCC  
   3 VLC- LCD contrast control voltage 0..1V
   4 RS - 1  PC0
   5 RD - 2  PC1
   6 EN - 3  PC2
  11 D4 - 5  PC4
  12 D5 - 6  PC5
  13 D6 - 7  PC6
  14 D7 - 8  PC7
*/

#asm
    .equ __lcd_port=0x15
#endasm

#include <lcd.h>
#include <stdio.h>
#include <delay.h>
#include <mega8515.h>

// quartz crystal frequency [Hz]
#define F_XTAL 3686400L
// PIND0..3 will be row inputs
#define KEYIN PIND
// PORTD4..7 will be column outputs
#define KEYOUT PORTD
// used for TIMER0 count initialization
#define INIT_TIMER0 TCNT0=0x100L-F_XTAL/64L/500L
#define FIRST_COLUMN 0x80
#define LAST_COLUMN 0x10

typedef unsigned char byte;
// store here every key state as a bit,
// bit 0 will be KEY0, bit 1 KEY1,...
unsigned keys;
// LCD display buffer
char buf[33];

// TIMER 0 interrupt at every 2 ms
interrupt [TIM0_OVF] void timer0_int(void)
{
static byte key_pressed_counter=20;
static byte key_released_counter,column=FIRST_COLUMN;
static unsigned row_data,crt_key;
// reinitialize TIMER0
INIT_TIMER0;
row_data<<=4;
// get a group of 4 keys in in row_data
row_data|=~KEYIN&0xf;
column>>=1;
if (column==(LAST_COLUMN>>1))
   {
   column=FIRST_COLUMN;
   if (row_data==0) goto new_key;
   if (key_released_counter) --key_released_counter;
   else
      {
      if (--key_pressed_counter==9) crt_key=row_data;
      else
         {
         if (row_data!=crt_key)
            {
            new_key:
            key_pressed_counter=10;
            key_released_counter=0;
            goto end_key;
            };
         if (!key_pressed_counter)
            {
            keys=row_data;
            key_released_counter=20;
            };
         };
      };
   end_key:;
   row_data=0;
   };
// select next column, inputs will be with pull-up
KEYOUT=~column;
}

// test if a key was pressed
unsigned inkey(void)
{
unsigned k;
if (k=keys) keys=0;
return k;
}

void init_keypad(void)
{
// PORT D initialization
// Bits 0..3 inputs
// Bits 4..7 outputs
DDRD=0xf0;
// Use pull-ups on bits 0..3 inputs
// Output 1 on 4..7 outputs
PORTD=0xff;
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 57.600 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x03;
INIT_TIMER0;
OCR0=0x00;
// External Interrupts are off
MCUCR=0x00;
EMCUCR=0x00;
// Timer 0 overflow interrupt is on
TIMSK=0x02;
#asm("sei")
}

main() {
unsigned k;
init_keypad();
lcd_init(16);
lcd_putsf("CVAVR Keypad");
// read keys and display key code
while (1)
      {
      lcd_gotoxy(0,1);
      if (k=inkey())
         {
         sprintf(buf,"Key code=%Xh",k);
         lcd_puts(buf);
         }
      else lcd_putsf("NO KEY        ");
      delay_ms(500);
      }
}









#include <tiny2313.h>

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

      };
}