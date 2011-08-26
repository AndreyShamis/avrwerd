DEVICE=atmega8515
F_CPU=16000000
AVRDUDE = avrdude -c usbasp -p $(DEVICE)
#FUSE_L  = ff
#FUSE_H  = 09
CFLAGS  = -Iusbdrv -I. 
OBJECTS = usbdrv/usbdrv.o usbdrv/usbdrvasm.o usbdrv/oddebug.o lcd_lib.o main.o
COMPILE = avr-gcc -Wall -Os -gstabs -DF_CPU=$(F_CPU) $(CFLAGS) -mmcu=$(DEVICE)
help:
	@echo "This Makefile has no default rule. Use one of the following:"
	@echo "make hex ....... to build main.hex"
	@echo "make program ... to flash fuses and firmware"
	#@echo "make fuse ...... to flash the fuses"
	@echo "make flash ..... to flash the firmware"
	@echo "make clean ..... to delete objects and hex file"
	
hex: main.hex

program: flash

# правило для прошивки firmware:
flash: main.hex
	$(AVRDUDE) -U flash:w:main.hex:i
#	$(JTAGICEII) -pf -if main.hex 
	
# правило для удаления файлов зависимостей (которые могут быть построены утилитой Make):
clean:
	rm -f main.hex main.lst lcd.o lcd_lib.o main.obj main.cof main.list main.map main.eep.hex main.elf *.o usbdrv/*.o main.s usbdrv/oddebug.s usbdrv/usbdrv.s
#	rm -f usbdrv/*.*
#	rmdir usbdrv 
	
# Обычное (generic) правило для компилирования файлов на языке C:
.c.o:
	$(COMPILE) -c $< -o $@

# Обычное (generic) правило для компиляции файлов на языке ассемблера:
.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" не должен быть необходим, поскольку тип файлов
#  с расширением .S (здесь заглавная S) задан по умолчанию. Однако, символы 
#  в верхнем регистре не всегда сохраняются в именах на Windows. Чтобы обеспечить
#  совместимость с WinAVR задайте тип файла вручную. 

# Generic правило для компилирования файлов языка C в ассемблер, успользуется только для отладки.
.c.s:
	$(COMPILE) -S $< -o $@

main.elf: usbdrv $(OBJECTS)	# зависимость (dependency) usbdrv нужна только для копирования
	$(COMPILE) -o main.elf $(OBJECTS)

main.hex: main.elf
	rm -f main.hex main.eep.hex
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	avr-objcopy --debugging -O coff-ext-avr $< main.cof
	avr-size main.hex

# цели отладки:
disasm:	main.elf
	avr-objdump -d main.elf

cpp:
	$(COMPILE) -E main.c
# правило для программирования бит фьюзов:
fuse:
	@[ "$(FUSE_H)" != "" -a "$(FUSE_L)" != "" ] || \
		{ echo "*** Edit Makefile and choose values for FUSE_L and FUSE_H!"; exit 1; }
#	$(AVRDUDE) -U hfuse:w:$(FUSE_H):m -U lfuse:w:$(FUSE_L):m
	$(JTAGICEII) -f 0x$(FUSE_H)$(FUSE_L) 
	