# Сконфигурируйте следующие определения в соответствии с Вашей системой.
# Этот Makefile протестирован на Mac OS X, Linux и Windows.

# FOR LINUX USAGE
#USBFLAGS = `libusb-config --cflags`
#USBLIBS = `libusb-config --libs`
#EXE_SUFFIX =

# Используйте следующие 3 строки на Windows и закомментируйте 3 предыдущие. Вы можете 
#  изменить пути include для соответствия месту установки libusb-win32
#USBFLAGS = -I/usr/local/include
USBFLAGS = -I"c:/Program Files/LibUSB-Win32/include"
#USBLIBS = -L/usr/local/lib -lusb
USBLIBS = -L"c:/Program Files/LibUSB-Win32/lib/gcc" -lusb
#EXE_SUFFIX = .exe 

NAME = set-led

OBJECTS = opendevice.o $(NAME).o

CC		= gcc
CFLAGS	= $(CPPFLAGS) $(USBFLAGS) -O -g -Wall
LIBS	= $(USBLIBS)

PROGRAM = $(NAME)$(EXE_SUFFIX)


all: $(PROGRAM)

.c.o:
	$(CC) $(CFLAGS) -c $<

$(PROGRAM): $(OBJECTS)
	$(CC) -o $(PROGRAM) $(OBJECTS) $(LIBS)

strip: $(PROGRAM)
	strip $(PROGRAM)

clean:
	rm -f *.o $(PROGRAM)
