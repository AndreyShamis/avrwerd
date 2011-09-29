//=============================================================================
//=============================================================================
/*
	Andrey Shamis
*/
//=============================================================================
//=============================================================================

#include <avr/io.h>
#include <inttypes.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>  // для sei() 
#include <util/delay.h>    // для _delay_ms() 

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "therm_ds18b20.h"

char ch = 0;
int t;
int start =0 ;
int l=0;
int h=0;

#include <avr/pgmspace.h>   // нужен для usbdrv.h 
#include "usbdrv/usbdrv.h"
#include "requests.h"       // номера custom request, используемые нами 
#include "avr_compat.h"
#include "lcd_lib.h" 
//=============================================================================
//=============================================================================
//=============================================================================

#define DEL_START           5//*8  //  delay leds start
#define DEL_CYCLE           5//*8  //  delay in each cycle        
#define MAX_COMMAND_SIZE    6   //  Max command size

#define BUFF_SIZE           17

#define btn1 1
#define btn2 3
#define btn3 5
#define btn4 4
#define led1 0	//PORTC0
#define led2 2	//PORTC2
#define led3 6	//PORTC6
#define led4 7	//PORTC7

//#define PortaBits (*((volatile Bits*)&PORTA))
//#define LedPin PortaBits.Bit5


#define C_DRIVE_VECTOR_Y_UP		1
#define C_DRIVE_VECTOR_Y_DOWN	2
//=============================================================================
//=============================================================================



//  Function For 
void DoCommand(long *comm);
void DisableLeds(void);
static uchar    currentAddress;
static uchar    bytesRemaining;
struct MashineStatus
{
	char	C_napravlenie;
	char	C_povorot;	
	char	C_OverControl;

};

static struct MashineStatus _mashine;

//=============================================================================
// usbFunctionWrite()  usbdrv/usbdrv.h. 
uchar   usbFunctionWrite(uchar *data, uchar len);
//=============================================================================
// usbFunctionRead() usbdrv/usbdrv.h.
uchar   usbFunctionRead(uchar *data, uchar len);
//=============================================================================
// Дескриптор выше - только макет, это заглушает драйверы. Репорт, который его 
//   описывает, состоит из одного байта неопределенных данных. Мы не передаем
//   наши данные через HID-репорты, вместо этого мы используем custom-запросы.
// ------------------------------------------------------------------------- 
usbMsgLen_t usbFunctionSetup(uchar data[8]);

//=============================================================================
//=============================================================================
// ----------------------------- интерфейс USB ----------------------------- 

PROGMEM char usbHidReportDescriptor[22] = {    // дескриптор репорта USB 
    0x06, 0x00, 0xff,              // USAGE_PAGE (Generic Desktop)
    0x09, 0x01,                    // USAGE (Vendor Usage 1)
    0xa1, 0x01,                    // COLLECTION (Application)
    0x15, 0x00,                    //   LOGICAL_MINIMUM (0)
    0x26, 0xff, 0x00,              //   LOGICAL_MAXIMUM (255)
    0x75, 0x08,                    //   REPORT_SIZE (8)
    0x95, 0x01,                    //   REPORT_COUNT (1)
    0x09, 0x00,                    //   USAGE (Undefined)
    0xb2, 0x02, 0x01,              //   FEATURE (Data,Var,Abs,Buf)
    0xc0                           // END_COLLECTION
};

