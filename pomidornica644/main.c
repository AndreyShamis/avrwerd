/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Professional
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/6/2012
Author  : user
Company : home
Comments: 


Chip type               : ATmega644
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/
#include <mega644.h>
#include <delay.h>
#include <stdio.h>      // Standard Input/Output functions
//#include <1wire.h>    // 1 Wire Bus interface functions
#include <ds18b20.h>    // DS1820 Temperature Sensor functions
//=======================================================================================
//                          DEFINE SECTION

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


#define CONTROL_FAN_OBDUV       PORTA.0
#define CONTROL_FAN_VIDUV       PORTA.1
#define CONTROL_LIGHT           PORTA.2

#define RX_BUFFER_SIZE0 20              // USART0 Receiver buffer
#define TX_BUFFER_SIZE0 20              // USART0 Transmitter buffer
#define MAX_DEVICES 3                   // maximum number of DS1820 devices connected to the 1 Wire bus
#define DELAY_TIME 100
//=======================================================================================
//                  GLOBAL VARIABLES SECTOION
unsigned char devices;                      // number of DS1820 devices connected to the 1 Wire bus
unsigned char rom_codes[MAX_DEVICES][9];    // DS1820 devices ROM code storage area,

bit rx_buffer_overflow0;                    // This flag is set on USART0 Receiver buffer overflow
char rx_buffer0[RX_BUFFER_SIZE0];
char tx_buffer0[TX_BUFFER_SIZE0];

char lcd_buffer[30];
unsigned char i,j;

//===========================
#if RX_BUFFER_SIZE0 <= 256
unsigned char   rx_wr_index0,
                rx_rd_index0,
                rx_counter0;
#else
unsigned int    rx_wr_index0,
                rx_rd_index0,
                rx_counter0;
#endif

//===========================
#if TX_BUFFER_SIZE0 <= 256
unsigned char   tx_wr_index0,
                tx_rd_index0,
                tx_counter0;
#else
unsigned int    tx_wr_index0,
                tx_rd_index0,
                tx_counter0;
#endif


