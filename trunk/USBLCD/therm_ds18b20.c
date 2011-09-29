#include "therm_ds18b20.h"

#include <util/delay.h>	//Header for _delay_ms()

int tempt=0;
uint8_t therm_reset()
{
	uint8_t i;
	//Pull line low and wait for 480uS
	THERM_LOW();
	THERM_OUTPUT_MODE();
	_delay_us(430);	//480 //this must be smaller when moving delay func to other .c file
	//Release line and wait for 60uS
	THERM_INPUT_MODE();
	_delay_us(60); //60
	//Store line value and wait until the completion of 480uS period
	i=(THERM_PIN & (1<<THERM_DQ));
	_delay_us(420); //420
	//Return the value read from the presence pulse (0=OK, 1=WRONG)
	return i;
}

void therm_write_bit(uint8_t bit)
{
	//Pull line low for 1uS
	THERM_LOW();
	THERM_OUTPUT_MODE();
	_delay_us(1);//1
	//If we want to write 1, release the line (if not will keep low)
	if(bit) THERM_INPUT_MODE();
	//Wait for 60uS and release the line
	_delay_us(50);//60
	THERM_INPUT_MODE();
}

uint8_t therm_read_bit(void)
{
	uint8_t bit=0;
	//Pull line low for 1uS
	THERM_LOW();
	THERM_OUTPUT_MODE();
	_delay_us(1);//1
	//Release line and wait for 14uS
	THERM_INPUT_MODE();
	_delay_us(10);//14
	//Read line value
	if(THERM_PIN&(1<<THERM_DQ)) bit=1;
	//Wait for 45uS to end and return read value
	_delay_us(40);//45
	return bit;
}

uint8_t therm_read_byte(void)
{
	uint8_t i=8, n=0;
	while(i--)
	{
		//Shift one position right and store read value
		n>>=1;
		n|=(therm_read_bit()<<7);
	}
	return n;
}

void therm_write_byte(uint8_t byte)
{
	uint8_t i=8;
	while(i--)
	{
		//Write actual bit and shift one position right to make the next bit ready
		therm_write_bit(byte&1);
		byte>>=1;
	}
}

void therm_read_temperature(char *buffer)
{
	// Buffer length must be at least 12bytes long! ["+XXX.XXXX C"]
	uint8_t temperature[2];
	int8_t digit;
	int tall=0;
	int tall2=0;
	int neg=0;
	uint16_t decimal;
	//Reset, skip ROM and start temperature conversion
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_CONVERTTEMP);
	//Wait until conversion is complete
	while(!therm_read_bit());
	//Reset, skip ROM and send command to read Scratchpad
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_RSCRATCHPAD);
	//Read Scratchpad (only 2 first bytes)
	temperature[0]=therm_read_byte();
	temperature[1]=therm_read_byte();
	therm_reset();
	//Store temperature integer digits and decimal digits

    neg =0;
	tall=temperature[0];
	tall2=temperature[1];
	tempt=tall2*256+tall;
	tall2=tall2%16;
	tall2 =tall2*16;
	//if (tall2>0){tall2=128;}
	//tall=0b111111101;

	decimal=10000/16*(tall%16);
	//if(decimal>1){decimal=1;}
	digit=tall/16+tall2;
	if(digit<0){decimal = 10000-decimal;neg = 1;}
	if(decimal==10000){decimal=0;}
    if(decimal>0&neg==1){digit=digit+1;}
	if(neg==1){digit=digit*(-1);}

	//tempt=digit*16;

	//tempt=tempt+tall%16;
	
	if(neg<1)sprintf(buffer, "%+d.%01uC", digit, decimal/1000);
	if(neg>0)sprintf(buffer, "-%d.%01uC", digit, decimal/1000);
}

int tempra(void){
return  tempt;
}

void therm_read_temperature2(int8_t *digi, uint16_t *deci)
{
	// Buffer length must be at least 12bytes long! ["+XXX.XXXX C"]
	uint8_t temperature[2];
	int8_t digit;
	uint16_t decimal;
	//Reset, skip ROM and start temperature conversion
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_CONVERTTEMP);
	//Wait until conversion is complete
	while(!therm_read_bit());
	//Reset, skip ROM and send command to read Scratchpad
	therm_reset();
	therm_write_byte(THERM_CMD_SKIPROM);
	therm_write_byte(THERM_CMD_RSCRATCHPAD);
	//Read Scratchpad (only 2 first bytes)
	temperature[0]=therm_read_byte();
	temperature[1]=therm_read_byte();
	therm_reset();
	//Store temperature integer digits and decimal digits
	digit=temperature[0]>>4;
	digit|=(temperature[1]&0x7)<<4;
	//Store decimal digits
	decimal=temperature[0]&0xf;
	decimal*=THERM_DECIMAL_STEPS_12BIT;
	//results
	*digi = digit;
	*deci = decimal;
}

