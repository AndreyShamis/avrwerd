//******************************************************************************
//
//  Author(s)...: Pashgan    http://ChipEnable.Ru   
//
//  Target(s)...: atmega16
//
//  Compiler....: CodeVision 2.05
//
//  Description.: Универсальный драйвер матричной клавиатуры. Тестовый проект
//
//  Data........: 12.10.2011
//
//******************************************************************************
#include <io.h>
#include <delay.h>
#include "keyboard.h"
#include "lcd_lib.h"

unsigned char buf = 0;

void main( void )
{
  LCD_Init(); 
  LCD_Goto(0,0);
  LCD_SendString("CV Key: "); 
  KEYB_Init();
  
  while(1){
     delay_ms(10);
     KEYB_ScanKeyboard();
     buf = KEYB_GetKey();
     if (buf){
       LCD_Goto(9,0);
       LCD_WriteData(buf); 
     }
  }
}
