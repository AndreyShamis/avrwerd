/*****************************************************
Chip type               : ATmega8515L
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*****************************************************/

#define DEL_START           45  //  delay leds start
#define DEL_CYCLE           25  //  delay in each cycle        
#define MAX_COMMAND_SIZE    5   //  Max command size
#define BUFF_SIZE           17
//  Button section
#define btn1 PINC.1
#define btn2 PINC.3
#define btn3 PINC.5
#define btn4 PINC.4

//  Led section
#define led1 PORTC.0
#define led2 PORTC.2
#define led3 PORTC.6
#define led4 PORTC.7
//-----------------------------------------------------------------------------
#include <mega8515.h>
#include <stdlib.h>
#include <string.h>
#include <delay.h>
#include <stdio.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  Function For 
void DoCommand(unsigned int comm)
{    
    char buff[BUFF_SIZE];
    lcd_gotoxy(0,1);
    memset(buff,0,BUFF_SIZE);
    switch(comm)  
    {
        case 1:
               sprintf(buff,"EECR-%d:EEARH-%d",EECR,EEARH);
                break;
        case 2:
                 sprintf(buff,"PINA-%d:PINB-%d",PINA,PINB);
                break;
        case 3:
               sprintf(buff,"PINC-%d:PIND-%d",PINC,PIND);
                break;
        case 11:
                sprintf(buff,"UBRRH-%d:UCSRC-%d",UBRRH,UCSRC); 
                break;
        case 12:
               sprintf(buff,"SREG-%d:SPH-%d",SREG,SPH); 
                break;   
                
        case 13:
               sprintf(buff,"EECR-%d:EEARH-%d",EECR,EEARH);
                break;
        case 21:
                sprintf(buff,"CR-%d:CSR-%d",MCUCR,MCUCSR);  
                break;
        case 22:
               sprintf(buff,"SPH-%d:SPL-%d",SPH,SPL);
                break;
        case 23:
                sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR); 
                break;
        case 31:
                sprintf(buff,"ACSR%d:OSAL%d",ACSR,OSCCAL);  
                break;
    //    case 32:
     //          sprintf(buff,"SPH-%d:SPL-%d",SPH,SPL);
    //            break;
    //    case 33:
    //            sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR); 
    //            break;  
    } 
    /*
    if(comm == 1){
            sprintf(buff,"EECR-%d:EEARH-%d",EECR,EEARH);                                 
    }
    else if(comm == 2){
            sprintf(buff,"PINA-%d:PINB-%d",PINA,PINB);                          
    }
    else if(comm == 3){
            sprintf(buff,"PINC-%d:PIND-%d",PINC,PIND);                          
    }
    else if(comm == 11){
            sprintf(buff,"UBRRH-%d:UCSRC-%d",UBRRH,UCSRC);        
    }                                                         
    else if(comm == 12){
            sprintf(buff,"SREG-%d:SPH-%d",SREG,SPH);              
    }                                                         
    else if(comm == 13){
            sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR);        
    }
    else if(comm == 21){
            sprintf(buff,"CR-%d:CSR-%d",MCUCR,MCUCSR);                          
    }
    else{
            sprintf(buff,"Comm:%d",comm);  
    }      */   
    lcd_puts(buff);
    
}
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  Function For disable all leds on PORTC
void DisableLeds()
{    
    led1 =0;
    led2 =1;
    led3 =1;
    led4 =1;
   // PORTC=0x1C;
}

