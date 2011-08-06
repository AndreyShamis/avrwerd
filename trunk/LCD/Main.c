#define F_CPU 8000000UL  // 8 MHz

#include <stdlib.h>
#include "hd44780.h"
#include <avr/io.h>
#include <util/delay.h>




// ����� ������
void lcd_puts(const char *s)
{
    register char c;

    while ( (c = *s++) ) {
        HD44780_SEND_CHAR(c);
    }

}

int main(void)    
{    

	// �������������� �����
	hd44780_init();

	// ������������� � ����� ������� ����� ��������
	HD44780_SEND_CURSOR_POS(0, 0);

	// ������� ��� �����
	lcd_puts("Counter");

	// ���� ����� ������� ������ 1 ������ �� ����� ���:
	// HD44780_SEND_CHAR('C');
	//11111101
	DDRC = 0xc5;   
	DDRA = 0xFF;
	


	PORTC &=~_BV(PC0);
	PORTC |=_BV(PC2);
	PORTC |=_BV(PC6);
	PORTC |=_BV(PC7);
	_delay_ms(250); 
	while (1) 
	{         

//		PORTC |=1<<0; /// 0xff; 

		//_delay_ms(250);  

		//PORTC &=~1<<0;//0x00;  
		//_delay_ms(250);   
		//PORTC &=~1<<0;//0x00;  
		//_delay_ms(10);
		if((~PINC) &(1<<1))
		{

			PORTC |=_BV(PC0);//0x00;   
			PORTC |=_BV(PC2);//0x00;   
			PORTC |=_BV(PC6);
			//PORTC &=1<<2; /// 0xff; 
			//_delay_ms(100); 	

		}
		else if((~PINC)&(1<<3))
		{
			PORTC &=~_BV(PC0);//0x00;  
			PORTC &=~_BV(PC2);//0x00;  		
		}
		else if((~PINC)&(1<<4))
		{
			PORTC &=~_BV(PC0);
			PORTC |=_BV(PC2);		
			PORTC &=~_BV(PC7);	//	On LD Left		
		}
		else if((~PINC)&(1<<5))
		{
			PORTC |=_BV(PC0);
			PORTC &=~_BV(PC2);	
			PORTC &=~_BV(PC6);		
			PORTC |=_BV(PC7);		
		}
		//else
		//{
		//	PORTC |=1<<0; /// 0xff; 

//			_delay_ms(10);  
	//	}
		//PORTC &=1<<0;
		//PORTC |=1<<2;
	}
} 