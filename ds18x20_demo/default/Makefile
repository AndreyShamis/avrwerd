###############################################################################
# Makefile for the project ds1820_demo
###############################################################################

## General Flags
PROJECT = ds1820_demo
MCU = atmega324p
TARGET = ds1820_demo.elf
CC = avr-gcc

CPP = avr-g++

## Options common to compile, link and assembly rules
COMMON = -mmcu=$(MCU)

## Compile options common for all C compilation units.
CFLAGS = $(COMMON)
CFLAGS += -Wall -gdwarf-2 -std=gnu99 -Wextra -pedantic -ffunction-sections -fdata-sections   -fno-inline-small-functions  -DF_CPU=16000000UL -Os -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CFLAGS += -MD -MP -MT $(*F).o -MF dep/$(@F).d 

## Assembly specific flags
ASMFLAGS = $(COMMON)
ASMFLAGS += $(CFLAGS)
ASMFLAGS += -x assembler-with-cpp -Wa,-gdwarf2

## Linker flags
LDFLAGS = $(COMMON)
LDFLAGS += -Wl,--gc-sections -Wl,-Map=ds1820_demo.map


## Intel Hex file production flags
HEX_FLASH_FLAGS = -R .eeprom -R .fuse -R .lock -R .signature

HEX_EEPROM_FLAGS = -j .eeprom
HEX_EEPROM_FLAGS += --set-section-flags=.eeprom="alloc,load"
HEX_EEPROM_FLAGS += --change-section-lma .eeprom=0 --no-change-warnings


## Libraries
LIBS = -lm 

## Objects that must be built in order to link
OBJECTS = uart.o crc8.o ds18x20.o main.o onewire.o uart_addon.o 

## Objects explicitly added by the user
LINKONLYOBJECTS = 

## Build
all: $(TARGET) ds1820_demo.hex ds1820_demo.eep ds1820_demo.lss size

## Compile
uart.o: ../uart.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

crc8.o: ../crc8.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

ds18x20.o: ../ds18x20.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

main.o: ../main.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

onewire.o: ../onewire.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

uart_addon.o: ../uart_addon.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

##Link
$(TARGET): $(OBJECTS)
	 $(CC) $(LDFLAGS) $(OBJECTS) $(LINKONLYOBJECTS) $(LIBDIRS) $(LIBS) -o $(TARGET)

%.hex: $(TARGET)
	avr-objcopy -O ihex $(HEX_FLASH_FLAGS)  $< $@

%.eep: $(TARGET)
	-avr-objcopy $(HEX_EEPROM_FLAGS) -O ihex $< $@ || exit 0

%.lss: $(TARGET)
	avr-objdump -h -S $< > $@

size: ${TARGET}
	@echo
	@avr-size -C --mcu=${MCU} ${TARGET}

## Clean target
.PHONY: clean
clean:
	-rm -rf $(OBJECTS) ds1820_demo.elf dep/* ds1820_demo.hex ds1820_demo.eep ds1820_demo.lss ds1820_demo.map


## Other dependencies
-include $(shell mkdir dep 2>NUL) $(wildcard dep/*)

