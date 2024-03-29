/*****************************************************
Chip type               : ATmega162V
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega162.h>
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


#define CONTROL_FAN_OBDUV       PORTC.0
#define CONTROL_FAN_VIDUV       PORTC.1
#define CONTROL_LIGHT           PORTC.2

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
interrupt [USART0_RXC] void usart0_rx_isr(void)
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
interrupt [USART0_TXC] void usart0_tx_isr(void)
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

//=======================================================================================
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
            PORTB.0 = 1;
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

        PORTB.0 = 1;
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
    // Crystal Oscillator division factor: 1
    #pragma optsize-
    CLKPR=0x80;
    CLKPR=0x00;
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    PORTA=0x00;
    DDRA=0xFF;
    PORTB=0xFF;
    DDRB=0x01;
    PORTC=0xFF;
    DDRC=0xFF;
    PORTD=0xEF;
    DDRD=0x12;
    PORTE=0x00;
    DDRE=0x00;



    // Timer/Counter 0 initialization  Clock source: System Clock
    // Clock value: Timer 0 Stopped    Mode: Normal top=0xFF
    // OC0 output: Disconnected
    TCCR0=0x00;
    TCNT0=0x00;
    OCR0=0x00;

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
    // OC2 output: Disconnected
    ASSR=0x00;
    TCCR2=0x00;
    TCNT2=0x00;
    OCR2=0x00;

    // Timer/Counter 3 initialization
    // Clock value: Timer3 Stopped
    // Mode: Normal top=0xFFFF
    // OC3A output: Discon.
    // OC3B output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer3 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR3A=0x00;
    TCCR3B=0x00;
    TCNT3H=0x00;
    TCNT3L=0x00;
    ICR3H=0x00;
    ICR3L=0x00;
    OCR3AH=0x00;
    OCR3AL=0x00;
    OCR3BH=0x00;
    OCR3BL=0x00;

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    // Interrupt on any change on pins PCINT0-7: Off
    // Interrupt on any change on pins PCINT8-15: Off
    MCUCR=0x00;
    EMCUCR=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;

    ETIMSK=0x00;

    // USART0 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART0 Receiver: On
    // USART0 Transmitter: On
    // USART0 Mode: Asynchronous
    // USART0 Baud Rate: 9600
    UCSR0A=0x00;
    UCSR0B=0xD8;
    UCSR0C=0x86;
    UBRR0H=0x00;
    UBRR0L=0x33;   //06

    // USART1 initialization
    // USART1 disabled
    UCSR1B=0x00;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;

    // SPI initialization  // SPI disabled
    SPCR=0x00;
}