//=======================================================================================
// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart_rx_isr(void)
{
    char    status,
            data; 
            
    status  =   UCSR0A;
    data    =   UDR0; 
    
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
    {   
        rx_buffer0[rx_wr_index0++]  =   data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
        rx_counter0         =   0;
        rx_buffer_overflow0 =   1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
//=======================================================================================
char getchar(void)
{
    char data;
    while (rx_counter0==0);
    data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
    if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
    --rx_counter0;
#asm("sei")
    return data;
}
#pragma used-
#endif

//=======================================================================================
// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart_tx_isr(void)
{
    if (tx_counter0)
    {
        --tx_counter0;
        UDR0=tx_buffer0[tx_rd_index0++];
        #if TX_BUFFER_SIZE0 != 256
        if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
        #endif
    }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+

//=======================================================================================
void putchar(char c)
{
    while (tx_counter0 == TX_BUFFER_SIZE0);
    #asm("cli")
    if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
    {
        tx_buffer0[tx_wr_index0++]=c;
        #if TX_BUFFER_SIZE0 != 256
        if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
        #endif
        ++tx_counter0;
    }
    else
        UDR0=c;
    #asm("sei")
}
#pragma used-
#endif

//=======================================================================================
void SendData(char *data);
void InitilizeMC();

void main(void)
{

    // Declare your local variables here
    InitilizeMC();

    delay_ms(5000);
    w1_init();
    devices=w1_search(DS18B20_SEARCH_ROM_CMD,rom_codes);
    // Global enable interrupts
    #asm("sei")

    CONTROL_FAN_OBDUV   = 0;    
    CONTROL_FAN_VIDUV   = 0;
    CONTROL_LIGHT       = 0;  
    if (devices)
    {
        sprintf(lcd_buffer,"Found %u devices\n.",devices);
        SendData(lcd_buffer);
        for (i=0;i<devices;i++)
        {
           sprintf(lcd_buffer,"Dev %u. ",i+1);
           SendData(lcd_buffer);
           delay_ms(10);

           for (j=0;j<8;j++)
               {
               sprintf(lcd_buffer,"%02X ",rom_codes[i][j]);
               SendData(lcd_buffer);
               }
           delay_ms(10);
        }
    }
    else
    {
        sprintf(lcd_buffer,"Not Founded");
        SendData(lcd_buffer);
    }
     
    for (i=0;i<devices;i++)
    {
        if (!ds18b20_init(&rom_codes[i][0],12,39,DS18B20_12BIT_RES))//DS18B20_12BIT_RES
        {
           sprintf(lcd_buffer," Init err %u .",i);
           SendData(lcd_buffer);
        }  
        delay_ms(100);   
    }
  

    while (1)
    {  
        j=1;
        for (i=0;i<devices;i++)
        {
          sprintf(lcd_buffer,"T%d:%.2f \xefC. ",i+1,ds18b20_temperature(&rom_codes[i][0]));

          SendData(lcd_buffer);
          delay_ms(10);
        }

        PORTB.0 = 0;   
                           
        if (rx_buffer0[0]== 'E')
        {  
            sprintf(lcd_buffer,"Pressed  E"); 
            SendData(lcd_buffer); 
            rx_buffer0[0]='C' ;  
            //PORTB.0 = 1;
            delay_ms(DELAY_TIME*2);    
                     
        }
        CONTROL_FAN_OBDUV = 1;    
        CONTROL_FAN_VIDUV = 0;
        CONTROL_LIGHT = 0;
        delay_ms(DELAY_TIME);  
        CONTROL_FAN_OBDUV = 0;    
        CONTROL_FAN_VIDUV = 1;
        CONTROL_LIGHT = 0;
        delay_ms(DELAY_TIME);
        CONTROL_FAN_OBDUV = 0;    
        CONTROL_FAN_VIDUV = 0;
        CONTROL_LIGHT = 1;
        delay_ms(DELAY_TIME);    
        CONTROL_FAN_OBDUV = 0;    
        CONTROL_FAN_VIDUV = 0;
        CONTROL_LIGHT = 0;
        delay_ms(DELAY_TIME);  
        CONTROL_FAN_OBDUV = 1;    
        CONTROL_FAN_VIDUV = 1;
        CONTROL_LIGHT = 0;
        delay_ms(DELAY_TIME); 
        CONTROL_FAN_OBDUV = 1;    
        CONTROL_FAN_VIDUV = 0;
        CONTROL_LIGHT = 1;
        delay_ms(DELAY_TIME); 
        CONTROL_FAN_OBDUV = 1;    
        CONTROL_FAN_VIDUV = 1;
        CONTROL_LIGHT = 1;
        delay_ms(DELAY_TIME);     
        // }
        //putchar('C'); 

        //PORTB.0 = 1;
        delay_ms(DELAY_TIME);    
    }
}


//=======================================================================================
void SendData(char *data)
{
    while(*data != 0)
    {
        putchar(*(data++));
        delay_ms(1);
    }
}
//=======================================================================================
void InitilizeMC()
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
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out 
    // State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0 
    PORTA=0x00;
    DDRA=0x07;

    // Port B initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTB=0x00;
    DDRB=0x00;

    // Port C initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTC=0x00;
    DDRC=0x00;

    // Port D initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=T 
    PORTD=0x00;
    DDRD=0x02;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=0xFF
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
    // Mode: Normal top=0xFFFF
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

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer2 Stopped
    // Mode: Normal top=0xFF
    // OC2A output: Disconnected
    // OC2B output: Disconnected
    ASSR=0x00;
    TCCR2A=0x00;
    TCCR2B=0x00;
    TCNT2=0x00;
    OCR2A=0x00;
    OCR2B=0x00;

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    // Interrupt on any change on pins PCINT0-7: Off
    // Interrupt on any change on pins PCINT8-15: Off
    // Interrupt on any change on pins PCINT16-23: Off
    // Interrupt on any change on pins PCINT24-31: Off
    EICRA=0x00;
    EIMSK=0x00;
    PCICR=0x00;

    // Timer/Counter 0 Interrupt(s) initialization
    TIMSK0=0x00;

    // Timer/Counter 1 Interrupt(s) initialization
    TIMSK1=0x00;

    // Timer/Counter 2 Interrupt(s) initialization
    TIMSK2=0x00;

    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART0 Mode: Asynchronous
    // USART Baud Rate: 9600
    UCSR0A=0x00;
    UCSR0B=0xD8;
    UCSR0C=0x06;
    UBRR0H=0x00;
    UBRR0L=0x33;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    ADCSRB=0x00;
    DIDR1=0x00;

    // ADC initialization
    // ADC disabled
    ADCSRA=0x00;

    // SPI initialization
    // SPI disabled
    SPCR=0x00;

    // TWI initialization
    // TWI disabled
    TWCR=0x00;

}