//=============================================================================
//=============================================================================
//=============================================================================
int main(void)
{
    char command[MAX_COMMAND_SIZE];
    long  	prev_comm		=	0;
    int 	command_pos 	= 	0;
    int 	del_size 		= 	DEL_CYCLE;
	int 	lcd_update_time	=	30;

	PORTA	=	0x00;
	DDRA	=	0xff;
	PORTB	=	0x01;
	DDRB	=	0x01;
	DDRC	=	0xC5;
	PORTC	=	0xC4;
	DDRD 	= 	0x7B;
	PORTD	=	0x7B;

	GICR	|=0x40;
	MCUCR	=0x00;
	EMCUCR	=0x00;
	GIFR	=0x40;
	TIMSK	=0x00;

	ACSR	=0x80;
	SFIOR	=0x00;




	//uchar   i;

    usbInit();
    usbDeviceDisconnect();  /* принудительно запускаем ре-энумерацию, делайте это, когда прерывания запрещены! */
	LCDinit();
    usbDeviceConnect();
    sei();


	LCDcursorOFF();
	LCDclr();
	LCDGotoXY(3,0);
	LCDprint("Starting...",11);
	memset(command,' ',MAX_COMMAND_SIZE);
   	char buff[BUFF_SIZE];
	int i=0;
	char x[20] = {0};
	for(;;){
        usbPoll();

		i = (i+1)%10;

		if(i == 5)
		{

			therm_read_temperature(x);
			t=tempra();
			if (start==0)
			{
				l=t;
				h=t;
			}
	        start=10;
			if(t>h){h=t;}
	        if(t<l){l=t;}
		    LCDGotoXY(0,0);
			sprintf(buff,"T%s[%x]h %x l %x",x,t,h,l);
			LCDprint(buff,sizeof(buff));		
			//	lcd_string2("T=%s[%x]\nh %x l %x",x,t,h,l);
	   		t=tempra();
	   		//int tt;
			//for (tt=0;tt<5;tt++) //some delay
			//	_delay_ms(100);
			if (i%2)
			{
				PORTB |= 1;
			}
			else
			{
				PORTB &= 0xFE;
			}
		}

        if(command_pos < MAX_COMMAND_SIZE  && (bit_is_clear(PINC,btn1) || bit_is_clear(PINC,btn2) || bit_is_clear(PINC,btn3)))
		{
			_delay_ms(del_size*10);
			if(bit_is_clear(PINC,btn1) && bit_is_clear(PINC,btn2))
				command[command_pos] = '4';
			else if(bit_is_clear(PINC,btn1) && bit_is_clear(PINC,btn3))
				command[command_pos] = '5';
			else if(bit_is_clear(PINC,btn2) && bit_is_clear(PINC,btn3))
				command[command_pos] = '6';
            else if(bit_is_clear(PINC,btn1))
                command[command_pos] = '1';
            else if(bit_is_clear(PINC,btn2))
                command[command_pos] = '2';
            else
                command[command_pos] = '3';
				
            command_pos++;  
			LCDGotoXY(0,0);
			LCDprint(command,sizeof(command));
			_delay_ms(del_size*30);
        }                 
               
        if(lcd_update_time >= 10)
		{
                DoCommand(&prev_comm);
				lcd_update_time = 0;

		}
		else
		{
			lcd_update_time++;
		}

        if(bit_is_clear(PINC,btn4))
		{               
			LCDclr();
            prev_comm=  atol(command);
            DoCommand(&prev_comm);    
            memset(command,' ',MAX_COMMAND_SIZE);
            command_pos = 0;  
            _delay_ms(del_size*30);
        }

    }
    return 0;
}


//=============================================================================
//  Function For 
void DoCommand(long *comm)
{    
    char buff[BUFF_SIZE];
    LCDGotoXY(0,1);
    memset(buff,' ',BUFF_SIZE);
    switch(*comm)  
    {
        case 3333:sprintf(buff,"PRAMO %d-%d-%d",_mashine.C_napravlenie,_mashine.C_povorot,_mashine.C_OverControl);
                	break;
        case 1: _mashine.C_napravlenie = C_DRIVE_VECTOR_Y_UP;
				PORTC |= _BV(0);
				*comm = 3333;
                break;
        case 2: _mashine.C_napravlenie = C_DRIVE_VECTOR_Y_DOWN;
				*comm = 3333;
                break;
        case 3: _mashine.C_napravlenie = 0;
				*comm = 3333;
                break;
        case 11: sprintf(buff,"PA-%d:PB-%d",PINA,PINB);
                break;
        case 12: sprintf(buff,"PC-%d:PD-%d",PINC,PIND);
                break;
 
        case 13:sprintf(buff,"EECR-%d:EEARH-%d",EECR,EEARH);
                break;
        case 21:sprintf(buff,"CR-%d:CSR-%d",MCUCR,MCUCSR);  
                break;
        case 22:sprintf(buff,"SPH-%d:SPL-%d",SPH,SPL);
                break;
        case 23:sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR); 
                break;
        case 31:sprintf(buff,"ACSR%d:OSAL%d",ACSR,OSCCAL);  
                break;

        case 33:sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR); 
                break; 
        case 111:sprintf(buff,"UBRRH%d:UCSRC%d",UBRRH,UCSRC); 
                break;
        case 122:sprintf(buff,"SREG-%d:SPH-%d",SREG,SPH); 
                break;  
        case 61:sprintf(buff,"EECR%d:EEARH%d",EECR,EEARH);
                break;
        case 589:sprintf(buff,"Error On Temp.");
                break;
        default:sprintf(buff,"Comm %ld",*comm); 
    }  
    LCDprint(buff,sizeof(buff));
/*
	if(_mashine.C_napravlenie == C_DRIVE_VECTOR_Y_UP)
	{
        PORTD |= _BV(1);
		PORTD &= ~_BV(0);
	}
	else if(_mashine.C_napravlenie == C_DRIVE_VECTOR_Y_DOWN)
	{

        PORTD |= _BV(0);
		PORTD &= ~_BV(1);
	}
	else
	{
		PORTD &= ~_BV(0);
		PORTD &= ~_BV(1);
	}
  */  
}

