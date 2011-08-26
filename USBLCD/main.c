
/*
Этот пример должен работать на большинстве AVR с минимальными изменениями. Не используются
никакие аппаратные ресурсы микроконтроллера, за исключением INT0. Вы можете поменять 
usbconfig.h для использования других ножек I/O USB. Пожалуйста помните, что USB D+ должен
быть подсоединен на ножку INT0, или также как минимум быть соединенным с INT0.
Мы предполагаем, что LED подсоединен к порту B, бит 0. Если Вы подсоединили его на
другой порт или бит, поменяйте макроопределение ниже:
*/


#include <avr/io.h>
#include <inttypes.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>  /* для sei() */
#include <util/delay.h>     /* для _delay_ms() */

 
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <avr/pgmspace.h>   /* нужен для usbdrv.h */
#include "usbdrv/usbdrv.h"
#include "requests.h"       /* номера custom request, используемые нами */
#include "avr_compat.h"
#include "lcd_lib.h" 
  
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

/* ------------------------------------------------------------------------- */
/* ----------------------------- интерфейс USB ----------------------------- */
PROGMEM char usbHidReportDescriptor[22] = {    /* дескриптор репорта USB */
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
/* Дескриптор выше - только макет, это заглушает драйверы. Репорт, который его 
 *  описывает, состоит из одного байта неопределенных данных. Мы не передаем
 *  наши данные через HID-репорты, вместо этого мы используем custom-запросы.*/
/* ------------------------------------------------------------------------- */
usbMsgLen_t usbFunctionSetup(uchar data[8])
{
	usbRequest_t    *rq = (void *)data;
	char mema[32];
	memcpy(mema,data,32);

    if((rq->bmRequestType & USBRQ_TYPE_MASK) == USBRQ_TYPE_VENDOR)
	{
        if(rq->bRequest == CUSTOM_RQ_SET_STATUS){
				LCDclr();
				LCDGotoXY(0,1);
            if(rq->wValue.bytes[0] & 1)
                PORTC |= _BV(0);
            else
				PORTC &= ~_BV(0);
        }
		else if(rq->bRequest == CUSTOM_RQ_SET_STATUS10){
            if(rq->wValue.bytes[0] & 1)
                PORTC |= _BV(2);
            else
				PORTC &= ~_BV(2);
        }
		else if(rq->bRequest == CUSTOM_RQ_GET_STATUS){
            static uchar dataBuffer[1];     /* буфер должен оставаться валидным привыходе из usbFunctionSetup */
            dataBuffer[0] = bit_is_set(PORTC,0);//((LED_PORT_OUTPUT & _BV(LED_BIT)) != 0);
            usbMsgPtr = dataBuffer;         /* говорим драйверу, какие данные вернуть */
            return 1;                       /* говорим драйверу послать 1 байт */
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
	else
	{
        /* вызовы запросов USBRQ_HID_GET_REPORT и USBRQ_HID_SET_REPORT не реализованы,
         *  поскольку мы их не вызываем. Операционная система также не будет обращаться к ним, 
         *  потому что наш дескриптор не определяет никакого значения.*/
    }
    return 0;   /* default для нереализованных запросов: не возвращаем назад данные хосту */
}
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  Function For disable all leds on PORTC
void DisableLeds(void){    
    //led1 &=~_BV(0);//=0;
    //PORTC0 =0;
	//sbi(PORTC,0);
	//led2 |= _BV(1);//=1;
    //led3 |= _BV(1);//=1;
    //led4 |= _BV(1);// =1;
    PORTC=0xC4;
}
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  Function For 
void DoCommand(long int comm)
{    
    char buff[BUFF_SIZE];
    LCDGotoXY(0,1);
    memset(buff,' ',BUFF_SIZE);
    switch(comm)  
    {
        case 1:	sprintf(buff,"EECR%d:EEARH%d",EECR,EEARH);
                break;
        case 2: sprintf(buff,"PA-%d:PB-%d",PINA,PINB);
                break;
        case 3: sprintf(buff,"PC-%d:PD-%d",PINC,PIND);
                break;
        case 11:sprintf(buff,"UBRRH%d:UCSRC%d",UBRRH,UCSRC); 
                break;
        case 12:sprintf(buff,"SREG-%d:SPH-%d",SREG,SPH); 
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
        case 32:sprintf(buff,"Hello Alexey");
                break;
        case 33:sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR); 
                break; 
        default:sprintf(buff,"Comm %ld",comm); 
    }  
    LCDprint(buff,sizeof(buff));
    
}
/* ------------------------------------------------------------------------- */

int main(void)
{
    char command[MAX_COMMAND_SIZE];
    long prev_comm=0;
    int command_pos = 0;
    int del_size = DEL_CYCLE;
	
	PORTA=0x00;
	DDRA=0xff;
	PORTB=0x01;
	DDRB=0x01;
	DDRC=0xC5;
	PORTC=0xC4;

	GICR|=0x40;
	MCUCR=0x00;
	EMCUCR=0x00;
	GIFR=0x40;
	TIMSK=0x00;

	ACSR=0x80;
	SFIOR=0x00;
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
    for(;;){
        usbPoll();
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
               
        if(prev_comm)
                DoCommand(prev_comm);
        
        if(bit_is_clear(PINC,btn4))
		{               
			LCDclr();
            prev_comm=  atol(command);
            DoCommand(prev_comm);    
            memset(command,' ',MAX_COMMAND_SIZE);
            command_pos = 0;  
            _delay_ms(del_size*30);
        }

		//DisableLeds();
    }
    return 0;
}

/* ------------------------------------------------------------------------- */
