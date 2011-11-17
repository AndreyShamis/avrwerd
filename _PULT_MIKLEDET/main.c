/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/25/2011
Author  : NeVaDa
Company : WERD
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>

#include <delay.h>

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


// PIND0..3 will be row inputs
#define KEYIN PINB
// PORTD4..7 will be column outputs
#define KEYOUT PORTB
#define F_XTAL 4000000L

// used for TIMER0 count initialization
#define INIT_TIMER TCNT0=0x100L-F_XTAL/64L/500L
//#define INIT_TIMER TCNT0=0x10L
#define FIRST_COLUMN 0x80
#define LAST_COLUMN 0x20


void init_keypad(void);
char inkey();

 char keys;

 void GetButton(char val)
{

      
    if(!PINB.0)
        keys =  1+val;
    else if(!PINB.1)  
        keys =  2+val;
    else  if(!PINB.2)  
        keys =  3+val;
    else  if(!PINB.3)  
        keys =  4+val;
    else  if(!PINB.4)  
        keys =  5+val;
    else  
     keys =  0;
}
// TIMER 0 interrupt at every 2 ms
interrupt [TIM0_OVF] void timer0_int(void){
        

 /*

    static unsigned char key_pressed_counter = 20;
    static unsigned char key_released_counter,
                    column=FIRST_COLUMN;
    static unsigned row_data,
                    crt_key;
    // reinitialize TIMER0
    INIT_TIMER;
    row_data<<=3;
    // get a group of 4 keys in in row_data
    row_data|=~KEYIN&0xf1;
    column>>=1;
    if (column==(LAST_COLUMN>>1))
    {
        column=FIRST_COLUMN;
        if (row_data==0) 
                goto new_key;
        if (key_released_counter) 
                --key_released_counter;
        else
        {
          if (--key_pressed_counter==9) 
                crt_key=row_data;
          else
          {
             if (row_data!=crt_key)
             {
                new_key:
                key_pressed_counter=10;
                key_released_counter=0;
                goto end_key;
             };
             if(!key_pressed_counter)
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
    */ 
     
      
    
//     #asm("cli")
//    keys=0;
    if(keys==0)
    {    
    PORTB.5 = 0;
    GetButton(0);
    PORTB.5 = 1;
    }              
    if(keys==0)
    {
    PORTB.6 = 0;    
    GetButton(5);
    PORTB.6 = 1;
    }   
    
    if(keys==0)
    {   
    PORTB.7 = 0;  
    GetButton(10);
    PORTB.7 = 1;   
    }   

        #asm("sei") 
        
}




//============================================================================
//      Main Function
void main(void)
{

    char k;
    // Crystal Oscillator division factor: 1
    #pragma optsize-
//    CLKPR=0x80;
//    CLKPR=0x00;
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif


    PORTA=0x00;
    DDRA=0x00;

    PORTD=0xFF;
    DDRD=0x02;
    DDRB=0xE0;
    PORTB=0xFF;
    keys = 0;
   /*
    TCCR0A=0x00;
    TCCR0B=0x00;
    TCNT0=0x00;
    OCR0A=0x00;
    OCR0B=0x00;

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

    GIMSK=0x00;
    MCUCR=0x00;

    TIMSK=0x00;

    USICR=0x00;

    ACSR=0x80;
    */
        UCSRA=0x00;
        UCSRB=0xD8;
        UCSRC=0x06;
        UBRRH=0x00;
        UBRRL=0x33;   
    


 init_keypad(); 
    k=inkey();
    putchar(k); 
    while (1)
    {
        // Place your code here 
        #pragma warn-
        if (k=inkey())
        {
            putchar(k);    
        }   
        #pragma warn+

        delay_ms(400);

    };
}


char inkey()
{
    unsigned char k;
 //   #pragma warn-
   // if (k=keys) keys=0;     
   // INIT_TIMER; 
     if(keys==0)
    {    
    PORTB.5 = 0;
    GetButton(0);
    PORTB.5 = 1;
    }              
    if(keys==0)
    {
    PORTB.6 = 0;    
    GetButton(5);
    PORTB.6 = 1;
    }   
    
    if(keys==0)
    {   
    PORTB.7 = 0;  
    GetButton(10);
    PORTB.7 = 1;   
    }  
    k=keys;
        keys=0;
    return k;
}

void init_keypad(void)
{
    DDRB=0xE0;
    PORTB=0xFF;
    keys = 0;
    // Mode: Normal top=FFh
    // OC0 output: Disconnected
    TCCR0=0x03;
    INIT_TIMER;

    // External Interrupts are off
    MCUCR=0x00;
    //EMCUCR=0x00;
    // Timer 0 overflow interrupt is on
    TIMSK=0x02;
    #asm("sei")
}