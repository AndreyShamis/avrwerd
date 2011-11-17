
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <usb.h>        /* ��� libusb */
#include "opendevice.h" /* ����� ��� ��������� � ��������� ������ */

#include "../requests.h"   /* ������ custom request */
#include "../usbconfig.h"  /* ����� � VID/PID ���������� */

#define MSG_OPT 	USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN

static void usage()
{
    fprintf(stderr, "usage:\n");
    fprintf(stderr, "  onX 		- turn on LED\n");
    fprintf(stderr, "  offX 		- turn off LED\n");
    fprintf(stderr, "  status 	- ask current status of LED\n");
	fprintf(stderr, "  q 		- Exit\n");
}

int main(int argc, char **argv)
{
	usb_dev_handle      *handle = NULL;
	const unsigned char 	rawVid[2] 	= {USB_CFG_VENDOR_ID}, 
							rawPid[2] 	= {USB_CFG_DEVICE_ID};
	char                	vendor[] 	= {USB_CFG_VENDOR_NAME, 0}, 
							product[] 	= {USB_CFG_DEVICE_NAME, 0};
	char                buffer[4];
	int                 cnt, vid, pid, isOn;
	char				command[10];

    usb_init();

    /* ��������� VID/PID �� usbconfig.h, ��� ��� ��� ����������� �������� ���������� */
    vid = rawVid[1] * 256 + rawVid[0];
    pid = rawPid[1] * 256 + rawPid[0];
	//usb_set_configuration(handle, 1);
	//usb_claim_interface(handle, 0);
	//int result = (int)usb_strerror();
	//printf("DDDD: %d\n", result);
    /* ��������� ������� ����������� � opendevice.c: */
    if(usbOpenDevice(&handle, vid, vendor, pid, product, NULL, NULL, NULL) != 0)
	{
        fprintf(stderr, "Could not find USB device \"%s\" with vid=0x%x pid=0x%x\n", product, vid, pid);
        exit(1);
    }
	int inf_res =0;
	inf_res = usb_set_configuration(handle, 1	);
	printf("error on %d : %s\n",inf_res, usb_strerror());
	inf_res = usb_claim_interface(handle, 0);
	printf("error on %d: %s\n",inf_res, usb_strerror());
	scanf("%s",command);
	while(strcasecmp(command, "q"))
	{	
		if(strcasecmp(command, "status") == 0)
		{
			cnt = usb_control_msg(handle, MSG_OPT, CUSTOM_RQ_GET_STATUS, 0, 0, buffer, sizeof(buffer), 5000);
			if(cnt < 1)
			{
				if(cnt < 0)
					fprintf(stderr, "USB error: %s\n", usb_strerror());
				else
					fprintf(stderr, "only %d bytes received.\n", cnt);
			}
			else
			{
				printf("LED is %s\n", buffer[0] ? "on" : "off");
			}
		}
		else if( (isOn = (strcasecmp(command, "on1") == 0)) || strcasecmp(command, "off1") == 0)
		{
			cnt = usb_control_msg(handle, MSG_OPT, CUSTOM_RQ_SET_STATUS, isOn, 0, buffer, 0, 5000);
			//if(cnt < 0)	fprintf(stderr, "USB error: %s.CNT:%d\n", usb_strerror(),cnt);
		}
		else if( (isOn = (strcasecmp(command, "on2") == 0)) || strcasecmp(command, "off2") == 0)
		{
		
			cnt = usb_control_msg(handle, MSG_OPT, CUSTOM_RQ_SET_STATUS10, !isOn, 0, buffer, 0, 5000);
			//if(cnt < 0)fprintf(stderr, "USB error: %s\n", usb_strerror());
		}
		else if(strcasecmp(command, "buba") == 0)
		{	
			char mess = 'a'; 

			//}usb_interrupt_write

			//{usb_bulk_write
			//void *cont = NULL;
			//usb_bulk_setup_async(handle,&cont,0x80);
			 usb_clear_halt(handle, 0);
			 printf("error on : %s\n", usb_strerror());
				cnt = usb_bulk_write(handle, 0x00, mess, sizeof(mess),  2000);
				printf("error on : %s\n", usb_strerror());
				printf("usb_bulk_write %d\n", cnt);
				
				cnt = usb_interrupt_write(handle, 0x01, mess, sizeof(mess),  2000);
				printf("error on : %s\n", usb_strerror());
				printf("usb_bulk_write %d\n", cnt);
				
				cnt = usb_interrupt_write(handle, 0x02, mess, sizeof(mess),  2000);
				printf("error on : %s\n", usb_strerror());
				printf("usb_bulk_write %d\n", cnt);
				
				cnt = usb_bulk_write(handle, 0x03, mess, sizeof(mess),  2000);
				printf("error on : %s\n", usb_strerror());
				printf("usb_bulk_write %d\n", cnt);
				
				cnt = usb_bulk_write(handle, USB_DT_ENDPOINT, mess, sizeof(mess),  2000);
				printf("error on : %s\n", usb_strerror());
				printf("usb_bulk_write %d\n", cnt);

		}
		else 
		{
			cnt = usb_control_msg(handle, MSG_OPT, 6, atoi(command), 0, buffer, 0, 5000);
			usage(argv[0]);
		}
		
		scanf("%s",command);
	}
    usb_close(handle);
    return 0;
}