//-----------------------------------------------------------------------------
//  Main function
void main(void)
{
    //char buff[17];
    char command[MAX_COMMAND_SIZE];
    short prev_comm=0;
    int command_pos = 0;
//    int counter = 0;
    int del_size = DEL_CYCLE;
    unsigned int wh_c=1;
    PORTA=0x00;
    DDRA=0xff;
    //PORTB=0x00;
    //DDRB=0x00;
    DDRC=0xC5;
    PORTC=0x01;
    //PORTD=0x00;
    //DDRD=0x00;
    //PORTE=0x00;
    //DDRE=0x00;
    // Timer/Counter 0 initialization // Clock source: System Clock
    // Clock value: Timer 0 Stopped // Mode: Normal top=FFh
    // OC0 output: Disconnected
    //TCCR0=0x00;
    //TCNT0=0x00;
    //OCR0=0x00;

    // Timer/Counter 1 initialization   // Clock source: System Clock
    // Clock value: Timer1 Stopped      // Mode: Normal top=FFFFh
    // OC1A output: Discon.             // OC1B output: Discon.
    // Noise Canceler: Off              // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off   // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off   // Compare B Match Interrupt: Off
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
    // INT0: Off// INT1: Off// INT2: Off
    //MCUCR=0x00;
    //EMCUCR=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;

    // Analog Comparator initialization // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;

    SFIOR=0x00;

    // LCD module initialization
    lcd_init(16);
    lcd_clear();        /* очистка дисплея */
    lcd_gotoxy(7,0);        /* верхняя строка, 4 позиция */
    lcd_putsf("LCD");/* выводим надпись в указанных координатах */
    DisableLeds();
    delay_ms(DEL_START);
/*        
    led1 =1;    
    delay_ms(DEL_START);
    DisableLeds();
		
    led2 =0;
    delay_ms(DEL_START);
    DisableLeds();
        
    led3 =0;
    delay_ms(DEL_START);
    DisableLeds();
        
    led4 =0;   
    delay_ms(DEL_START);
    DisableLeds();      
*/
    while (wh_c < 1000){   
        wh_c++;
        if(wh_c%20==0)  led1    = 1;
        else            led1    = 0;
    
        if(wh_c > 500){
            lcd_clear();
            lcd_gotoxy(0,0); 
            delay_ms(10);        
            wh_c = 1;
        }
          
        delay_ms(del_size);

        if(command_pos < MAX_COMMAND_SIZE-1 && ( btn1 == 0 || btn2 == 0 || btn3 == 0)){
            if(btn1 == 0)
                command[command_pos] = '1';
            else if(btn2 == 0)            
                command[command_pos] = '2';
            else
                command[command_pos] = '3';
            command_pos++;
        }                 
                
        if(prev_comm)
        {
                DoCommand(prev_comm);
        }
        if(btn4 == 0){        
            //short int ind;       
            lcd_clear(); 
            prev_comm=  atoi(command);
            DoCommand(prev_comm);
 //           lcd_gotoxy(0,1);
            //sprintf(buff,"EECR-%d:EEARH-%d",EECR,EEARH);                          
//            lcd_puts(buff);
    
            memset(command,0,MAX_COMMAND_SIZE);
            //for(ind=0;ind<MAX_COMMAND_SIZE;ind++){
            //    command[ind] = 0;
            //}
            command_pos = 0;
        }

        //lcd_clear();
        lcd_gotoxy(0,0);                         
        lcd_puts(command);
        /*
        if(btn1 == 0 && btn3 == 0){
            lcd_clear();
            lcd_gotoxy(0,0); 
            sprintf(buff,"wh_c:%d",wh_c);                          
            lcd_puts(buff);
            lcd_gotoxy(0,1);
            sprintf(buff,"EECR-%d:EEARH-%d",EECR,EEARH);                          
            lcd_puts(buff);
        
        }
        else if(btn1 == 0 && btn2 == 0){
            lcd_clear();
            lcd_gotoxy(0,0); 
            sprintf(buff,"PINA-%d:PINB-%d",PINA,PINB);                          
            lcd_puts(buff);
            lcd_gotoxy(0,1);
            sprintf(buff,"PINC-%d:PIND-%d",PINC,PIND);                          
            lcd_puts(buff);
        
        }
        else if(btn1 == 0){     
            lcd_clear();
            DisableLeds();
			led1 =1;
            lcd_gotoxy(0,0); 
            sprintf(buff,"UBRRH-%d:UCSRC-%d",UBRRH,UCSRC);                          
            lcd_puts(buff);
              
            lcd_gotoxy(0,1);   
            lcd_putsf("Andrey Shamis");

		}
		else if(btn2 == 0){
            DisableLeds();
    		led2 = 0; //0-On ; 1 - off
            lcd_clear();	
            lcd_gotoxy(0,0);     
            sprintf(buff,"SREG-%d:SPH-%d",SREG,SPH);                          
            lcd_puts(buff);
            lcd_gotoxy(0,1);
            sprintf(buff,"GICR-%d:GIFR-%d",GICR,GIFR);                          
            lcd_puts(buff) ;
		}    
		else if(btn4==0){                 
            DisableLeds();
			led4 = 0;
		}
        else if(btn3==0){     
            DisableLeds();
            led3 = 0; 
            lcd_clear();	
            lcd_gotoxy(0,0);   
            sprintf(buff,"%x:SPL-%d",counter,SPL);                          
            lcd_puts(buff);     
            lcd_gotoxy(0,1);   
            sprintf(buff,"CR-%d:CSR-%d",MCUCR,MCUCSR);                          
            lcd_puts(buff);     
            counter++;
                         
            if(del_size > 5){
                del_size--;
            }
        }   
        else{
            DisableLeds(); 
            del_size = DEL_CYCLE;
        } 
        
        */
    }
}