//=============================================================================
// Дескриптор выше - только макет, это заглушает драйверы. Репорт, который его 
//  описывает, состоит из одного байта неопределенных данных. Мы не передаем
//  наши данные через HID-репорты, вместо этого мы используем custom-запросы.
usbMsgLen_t usbFunctionSetup(uchar data[8])
{
	usbRequest_t    *rq = (void *)data;
	char mema[12];
	memcpy(mema,data,12);

    if((rq->bmRequestType & USBRQ_TYPE_MASK) == USBRQ_TYPE_VENDOR)
	{
        if(rq->bRequest == CUSTOM_RQ_SET_STATUS)
		{
            if(rq->wValue.bytes[0] & 1)
                PORTC |= _BV(0);
            else
				PORTC &= ~_BV(0);
        }
		else if(rq->bRequest == CUSTOM_RQ_SET_STATUS10)
		{
            if(rq->wValue.bytes[0] & 1)
                PORTC |= _BV(2);
            else
				PORTC &= ~_BV(2);
        }
		else if(rq->bRequest == CUSTOM_RQ_GET_STATUS)
		{
            static uchar dataBuffer[1];     // буфер должен оставаться валидным привыходе из usbFunctionSetup 
            dataBuffer[0] = bit_is_set(PORTC,0);//((LED_PORT_OUTPUT & _BV(LED_BIT)) != 0);
            usbMsgPtr = dataBuffer;         // говорим драйверу, какие данные вернуть 
            return 1;                       // говорим драйверу послать 1 байт 
        }
		else if(rq->bRequest == 6)
		{
				LCDclr();
				LCDGotoXY(0,0);	
				LCDprint(mema,32);		
				//LCDGotoXY(0,1);	
				//LCDstring(rq->wValue.word,32);					
		}
    }
	else if((rq->bmRequestType & USBRQ_TYPE_MASK) == USBRQ_TYPE_CLASS){    //HID class 
        if(rq->bRequest == USBRQ_HID_GET_REPORT){  // wValue: ReportType (highbyte), ReportID (lowbyte)       
            bytesRemaining = 128;
            currentAddress = 0;
            return USB_NO_MSG;  
        }else if(rq->bRequest == USBRQ_HID_SET_REPORT){
            bytesRemaining = 128;
            currentAddress = 0;
            return USB_NO_MSG;  
        }
    }
    return 0;   // default для нереализованных запросов: не возвращаем назад данные хосту 
}

//=============================================================================
// usbFunctionRead() usbdrv/usbdrv.h.

uchar   usbFunctionRead(uchar *data, uchar len)
{
	PORTC |= _BV(0);
    if(len > bytesRemaining)
        len = bytesRemaining;
    //eeprom_read_block(data, (uchar *)0 + currentAddress, len);
//	memset(data,'A',5);
    currentAddress += len;
    bytesRemaining -= len;
    return len;
}

//=============================================================================
// usbFunctionWrite()  usbdrv/usbdrv.h. 

uchar   usbFunctionWrite(uchar *data, uchar len)
{
	PORTC |= _BV(0);
    if(bytesRemaining == 0)
        return 1;              
    if(len > bytesRemaining)
        len = bytesRemaining;
//				LCDclr();
//				LCDGotoXY(0,0);	
//				LCDprint(data,len);
    //eeprom_write_block(data, (uchar *)0 + currentAddress, len);
    currentAddress += len;
    bytesRemaining -= len;
    return bytesRemaining == 0; 
}

//=============================================================================
//  Function For disable all leds on PORTC
void DisableLeds(void)
{    
    //led1 &=~_BV(0);//=0;
    //PORTC0 =0;
	//sbi(PORTC,0);
	//led2 |= _BV(1);//=1;
    //led3 |= _BV(1);//=1;
    //led4 |= _BV(1);// =1;
    
	PORTC=0xC4;
}
//=============================================================================
//=============================================================================
//=============================================================================

/*
typedef struct Bits_t
{
	uint8_t Bit0 :1;
	uint8_t Bit1 :1;
	uint8_t Bit2 :1;
	uint8_t Bit3 :1;
	uint8_t Bit4 :1;
	uint8_t Bit5 :1;
	uint8_t Bit6 :1;
	uint8_t Bit7 :1;
}Bits;
#define PortaBits (*((volatile Bits*)&PORTA))
#define LedPin PortaBits.Bit5
int main()
{
	DDRA = 1 << 5;
	while(1)
	{
		LedPin = 1;//?????? 
		_delay_ms(100);
		LedPin = 0;//?????????
*/

//=============================================================================
